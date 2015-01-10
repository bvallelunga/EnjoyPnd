module.exports.home = function(req, res) {
  res.renderT('home/index')
}

module.exports.notfound = function(req, res) {
  res.redirect("/")
}

module.exports.render = function(req, res, next) {
  res.renderT = function(template, data) {
    data = data || {}
    data.host = req.protocol + "://" + req.host
    data.url = data.host + req.url
    data.template = template
    data.random = Math.random().toString(36).slice(2)
    res.render(template, data)
  }

  next()
}
