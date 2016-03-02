var system = require('system');
var url = system.args[1];

var page = require('webpage').create();

page.open(url, function(status) {
  console.log("Status: " + status);
  phantom.exit();
});
