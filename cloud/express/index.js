var express = require('express')
var app = express()

// Set Master Key
Parse.Cloud.useMasterKey()

// Routes
var routes = {
  core: require("cloud/express/routes/index"),
  api: require("cloud/express/routes/api")
}

// Global app configuration section
app.set('views', 'cloud/express/views')
app.set('view engine', 'ejs')
app.enable('trust proxy')
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(express.cookieSession({
  secret: 'ursid',
  cookie: {
      httpOnly: true
  }
}))
app.use(routes.core.extend)

// Landing
app.get('/', routes.core.home)

// API
app.get('/', routes.api.auth, routes.api.workers)

// Not Found Redirect
app.all("*", routes.core.notfound)

// Listen to Parse
app.listen()
