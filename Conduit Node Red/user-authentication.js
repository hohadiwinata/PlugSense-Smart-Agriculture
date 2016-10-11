var when = require("when");
var https = require("https");
module.exports = {
    type: "credentials",
    users: function(username) {
        return when.promise(function(resolve) {
            // Do whatever work is needed to check username is a valid
            // user.
            // Resolve with the user object. It must contain
            // properties 'username' and 'permissions'
            var user = { username: "admin", permissions: "*" };
            resolve(user);
        });
    },
    authenticate: function(username, password) {
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0" // Avoids DEPTH_ZERO_SELF_SIGNED_CERT error for self-signed certs
        return when.promise(function(resolve) {
            // Do whatever work is needed to validate the username/password
            // combination.
          console.log("Attempting to log in as: " + username);
          https.get("https://127.0.0.1/api/login?username=" + encodeURIComponent(username) + "&password=" + encodeURIComponent(password), function(res) {
            if (res.statusCode == 200) {
              console.log("Status code: " + res.statusCode);
              res.on('data', function(d) {
                var jsonResponse = JSON.parse(d);
                if (jsonResponse.status === "success" && jsonResponse.result.permission === "admin") {
                  console.log("Attempting to log out using token: " + jsonResponse.result.token);
                  https.get("https://127.0.0.1/api/logout?token=" + jsonResponse.result.token);
                  var user = { username: "admin", permissions: "*" };
                  resolve(user);
                  return;
                } else {
                  console.log("Status or permission incorrect.")
                  console.log("Status: " + jsonResponse.result.status);
                  console.log("Permission: " + jsonResponse.result.permission);
                  res.on('data', function(d) {
                    console.log("Error logging in, bad status or permission: " + d);
                  });
                  resolve(null);
                  return;
                }
              });
            } else {
              res.on('data', function(d) {
                console.log("Error logging in, bad status code: " + d);
              });
              resolve(null);
              return;
            }
          }).on('error', function(e) {
              resolve(null);
              console.log("Error trying to log in: " + e.message);
          });
        });
    },
    default: function() {
        return when.promise(function(resolve) {
            // Resolve with the user object for the default user.
            // If no default user exists, resolve with null.
            resolve(null);
        });
    }
}
