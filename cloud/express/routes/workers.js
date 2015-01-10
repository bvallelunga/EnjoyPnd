var User = Parse.User

module.exports.home = function(req, res) {
  var workers = []
  var pendingWorkers = []
  var company = req.user.get("company")

  company.fetch().then(function() {
    var query = company.relation("workers").query()

    return query.each(function(worker) {
      var data = {
        id: worker.id,
        name: worker.get("name"),
        status: worker.get("status")
      }

      if(worker.get("lastGeo")) {
        var geo = worker.get("lastGeo")
        data.lat = geo.latitude
        data.lng = geo.longitude
      }

      workers.push(data)
    })
  }).then(function() {
    var query = company.relation("pendingWorkers").query()

    return query.each(function(worker) {
      var data = {
        id: worker.id,
        name: worker.get("name")
      }

      if(worker.get("lastGeo")) {
        var geo = worker.get("lastGeo")
        data.lat = geo.latitude
        data.lng = geo.longitude
      }

      pendingWorkers.push(data)
    })
  }).then(function() {
    res.renderT('home/workers', {
      template: 'home/index',
      workers: workers,
      pendingWorkers: pendingWorkers
    })
  })
}

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
