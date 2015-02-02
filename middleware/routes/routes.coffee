# Import NPM Module
fs = require "fs"

# Cache Routes
routes = null

module.exports = (cb)->
	unless routes
	  routes = {}

	  async.each fs.readdirSync(__dirname), (directory, next)->
	  	path = "#{__dirname}/#{directory}"

	  	if fs.statSync(path).isDirectory()
	  		if fs.existsSync "#{path}/index.coffee"
	  			routes[directory] = require path
	  		else
	  			routes[directory] = {}

	  		async.each fs.readdirSync(path), (file, next)->
	  			if file != "index.coffee" and fs.existsSync "#{path}/#{file}"
	  				routes[directory][file.slice(0, -7)] = require path + "/" + file

	  			next()
	  		, next
	  	else
	  		next()
	  , -> cb routes
	else
		cb routes
