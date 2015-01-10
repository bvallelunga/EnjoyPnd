/*
var applicants = Parse.pendingWorkers

module.exports.interview = function(req, res) {
  var query = new Parse.Query(Company


*/

company = req.company
workers = company.relation("workers")
pendingWorkers = company.relation("pendingWorkers")
query = new Parse.Query(Parse.User)

query.get(req.param("user"), function(user) {
  pendingWorkers.remove(user)
  
  if(req.param("accepted") == "true") {
    workers.add(user)
  }
  
  company.save().then(function() {
    res.successT()
  }, res.errorT)
})
