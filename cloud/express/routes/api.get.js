var Company = Parse.Object.extend("Company")
var workerlist = Parse.Object.extend("workers")

module.exports.auth = function(req, res, next) {
  var key = req.param("key")
  var secret = req.param("secret")
  var query = new Parse.Query(Company)

  if (!key || !secret) {
    return res.json({
      success: false,
      status: 0,
      message: "Invalid api key & secret!"
    })
  }

  query.equalTo("apiKey", key)
  query.equalTo("apiSecret", secret)

  query.first().then(function(company) {
    if(!company) {
      return res.json({
        success: false,
        status: 0,
        message: "Invalid api key & secret!"
      })
    }

    req.company = company
    next()
  }, res.errorT)
}

module.exports.workers = function(req, res) {
  var company = req.company
  var query = company.relation("workers").query()
  var workers = []

  query.each(function(worker) {
    workers.push({
      name: worker.get("name"),
      description: worker.get("description")
    })
  }).then(function() {
    res.successT({
      workers: workers
    })
  }, res.errorT)

module.exports.pendingWorkers = function(req, res) {
  var company = req.company
  var query = company.relation("pendingWorkers").query()
  var workers = []

  query.each(function(worker) {
    workers.push({
      name: worker.get("name"),
      description: worker.get("description")
    })
  }).then(function() {
    res.successT({
      workers: workers
    })
  }, res.errorT)
}}

module.exports.workerinfo = function(req, res) {
  var name = req.param("name")
  Parse.Query("workers")
  var single_worker = workerlist.find(name)
  if (name) {
    //Don't know what you want to do with this discovery
  }
}
