#nur ein test
module.exports = (grunt) ->

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      app:
        options:
          join: false
          bare: true
        files:
          'public/assets/js/app.js': [
              'public/assets/coffee/pxwrkLib.coffee'
              'public/assets/coffee/pxwrkViewLib.coffee'
              'public/assets/coffee/item.coffee'
              'public/assets/coffee/ItemView.coffee'
              'public/assets/coffee/itemDetailView.coffee'
              'public/assets/coffee/List.coffee'
              'public/assets/coffee/ListView.coffee'
              'public/assets/coffee/AppView.coffee'
              'public/assets/coffee/Router.coffee'
              'public/assets/coffee/manischApp.coffee'
            ]
      client:
        files:
          'client/js/manisch-api.js': ['client/coffee/manisch-api.coffee']
          'client/js/server.js': ['client/coffee/server.coffee']
      tests:
        files:
          'public/tests/casperjs/js/casper.js': ['public/tests/casperjs/coffee/casper.coffee']


    sass:
      all:
        options:
          compass: true
        files:
          'build/assets/styles/styles.css': 'public/assets/sass/styles.sass'


    uglify:
      options:
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */'
        beautify:
          width: 80
          beautify: false
      app:
        files:
          'build/assets/js/app.min.js': [
            'public/assets/js/libs/jquery.min.js'
            'public/assets/js/libs/underscore.js'
            'public/assets/js/libs/backbone.js'
            'public/assets/js/app.js'
          ]
        options:
          beautify:
            width: 80
            beautify: true
          mangle: false


    copy:
      main:
        files: [{
            expand: true
            src: ['public/root/translations/*']
            dest: 'build/translations/'
            filter: 'isFile'
            flatten: true
          }, {
            expand: true
            src: ['public/root/site/templates/*']
            dest: 'build/site/templates/'
            filter: 'isFile'
            flatten: true
          }, {
            expand: true
            src: ['public/root/*']
            dest: 'build/'
            filter: 'isFile'
            flatten: true
          }, {
            expand: true
            src: ['public/assets/img/*']
            dest: 'build/assets/img/'
            filter: 'isFile'
            flatten: true
          }, {
            expand: true
            src: ['public/assets/styles/styles.css']
            dest: 'build/assets/styles/'
            filter: 'isFile'
            flatten: true
          }]


    shell:
      mongo:
        command: 'mongod'



    casperjs:
      options: {}
      files: ['public/tests/casperjs/js/casper.js']

    watch:
      root:
        files: ['public/root/**/*']
        tasks: ['copy']
        options:
          spawn: false
      client:
        files: ['client/coffee/*']
        tasks: ['coffee:client']
        options:
          spawn: false
      scripts:
        files: ['public/assets/js/*.js','public/assets/coffee/*.coffee']
        tasks: ['coffee:app','uglify']
        options:
          spawn: false
      sass:
        files: ['public/assets/sass/*.sass']
        tasks: ['sass']
        options:
          spawn: false
      tests:
        files: ['public/tests/casperjs/coffee/*.coffee']
        tasks: ['coffee:tests']
        options:
          spawn: false
      test:
        #not worrking jet:
        #files: '<%= casperjs.files %>'

        files: ['public/tests/casperjs/coffee/*.coffee']
        tasks: ['casperjs']
        options:
          spawn: false
      build:
        files: ['build/**/*']
        tasks: ['reload']





    connect:
      all:
        options:
          port: 1337
          base: 'build'
          hostname: "0.0.0.0"
          keepalive: true



    open:
      all:
        path: 'http://localhost:<%= connect.all.options.port%>'





  grunt.registerTask 'startdb', 'drop the database', ->

    http = require('http')
    path = require('path')
    express = require('express')
    translations = require('./client/js/manisch-api')

    dbApi = express()

    dbApi.configure ->
      dbApi.set('port', process.env.PORT || 3033)
      dbApi.use(express.logger('dev'))
      dbApi.use(express.bodyParser())
      #dbApi.use('/static', express.static(__dirname + '/public'))

    dbApi.get('/translations', translations.findAll)

    dbApi.get('/translation/:id', translations.findById)

    dbApi.post('/translations', translations.addTranslation)

    dbApi.put('/translation/:id', translations.updateTranslation)

    dbApi["delete"]('/translation/:id', translations.deleteTranslation)

    http.createServer(dbApi).listen dbApi.get('port'), ->
      return console.log("Express server listening on port " + dbApi.get('port'))



  grunt.registerTask "reload", "reload Chrome on OS X", ->
    require("child_process").exec("osascript " +
        "-e 'tell application \"Google Chrome\" " +
          "to tell the active tab of its first window' " +
        "-e 'reload' " +
        "-e 'end tell'")


  # To start the app
  # run in terminal:
  # mongod
  # cd ~/Dropbox/web_mirror/pxwrk.dorado.uberspace.de/manisch.pxwrk.de/ && grunt server
  # cd ~/Dropbox/web_mirror/pxwrk.dorado.uberspace.de/manisch.pxwrk.de/ && grunt watcher

  #grunt.registerTask('server', ['shell:mongo','startdb','open','connect'])
  grunt.registerTask('server', ['open','connect'])
  grunt.registerTask('default', ['watch'])
  grunt.registerTask('test', ['casperjs'])











