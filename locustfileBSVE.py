# Name: locustfileBSVE.py
# Purpose: Use locust tool to load test the BSVE grits app
# Author: Freddie Rosario <rosario@ecohealthalliance.org>
# Usage: locust -f locustfileBSVE.py --host=https://grits-dev.ecohealthalliance.org
#        Visit http://localhost:8089 to see the webui after that

from locust import HttpLocust, TaskSet, task

class LoadTestTasks(TaskSet):
  @task
  def new(l):
    l.client.get("/new?compact=true&bsveAccessKey=loremipsumhello714902&hideBackButton=true", verify=False)

  @task
  def diagnose(l):
    l.client.post('/api/v1/public_diagnose', data={'api_key': 'grits28754', 'content': 'loadtest'}, verify=False)


class User(HttpLocust):
  task_set = LoadTestTasks

