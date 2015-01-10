var Jobs = Parse.Object.extend("Jobs")

module.exports.home = function(req, res) {
  var pendingJobs = []
  var activeJobs = []
  var completedJobs = []
  var company = req.user.get("company")

  Parse.Promise.as().then(function() {
    var query = new Parse.Query(Jobs)

    query.equalTo("company", company)
    query.equalTo("status", 1)

    return query.each(function(job) {
      var data = {
        id: job.id,
        name: job.get("name")
      }

      if(job.get("pickupGeo")) {
        var geo = job.get("pickupGeo")
        data.lat = geo.latitude
        data.lng = geo.longitude
      }

      pendingJobs.push(data)
    })
  }).then(function() {
    var query = new Parse.Query(Jobs)

    query.equalTo("company", company)
    query.equalTo("status", 2)

    return query.each(function(job) {
      var data = {
        id: job.id,
        name: job.get("name")
      }

      if(job.get("pickupGeo")) {
        var geo = job.get("pickupGeo")
        data.lat = geo.latitude
        data.lng = geo.longitude
      }

      activeJobs.push(data)
    })
  }).then(function() {
    var query = new Parse.Query(Jobs)

    query.equalTo("company", company)
    query.greaterThan("status", 2)

    return query.each(function(job) {
      var data = {
        id: job.id,
        name: job.get("name"),
        status: job.get("status")
      }

      if(job.get("pickupGeo")) {
        var geo = job.get("pickupGeo")
        data.lat = geo.latitude
        data.lng = geo.longitude
      }

      completedJobs.push(data)
    })
  }).then(function() {
    res.renderT('home/jobs', {
      template: 'home/index',
      pendingJobs: pendingJobs,
      activeJobs: activeJobs,
      completedJobs: completedJobs
    })
  })
}

module.exports.cancel = function(req, res) {
  var job = new Jobs()

  job.id = req.param("job")
  job.set("status", 5)
  job.save().then(function() {
    res.redirect("/jobs")
  })
}
