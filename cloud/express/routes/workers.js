var User = Parse.User

module.exports.invited = function(req, res, next) {
  var user = new User()
  var company = req.user.get("company")

  user.id = req.param("user")

  company.fetch().then(function() {
    var pendingWorkers = company.relation("pendingWorkers")
    pendingWorkers.add(user)
    return company.save()
  }).then(function() {
    res.redirect("/")
  })
}

module.exports.accepted = function(req, res, next) {
  var user = new User()
  var company = req.user.get("company")

  user.id = req.param("user")

  company.fetch().then(function() {
    var workers = company.relation("workers")
    var pendingWorkers = company.relation("pendingWorkers")

    workers.add(user)
    pendingWorkers.remove(user)

    return company.save()
  }).then(function() {
    res.redirect("/")
  })
}

module.exports.declined = function(req, res, next) {
  var user = new User()
  var company = req.user.get("company")

  user.id = req.param("user")

  company.fetch().then(function() {
    var pendingWorkers = company.relation("pendingWorkers")
    pendingWorkers.remove(user)
    return company.save()
  }).then(function() {
    res.redirect("/")
  })
}

module.exports.dropped = function(req, res, next) {
  var user = new User()
  var company = req.user.get("company")

  user.id = req.param("user")

  company.fetch().then(function() {
    var workers = company.relation("workers")
    workers.remove(user)
    return company.save()
  }).then(function() {
    res.redirect("/")
  })
}
