module.exports.home = function(req, res) {
  res.render('home/index')
}

module.exports.notfound = function(req, res) {
  res.redirect("/")
}
