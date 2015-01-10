module.exports.home = function(req, res) {
  res.renderT('home/index')
}

module.exports.notfound = function(req, res) {
  res.redirect("/")
}

module.exports.extend = function(req, res, next) {
  res.successT = function(data) {
    data = data || {}
    data.success = true
    res.json(data)
  }

  res.errorT = function(error) {
    res.json({
      success: false,
      status: 1,
      message: error.description
    })
  }

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
