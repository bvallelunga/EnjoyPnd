Parse.Cloud.define("jobs.cancelled", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")

  if(!webhook) {
    return res.success()
  }

  Parse.Cloud.httpRequest({
    url: webhook,
    method: "post",
    data: {
      success: true,
      type: "job.cancelled",
      reason: "Carrier aborted during route"
    }
  }).then(function(response) {
    res.success()
  }, function(error) {
    res.error(error)
  })
})
