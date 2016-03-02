var system = require('system');
var url = encodeURI(system.args[1]);

var page = require('webpage').create();
page.onError = function (msg, trace) {
    console.log(msg);
    trace.forEach(function(item) {
        console.log('  ', item.file, ':', item.line);
    });
};

page.open(url, function(status) {
  console.log("Status: " + status);
  phantom.exit();
});
