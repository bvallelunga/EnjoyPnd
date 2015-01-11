var Jobs = Parse.Object.extend("Jobs")
var Company = Parse.Object.extend("Company")
var User = Parse.Object.extend("User")

module.exports.pending = function(req, res) {
  var company = req.company
  var workers = company.relation("workers")
  var pendingWorkers = company.relation("pendingWorkers")
  var query = new Parse.Query(User)
  var user = req.param("user")

  query.get(user, function(user) {
    pendingWorkers.remove(user)
    if(req.param("accepted") == "true") {
      workers.add(user)
    }
    company.save().then(function() {
      res.successT()
    }, res.errorT)
  })
}

module.exports.jobs = function(req, res) {
  /*
  name: String
  pickup: {
    lat: Float
    lng: Float
    address: String
  }
  destination: {
    lat: Float
    lng: Float
    address: String
  }
  */

  var job = new Jobs()
  var pickup = req.param('pickup')
  var destination = req.param('destination')

  if(!destination || !pickup || req.param("name") == null) {
    return res.errorT("Missing parameter(s)")
  }

  if(typeof pickup == "string") {
    pickup = JSON.parse(pickup)
    destination = JSON.parse(destination)
  }

  job.set("company", req.company)
  job.set("destination", destination.address)
  job.set("name", req.param("name"))
  job.set("status", 1)
  job.set("pickup", pickup.address)
  job.set("pickupGeo", new Parse.GeoPoint(parseFloat(pickup.lat), parseFloat(pickup.lng)))

  job.save().then(function() {
    Parse.Cloud.run('carrier_search', {
      job: job.id
    })

    res.successT()
  }, res.errorT)
}


module.exports.cancel = function(req, res) {
  var job = req.param("job")
  var query = new Parse.Query(Jobs)

  query.get(job, function(job) {
       job.set("status", 5)
      return job.save()
  }).then(function() {
     res.successT()
  }, res.errorT)
}
