// Generated by CoffeeScript 1.6.3
(function() {
  var jQuery, page;

  page = require('webpage').create();

  jQuery = require('jquery');

  describe("Maths", function() {
    return it("should add two numbers", function() {
      var result;
      result = utilityAdd(1, 2);
      return expect(result).toEqual(3);
    });
  });

  page.onConsoleMessage = function(msg) {
    return console.log(msg);
  };

  console.log('[phantomjs] Loading page...');

  page.open('http://localhost:3030/', function(status) {
    if (status !== 'success') {
      return console.log('could not retrieve!');
    } else {
      return page.includeJs('http://localhost:3030/testing/jasmine/jasmine/jasmine.js', function() {
        console.log('retrieved');
        page.evaluate(function() {
          var list;
          console.log('[phantomjs] Querying for titles...');
          list = Array.prototype.slice.call(document.querySelectorAll('h1'), 0);
          console.log('[phantomjs] ' + list.length + ' titles:');
          describe('click Schimpfwörter', function() {
            jQuery('#schimpfwort-btn').trigger('click');
            setTimeout(function() {
              return console.log(jQuery('#secondary .content').html());
            }, 1000);
            return jQuery('#schimpfwort-btn').trigger('click', function() {
              var _this = this;
              console.log('"§§"§"§"§§"§""§');
              return it('should be defined', function() {
                return expect(true).toEqual(false);
              });
            });
          });
          return list.forEach(function(el) {
            return console.log('  ' + el.innerHTML.replace(/<.*?>/g, ''));
          });
        });
        return phantom.exit();
      });
    }
  });

}).call(this);