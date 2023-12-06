#!/bin/bash
aws cloudformation create-stack --stack-name company-control-tower-account-enrollment --template-body file://./account-enrollment-role-template.yml --capabilities CAPABILITY_NAMED_IAM --profile itadmin
