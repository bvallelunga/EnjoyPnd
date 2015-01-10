
var company = req.company
var workers = company.relation("workers")
var pendingWorkers = company.relation("pendingWorkers")

var query = new Parse.Query(Parse.User)
//user? loop? look at all users? does it cycle through? for later implementation
query.get(req.param("user"), function(user) {
  pendingWorkers.remove(user)
  
  if(req.param("accepted") == "true") {
    workers.add(user)
  }  
  company.save().then(function() {
    res.successT()
  }, res.errorT)
})


