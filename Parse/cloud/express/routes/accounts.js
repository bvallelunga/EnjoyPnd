module.exports.home = function(req, res) {
  var user = req.user

  user.get("company").fetch().then(function(company) {
    res.renderT('home/account', {
      template: 'home/index',
      user: {
        name: user.get("name"),
        description: user.get("description"),
        email: user.get("email")
      },
      company: {
        name: company.get("name"),
        description: company.get("description"),
        webhook: company.get("webhook"),
        apiKey: company.get("apiKey"),
        apiSecret: company.get("apiSecret")
      }
    })
  })
}

module.exports.user = function(req, res) {
  var user = req.user

  user.set("name", req.param("name"))
  user.set("email", req.param("email"))
  user.set("description", req.param("description"))

  user.save().then(function() {
    res.redirect("/account")
  })
}

module.exports.company = function(req, res) {
  var user = req.user
  var company = user.get("company")

  company.set("name", req.param("name"))
  company.set("webhook", req.param("webhook"))
  company.set("description", req.param("description"))

  company.save().then(function() {
    res.redirect("/account")
  })
}
