var system = require('system');
var url = encodeURI(system.args[1]);

var page = require('webpage').create();

page.open(url, function(status) {
  console.log("Status: " + status);
  phantom.exit();
});
