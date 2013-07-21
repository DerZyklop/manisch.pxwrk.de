// Generated by CoffeeScript 1.6.1
(function() {
  var app, express, http, path, translations;

  http = require('http');

  path = require('path');

  express = require('express');

  translations = require('./manisch-api');

  app = express();

  app.configure(function() {
    app.set('port', process.env.PORT || 3030);
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    return app.use(express["static"](path.join(__dirname, '..', '..', 'public')));
  });

  app.get('/translations', translations.findAll);

  app.get('/translation/:id', translations.findById);

  app.post('/translations', translations.addTranslation);

  app.put('/translation/:id', translations.updateTranslation);

  app["delete"]('/translation/:id', translations.deleteTranslation);

  http.createServer(app).listen(app.get('port'), function() {
    return console.log("Express server listening on port " + app.get('port'));
  });

}).call(this);