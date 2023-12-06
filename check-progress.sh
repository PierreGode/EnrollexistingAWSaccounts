#!/bin/bash
aws cloudformation describe-stack-events --stack-name company-control-tower-account-enrollment --profile itadmin --output json | jq '.'
aws cloudformation describe-stack-events --stack-name company-control-tower-account-enrollment --profile itadmin --output json | jq '.' | grep "CREATE"
