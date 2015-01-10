module.exports.home = function(req, res) {
  res.renderT('home/index')
}

module.exports.notfound = function(req, res) {
  res.redirect("/")
}
