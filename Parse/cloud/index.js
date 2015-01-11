var express = require('functions')
var app = express()

Parse.Cloud.useMasterKey()

var routes = {
  jobs: require("cloud/functions/jobs.js")
}

app.webhooks('/webhooks/job_cancelled', routes.jobs.job_cancelled)
app.webhooks('/webhooks/job_approved', routes.jobs.job_approved)
app.webhooks('/webhooks/job_enroute', routes.jobs.job_enroute)
app.webhooks('/webhooks/job_pending', routes.jobs.job_pending)

//app.all("*", routes.core.notfound)

app.listen()
