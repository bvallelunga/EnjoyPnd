var Company = Parse.Object.extend("Company")

module.exports.auth = function(req, res, next) {
  var key = req.param("key")
  var secret = req.param("secret")
  var query = new Parse.Query(Company)

  if (!key || !secret) {
    return res.json({
      success: false,
      status: 0,
      message: "Invalid api key & secret!"
    })
  }

  query.equalTo("apiKey", key)
  query.equalTo("apiSecret", secret)

  query.first().then(function(company) {
    if(!company) {
      return res.json({
        success: false,
        status: 0,
        message: "Invalid api key & secret!"
      })
    }

    req.company = company
    next()
  }, res.errorT)
}

module.exports.get = require("cloud/express/routes/api.get.js")
module.exports.post = require("cloud/express/routes/api.post.js")
