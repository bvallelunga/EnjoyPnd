var User = Parse.User

module.exports.auth = function(req, res, next) {
  if(req.session.user) {
		var user = new User()
    user.id = req.session.user

    user.fetch().then(function() {
      req.user = user
      next()
    })
	} else if(req.xhr) {
		res.errorT("Login required :(")
	} else {
		res.renderT("home/login")
	}
}

module.exports.login = function(req, res) {
  Parse.User.logIn(
    req.param("email"), req.param("password")
  ).then(function(user) {
    if(user.get("company") == null) {
      return res.errorT("Invalid Credentials :(")
    }

    req.session.user = user.id
    res.successT()
  }, function() {
    res.errorT("Invalid Credentials :(")
  })
}

module.exports.logout = function(req, res) {
  console.log(1)
  req.session = null
  res.redirect("/")
}

module.exports.notfound = function(req, res) {
  res.redirect("/")
}
