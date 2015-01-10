var express = require('express')
var app = express()

// Set Master Key
Parse.Cloud.useMasterKey()

// Routes
var routes = {
  core: require("cloud/express/routes/index.js"),
  api: {
    get: require("cloud/express/routes/api.get.js")
  }
}

// Global app configuration section
app.set('views', 'cloud/express/views')
app.set('view engine', 'ejs')
app.enable('trust proxy')

// Configure express routes
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(express.cookieSession({
  secret: 'ursid',
  cookie: {
      httpOnly: true
  }
}))
app.use(function(req, res, next) {
  res.successT = function(data) {
    data = data || {}
    data.success = true
    res.json(data)
  }

  res.errorT = function(error) {
    error.description = error.description || error

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
})

// Landing
app.get('/', routes.core.home)

// API
app.get('/api/workers', routes.api.get.auth, routes.api.get.workers)
app.get('/api/workers/pending', routes.api.get.auth, routes.api.get.workers)

// Not Found Redirect
app.all("*", routes.core.notfound)

// Listen to Parse
app.listen()
