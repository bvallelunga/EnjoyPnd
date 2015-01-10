var auth = function(req, res, next) {
  var key = Parse.Object.extend("apiKey");
//res.json({ success: false, status: 0, message: "unauthorized"})
  //Parse.Object.extend("apikey") //??
  var secret = Parse.Object.extend("apiSecret")
  if (!key || !secret) { //if either are false
    return res.json({ success: false, status: 0, message: "unauthorized"})
  }
}

var valid_company = Parse.Query("Company")
valid_company.equalTo("apiKey", key) // set key in DB to equal to local key
valid_company.equalTo("apiSecret", secret) // set secret in DB to equal to local secret
valid_company.first().then(function(company) {
  req.company = company
  next()
})

workers = function(req, res, next)
req.company.get("workers")
