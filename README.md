 # AWS Multi-Region Infrastructure Deployment

This repository contains Terraform configurations for managing AWS infrastructure across two regions (ap-south-1 and ap-southeast-1) using **AWS Control Tower** for account management. The deployment process is automated using GitHub Actions workflows.

## AWS Account Structure

This project utilizes **AWS Control Tower** for managing multiple AWS accounts with standardized security and compliance settings:

### 1. Production Account

   - Used for production deployments
   - Deployed using main branch
   - Managed through AWS Control Tower
   - Implements strict security policies and compliance controls

### 2. Staging Account

   - Used for testing and validation
   - Deployed using Staging branch
   - Managed through AWS Control Tower
   - Mirrors production setup for accurate testing

## Infrastructure Overview

The project manages infrastructure in two AWS regions:
- ***Region 1:*** ap-south-1 (Mumbai)
- ***Region 2:*** ap-southeast-1 (Singapore)

## Prerequisites

1. AWS Account with Control Tower setup
2. GitHub Account
3. Terraform installed locally (for manual operations)
4. Appropriate AWS credentials with necessary permissions for both Production and Staging accounts
5. multiple AMI'S for multiple regions (Most imp)
6. multiple remote backends (s3+ dynamodb ) (Most Imp)

## Environment Setup ( Required Secrets )

### 1. Production Environment (Control Tower Production Account)
- AWS_ACCESS_KEY_ID_PROD
- AWS_SECRET_ACCESS_KEY_PROD

**NOTE:** Create an IAM user github-actions-prod in your Production account with necessary permissions. Generate access keys and add them to GitHub repository secrets with the above names.

### 2. Staging Environment (Control Tower Staging Account)
- AWS_ACCESS_KEY_ID_STAGING
- AWS_SECRET_ACCESS_KEY_STAGING

**NOTE:** Create an IAM user github-actions-staging in your Staging account with necessary permissions. Generate access keys and add them to GitHub repository secrets with the above names.

![Add AWS Credentials](https://github.com/Sompandey01/images/blob/0022ebe598ad0d40db423edee452683b6def67fd/Screenshot%20(250).png)

## Deployment Process
### Manual Triggers:
The workflow can be manually triggered with the following actions:

- ***deploy-region1:*** Deploy infrastructure in ap-south-1
- ***deploy-region2:*** Deploy infrastructure in ap-southeast-1
- ***destroy-region1:*** Destroy infrastructure in ap-south-1
- ***destroy-region2:*** Destroy infrastructure in ap-southeast-1

## Manual Deployment Steps

1. Go to the "Actions" tab in your GitHub repository
2. Select "Deploy AWS Infrastructure" workflow
3. Click "Run workflow"
4. Choose the desired action from the dropdown menu
5. Click "Run workflow"

![Run GitHub Workflow](https://github.com/Sompandey01/images/blob/0022ebe598ad0d40db423edee452683b6def67fd/Screenshot%20(249).png)

## Environment Management
The workflow automatically determines the environment and corresponding AWS account based on the branch:

- ***main branch*** → Production environment (Control Tower Production Account)
- ***Staging branch*** → Staging environment (Control Tower Staging Account)

## Security Notes

1. AWS credentials are stored as GitHub secrets
2. Credentials are automatically managed based on the environment
3. Debug logs mask sensitive credential information

## Troubleshooting

1. Ensure you have the correct AWS account credentials
2. Verify Control Tower guardrails are not blocking your deployment
3. Check GitHub Actions logs for detailed error messages
4. Verify branch-environment mapping
