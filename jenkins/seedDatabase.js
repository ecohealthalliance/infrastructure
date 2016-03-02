var system = require('system');
console.log(system.args[1]);
var url = encodeURI(system.args[1]);
console.log(url);

var page = require('webpage').create();

page.open(url, function(status) {
  console.log("Status: " + status);
  phantom.exit();
});
