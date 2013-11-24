(function() {
  var casper;

  casper = require('casper').create();

  casper.log('this is a debug message', 'debug');

  casper.log('and an informative one', 'info');

  casper.log('and a warning', 'warning');

  casper.log('and an error', 'error');

  casper.test.begin("Manisch Wörterbuch Tests", function(test) {
    var bar, baseUrl, foo, getFirstResult, listLength;
    baseUrl = 'http://localhost:8080/';
    listLength = function() {
      return jQuery('#list-view li').length;
    };
    casper.start(baseUrl, function() {
      var resultListLength;
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      test.comment("HTTP-Stuff checken");
      test.assertHttpStatus(200, 'Seite erreichbar');
      test.assertResourceExists(function(resource) {
        return resource.url.match("app.min.js");
      }, "app.min.js vorhanden");
      test.comment("DOM-Stuff checken");
      test.assertTitleMatch(/Manisch/, "Titel enthält 'Manisch'");
      test.assertExists("#primary", "#primary vorhanden");
      test.assertExists("#secondary", "#secondary vorhanden");
      test.assertExists("#list-view", "#list-view vorhanden");
      test.assertExists("#searchfffff", "#search vorhanden");
      resultListLength = this.evaluate(listLength);
      test.assertFalsy(resultListLength, "#list-view ist leer");
      return this.click('#alle-btn');
    });
    casper.then(function() {
      var newResultListLength, newerResultListLength, resultListLength;
      this.echo("#alle-btn wurde geklickt");
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      test.assertUrlMatch(/alle/, 'neue URL enthält /alle/');
      resultListLength = this.evaluate(listLength);
      test.assertTruthy(resultListLength > 1, "#list-view enthält mehr als ein Ergebnis");
      this.fill('#searchform', {
        'search': 'moss'
      }, false);
      this.echo('"moss" wurde in das Suchfeld eingetragen');
      test.assertField('search', 'moss', 'Suchfeld enthält "moss"');
      newResultListLength = this.evaluate(listLength);
      test.assert(newResultListLength < resultListLength, 'Ergebnisliste ist nach Suche kleiner geworden');
      this.fill('#searchform', {
        'search': 'moss'
      }, true);
      this.echo("#searchform wurde submitted");
      newerResultListLength = this.evaluate(listLength);
      test.assert(newerResultListLength === newResultListLength, 'Ergebnisliste gleich geblieben');
      return this.click('#random-btn');
    });
    casper.then(function() {
      this.echo("#random-btn wurde geklickt");
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      test.assertUrlMatch(/item/, 'url enthält /item/');
      test.assertExists('#item-detail-view');
      test.assertVisible('#item-detail-view');
      this.click('#item-detail-view');
      return test.assertNotVisible('#item-detail-view');
    });
    getFirstResult = function() {
      return jQuery('#list-view li').first().find('.manisch').html();
    };
    foo = '';
    bar = '';
    casper.then(function() {
      this.echo("[BEGIN] event-listenerBug", 'WARNING');
      return this.click('#stadtbekannt-btn');
    });
    casper.then(function() {
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      bar = this.evaluate(getFirstResult);
      this.echo(bar);
      test.assertNotEquals(foo, bar);
      this.fill('#searchform', {
        'search': 'mo'
      }, false);
      return this.click('#nomen-btn');
    });
    casper.then(function() {
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      foo = this.evaluate(getFirstResult);
      this.echo(foo);
      test.assertNotEquals(foo, bar);
      return this.click('#stadtbekannt-btn');
    });
    casper.then(function() {
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      bar = this.evaluate(getFirstResult);
      this.echo(bar);
      test.assertNotEquals(foo, bar);
      this.fill('#searchform', {
        'search': 'mo'
      }, false);
      return this.click('#nomen-btn');
    });
    casper.then(function() {
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      foo = this.evaluate(getFirstResult);
      this.echo(foo);
      test.assertNotEquals(foo, bar);
      return this.click('#stadtbekannt-btn');
    });
    casper.then(function() {
      this.echo("URL: " + casper.getCurrentUrl(), 'INFO');
      bar = this.evaluate(getFirstResult);
      this.echo(bar);
      return test.assertNotEquals(foo, bar);
    });
    casper.then(function() {
      return this.echo("[END] event-listenerBug", 'WARNING');
    });
    return casper.then(function() {
      return test.done();
    });
  });

  casper.run();

}).call(this);
