# AWS-Cost-Optimization

Cost optimization in AWS involves a series of strategies and best practices aimed at reducing your cloud expenditure while maintaining or improving the performance of your applications.

## Problem statement
There are some EBS Volume and developer created multiple snapshorts . Later developer deleted the volume, EC2 instance. 
In both cases snapshorts are of no use.

### How to implement cost optimization in real time.

We used Lambda function > writen in python code(boto 3) > boto 3 will communicate with AWS API > python will communicate with AWS API > bring complete information for EBS snapshorts.

#### Explanation

Python code will connect with AWS API 
step1. Featch all the EBS Snapshorts
Step2. Filter out the snapshorts that stale (A snapshot is considered "stale" if it is old enough that it is no longer needed for operational purposes, backup, or recovery. )
step3. After identify the stale we will delete the snapshorts. 



##### Problem Statement Breakdown
EBS Volumes and Snapshots Context:

EBS (Elastic Block Store) volumes are used as storage devices in AWS EC2 instances.
Snapshots are point-in-time backups of these EBS volumes.
The problem arises when EBS volumes are deleted but their snapshots remain, incurring unnecessary costs.
Implementation Requirement:

The task requires the implementation of a solution that identifies and deletes these redundant snapshots to optimize costs.
Technical Implementation Steps
AWS Lambda Function
Purpose: Automate the process of identifying and deleting stale snapshots.
Implementation:
Language: Python
Library: Boto3 (AWS SDK for Python)
Detailed Steps
Fetch All EBS Snapshots

### Task: Use Boto3 to connect to the AWS API and list all EBS snapshots.
Code Sample:
python
Copy code
import boto3

def fetch_snapshots():
    ec2_client = boto3.client('ec2')
    snapshots = ec2_client.describe_snapshots(OwnerIds=['self'])['Snapshots']
    return snapshots
Filter Stale Snapshots

## Criteria: Define what constitutes a "stale" snapshot. This might be based on age, whether the volume it was taken from still exists, or if it’s no longer needed for backups or recovery.
Code Sample:
python
Copy code
from datetime import datetime, timedelta

def filter_stale_snapshots(snapshots, days_old=30):
    stale_snapshots = []
    cutoff_date = datetime.utcnow() - timedelta(days=days_old)
    
    for snapshot in snapshots:
        start_time = snapshot['StartTime']
        if start_time < cutoff_date:
            stale_snapshots.append(snapshot['SnapshotId'])
    
    return stale_snapshots
Delete Stale Snapshots

### Task: Use Boto3 to delete identified stale snapshots.
Code Sample:
python
Copy code
def delete_snapshots(snapshot_ids):
    ec2_client = boto3.client('ec2')
    for snapshot_id in snapshot_ids:
        ec2_client.delete_snapshot(SnapshotId=snapshot_id)
Lambda Handler Function

### Task: Integrate all steps into a Lambda handler function.
Code Sample:
python
Copy code
def lambda_handler(event, context):
    snapshots = fetch_snapshots()
    stale_snapshots = filter_stale_snapshots(snapshots)
    delete_snapshots(stale_snapshots)
    return {
        'statusCode': 200,
        'body': f"Deleted snapshots: {stale_snapshots}"
    }
Cost Optimization

### Outcome:
By deleting snapshots that are no longer needed, you reduce storage costs associated with EBS snapshots.
Real-time Implementation: This can be scheduled to run at regular intervals (e.g., daily or weekly) using CloudWatch Events to trigger the Lambda function.
Considerations

### Permissions:
Ensure the Lambda function has the necessary IAM roles and policies to describe and delete snapshots.
Testing: Thoroughly test the Lambda function in a development environment to ensure it correctly identifies and deletes only the stale snapshots.

### Logging:
Implement logging to monitor which snapshots are being deleted, which can help in auditing and troubleshooting.