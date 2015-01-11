Parse.Cloud.define("job_Cancelled", function(req, res) { //requires the list of companies
console.log('%s', "start cancellation") //message confirmation
  var company = req.params.company
  //var company = req.param("company")
  //company.id = get.param("company")
  var webhook = company.get("webhook")
//add job id
  if(!webhook) {
    console.log('%s', "no webhook") //message confirmation
    return res.successT()
  }

  Parse.Cloud.httpRequest({
    url: webhook,
    method: "post",
    data: {
      success: true,
      type: "job.cancelled",
      reason: "Carrier aborted during route"
    } 
  } 
  ).then(function(response) {
    res.successT()
    console.log('%s', "job cancelled success") //message confirmation

  }, function(error) {
    res.errorT(error)
console.log('%s', "job cancelled failed") //message failure

  })
})


Parse.Cloud.define("job_approved", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")
  if (!webhook) {
    return res.successT()
  }
  Parse.Cloud.httpRequest ({
    url: webhook,
    method: "post",
    data: {
      success: true,
      type: "job.approved",
      reason: "Carrier accepted job"
    }
  }),then(function(response){
    res.successT()
    console.log('%s', "job approved success") //message confirmation
  }, function(error) {
     res.errorT(error)
     console.log('%s', "job approved failed") //message failure
  })
})

Parse.Cloud.define("job_enroute", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")
  if (!webhook) {
    return res.successT()
  }
  Parse.Cloud.httpRequest ({
    url: webhook,
    method: "post",
    data: {
      success: true,
      type: "job.enroute",
      reason: "Carrier is in route"
    }
  }),then(function(response){
    res.successT()
    console.log('%s', "job enroute confirmed") //message confirmation
  }, function(error) {
     res.errorT(error)
     console.log('%s', "job enroute failed confirmation") //message failure
  })
})

Parse.Cloud.define("job_pending", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")
  if (!webhook) {
    return res.successT()
  }
  Parse.Cloud.httpRequest ({
    url: webhook,
    method: "post",
    data: {
      success: true,
      type: "job.pending",
      reason: "No Carrier has accepted this job yet."
    }
  }),then(function(response){
    res.successT()
    console.log('%s', "job pending confirmed") //message confirmation
  }, function(error) {
     res.errorT(error)
     console.log('%s', "job pending failed confirmation") //message failure
  })
})
