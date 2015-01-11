var Jobs = Parse.Object.extend("Jobs")

module.exports.pending = function(req, res) {
  var company = req.company
  var workers = company.relation("workers")
  var pendingWorkers = company.relation("pendingWorkers")
  var query = new Parse.Query(Parse.User)

  query.get(req.param("user"), function(user) {
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
  var company = new Company()
  company.id = req.param("company")

  var pickup = req.param('pickup')
  var destination = req.param('destination')

  job.set("company", company)
  job.set("destination", destination.address)
  job.set("name", req.param("name"))
  job.set("pickup", pickup.address)
  job.set("pickupGeo", new Parse.GeoPoint(pickup.lat, pickup.lng))

  if(!destination || !name || !pickup || !pickupGeo) {
    res.errorT("Missing parameter(s)")
  }

  job.save().then(function() {
    res.successT()
  }, res.errorT)
}

var Job = Parse.Object.extend("Jobs")

module.exports.cancel = function(req, res) {
  var company = req.company

  var query = new Parse.Query(Job)
  query.get(req.param("job"), function(job) {
      job.set("status", 5)
  })

  job.save().then(function() {
    res.successT()
  }, res.errorT)
}
