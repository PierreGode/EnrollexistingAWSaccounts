
AWS TO Azure SSO setup
Azure SSO groups                                    Permission sets

Each prmission set has it's corresponding Azure Group for each account. 

<p>aws.Account.Administrators                  AWSAdministratorAccess Provides full access to AWS services and resources</p>

<p>aws.Account.PowerUsers                       AWSPowerUserAccess Provides full access to AWS services and resources, but does not allow management of Users and groups</p>

<p>aws.Account.ReadOnly                          AWSReadOnlyAccess This policy grants permissions to view resources and basic metadata across all AWS services</p>



# Control Tower Account Enrollment

To enable AWS governance using AWS Control Tower, all accounts need to be enrolled.
The enrollment is initiated by IT from Control Tower, but requires the enrolling account to allow
enrollment. This is done by creating a specific IAM [Role](https://docs.aws.amazon.com/controltower/latest/userguide/enroll-account.html) at can be assumed by the company top management account root.

The unregistered account are found in Tower : Organizational unit: Workloads
<p></p>
<h2>Procedure goes</h2> <p></p>
**Create specific IAM role from aws cli<p></p>
**Enroll account in AWS<p></p>
**Wait to the account to be enrolled.<p></p>
**Move account from Workloads to Imported Accounts<p></p>
**Verify no premision sets are broken/missing<p></p>
**Move account from Imported Accounts to Workloads Main prod/sdlc<p></p>

<h2> AWS CLI guide </h2>

CLI program found [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)



For each account to want to enroll you need to login via Terminal and aws configure sso and assign an account to get access to. <p></p>
name those accordingly: aacount1admin account2admin<p></p>
start to configure you login (SSO)
<p></p>

Go to https://company.awsapps.com/start#/ and get Command line or programmatic access. <p></p>
Follow option 2 Paste the following text in your AWS credentials file (typically located in ~/.aws/credentials) ( not aws_session_token! )<p></p>


copy section to
```
~/.aws/credentials
```

then execute:<p></p>

```
aws configure sso
```
<H2>sso config</H2>

name: account1<p></p>
url:
```
https://company.awsapps.com/start
```
region: <p></p>
```
eu-north-1
```
sso registration scopes:<p></p>
```
sso:account:access
```
<h2>After SSO Aprooval</h2>

CLI default client Region: <p></p>
```
eu-north-1
```
CLI default output format:<p></p>
```
text
```
CLI profile name: itadmin
```
itadmin
```
Each account added can be used separately an will be listed in: aws configure list-profiles  
<p></p>

The scripts in this folder simplify creation the required role using CloudFormation. The script needs to be run from a
command line that has AWS credentials allowing cretaing IAM roles configured.

<h2>To create role:</h2>

```
sh create-role.sh
```

The script will return before creation of the role has finished. To verify success<p></p>
This command can be run serveral times
         
```
sh check-progress.sh 
```
The output should look like this on a successful run:

```
            txt
            "ResourceType": "AWS::CloudFormation::Stack",
            "ResourceStatus": "CREATE_COMPLETE"
            "ResourceType": "AWS::IAM::Role",
            "ResourceStatus": "CREATE_COMPLETE",
            "ResourceType": "AWS::IAM::Role",
            "ResourceStatus": "CREATE_IN_PROGRESS",
            "ResourceType": "AWS::IAM::Role",
            "ResourceStatus": "CREATE_IN_PROGRESS",
            "ResourceType": "AWS::CloudFormation::Stack",
            "ResourceStatus": "CREATE_IN_PROGRESS",
```

<h2>Manual execution!</h2>

```
aws cloudformation create-stack --stack-name company-control-tower-account-enrollment --template-body file://./account-enrollment-role-template.yml --capabilities CAPABILITY_NAMED_IAM --profile itadmin
```
```
aws cloudformation describe-stack-events --stack-name company-control-tower-account-enrollment --profile itadmin --output json | jq '.' | grep "CREATE"
```
