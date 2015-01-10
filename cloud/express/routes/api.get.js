var User = Parse.User

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
}

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
}

module.exports.workerInfo = function(req, res) {
  var id = req.param("id")
  var query = new Parse.Query(User)
  query.get(id).then(function(user) {
    if(user) {
      res.successT({
        //begin informing others about this user 
        var worker = { 
        username: user.get("username")
        company: user.get("company")
        email: user.get("email")
        name: user.get("name")
        status: user.get("status")
        }
        // end
      })
    } else {
      res.errorT("Invalid user id")
    }
  }, res.errorT)
}
