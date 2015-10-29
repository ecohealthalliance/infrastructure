#!/usr/bin/env python
# Name: enable-cloudwatch.py
# Author: Freddie Rosario <rosario@ecohealthalliance.org>
# Purpose: Set cloudwatch alarms on all of the ec2 instances for monitoring purposes

import boto3

#Open connections and get EC2 and Cloudwatch data
client_ec2 = boto3.client('ec2')
client_cloudwatch = boto3.client('cloudwatch')
filters = [{'Name': 'instance-state-name','Values': ['running']}]
response = client_ec2.describe_instances(DryRun=False, Filters=filters)


#Populate list of running instance ID's
instance_id_list = []
for r in response['Reservations']:
  instance = r['Instances'][0]
  instance_id_list.append(instance['InstanceId'])


#Create cloud watch alarms for instances
for i in instance_id_list:

  #CPU Alarm
  client_cloudwatch.put_metric_alarm(
    AlarmName=i + "-cpu",
    AlarmDescription=i + "-cpu",
    ActionsEnabled=True,
    AlarmActions=['arn:aws:sns:us-east-1:810686069923:infrastructure-monitoring'],
    MetricName='CPUUtilization',
    Namespace='AWS/EC2',
    Statistic='Average',
    Dimensions=[{u'Name': 'InstanceId', u'Value': i}],
    Period=300,
    EvaluationPeriods=1,
    Threshold=80.0,
    ComparisonOperator='GreaterThanOrEqualToThreshold'
  )

  #Status Check Alarm
  client_cloudwatch.put_metric_alarm(
    AlarmName=i + "-status-check",
    AlarmDescription=i + "-status-check",
    ActionsEnabled=True,
    AlarmActions=['arn:aws:sns:us-east-1:810686069923:infrastructure-monitoring'],
    MetricName='StatusCheckFailed',
    Namespace='AWS/EC2',
    Statistic='Maximum',
    Dimensions=[{u'Name': 'InstanceId', u'Value': i}],
    Period=60,
    EvaluationPeriods=2,
    Threshold=1.0,
    ComparisonOperator='GreaterThanOrEqualToThreshold'
  )

  print "Alarms set for: " + i


#Get elastic loadbalancer data
client_lb = boto3.client('elb')
resp = client_lb.describe_load_balancers()


#Populate list of elastic loadbalancers
loadbalancer_list = []
for r in resp['LoadBalancerDescriptions']:
  loadbalancer_list.append(r['LoadBalancerName'])


#Create cloud watch alarms for loadbalancers
for lb in loadbalancer_list:
  
  #Healthy host count alarm
  client_cloudwatch.put_metric_alarm(
    AlarmName="lb-" + lb + "-healthy-hosts",
    AlarmDescription="minimum number of healthy instances",
    ActionsEnabled=True,
    AlarmActions=['arn:aws:sns:us-east-1:810686069923:infrastructure-monitoring'],
    MetricName='HealthyHostCount',
    Namespace='AWS/ELB',
    Statistic='Minimum',
    Dimensions=[{u'Name': 'LoadBalancerName', u'Value': lb}],
    Period=60,
    EvaluationPeriods=1,
    Threshold=1.0,
    ComparisonOperator='LessThanThreshold'
  )

  print "Alarms set for: lb-" + lb




#InfoNote for debugging later:
#alarms = client_cloudwatch.describe_alarms()
#a = alarms["MetricAlarms"][0]

#count = 0
#for m in alarms["MetricAlarms"]:
#  print count + ": " + m
#  count += 1

