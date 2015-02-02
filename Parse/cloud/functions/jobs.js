var Jobs = Parse.Object.extend("Jobs")

Parse.Cloud.define("job_Cancelled", function(req, res) { //requires the list of companies
console.log('%s', "start cancellation") //message confirmation
  var company = req.params.company
  //var company = req.param("company")
  //company.id = get.param("company")
  var webhook = company.get("webhook")
//add job id
  if(!webhook) {
    console.log('%s', "no webhook") //message confirmation
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
  }
  ).then(function(response) {
    res.success()
    console.log('%s', "job cancelled success") //message confirmation

  }, function(error) {
    res.error(error.description)
console.log('%s', "job cancelled failed") //message failure

  })
})


Parse.Cloud.define("job_approved", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")
  if (!webhook) {
    return res.success()
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
    res.success()
    console.log('%s', "job approved success") //message confirmation
  }, function(error) {
     res.error(error.description)
     console.log('%s', "job approved failed") //message failure
  })
})

Parse.Cloud.define("job_enroute", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")
  if (!webhook) {
    return res.success()
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
    res.success()
    console.log('%s', "job enroute confirmed") //message confirmation
  }, function(error) {
     res.error(error.description)
     console.log('%s', "job enroute failed confirmation") //message failure
  })
})

Parse.Cloud.define("job_pending", function(req, res) {
  var company = req.params.company
  var webhook = company.get("webhook")
  if (!webhook) {
    return res.success()
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
    res.success()
    console.log('%s', "job pending confirmed") //message confirmation
  }, function(error) {
     res.error(error.description)
     console.log('%s', "job pending failed confirmation") //message failure
  })
})

Parse.Cloud.define("carrier_search", function(req, res) {
  var job = new Jobs()

  job.id = req.params.job
  job.fetch().then(function(job) {
    var query = new Parse.Query(Parse.Installation)
    var userQuery = new Parse.Query(Parse.User);

    userQuery.equalTo("status", 2)
    userQuery.near("lastGeo", job.get("pickupGeo"))
    userQuery.limit(1)
    userQuery.ascending("lastGeo")
    query.matchesQuery("user", userQuery)

    return Parse.Push.send({
      where: query,
      data: {
        action: "job.invite",
        job: job.id
      }
    }).then(function() {
      job.set("status", 1)
      return job.save()
    }).then(function() {
      res.success("It worked")
    })
  })
})


Parse.Cloud.job("carrier_search", function(req, res) {
  Parse.Cloud.run('carrier_search', req.params)
})

Parse.Cloud.job("new_job", function(req, res) {
  Parse.Cloud.httpRequest({
    url:'http://www.enjoypnd.com/api/job',
    method: "POST",
    params: {
      key: "asdfasd324zvvtert",
      secret: "asdfhkj3523kjhlkasdf",
      name: "Dry cleaning pickup",
      pickup: JSON.stringify({
        address: "641 Merrill Road, Santa Cruz CA 95064, United States",
        lat: 36.999704,
        lng: -122.052111
      }),
      destination: JSON.stringify({
        address: "429 Front Street, Santa Cruz, CA",
        lat: 36.971435,
        lng: -122.024496
      })
    }
  }).then(function(response) {
    console.log(response)
    res.success("It worked")
  })
})
