// Generated by CoffeeScript 1.6.3
(function() {
  var address, page, system, t;

  page = require('webpage').create();

  system = require('system');

  t = '';

  address = '';

  if (system.args.length === 1) {
    console.log('Usage: loadspeed.js <some URL>');
    phantom.exit();
  }

  t = Date.now();

  address = system.args[1];

  page.open(address, function(status) {
    if (status !== 'success') {
      console.log('FAIL to load the address');
    } else {
      t = Date.now() - t;
      console.log('Loading time ' + t + ' msec');
    }
    return phantom.exit();
  });

}).call(this);
