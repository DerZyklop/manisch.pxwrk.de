# ____________________________________________________________________________ #
# ###########################################################################| #
# ##################################ZZZZZZZZZ################################| #
# #################################/        /\###############################| #
# ################################/        /  \##############################| #
# ###############################/        /    \#############################| #
# ##############################/        /      \############################| #
# #############################/        /        \###########################| #
# ############################/        /          \##########################| #
# ###########################/        /            \#########################| #
# ##########################/        /      /\      \########################| #
# #########################/        /      /  \      \#######################| #
# ########################/        /      /    \      \######################| #
# #######################/        /      /\     \      \#####################| #
# ######################/        /      /##\     \      \####################| #
# #####################/        /      /####\     \      \###################| #
# ####################/        /______/ZZZZZZ\     \      \##################| #
# ###################/                        \     \      \#################| #
# ##################/                          \     \      \################| #
# #################(____________________________\     \      )###############| #
# ##################\                                  \    /################| #
# ###################\                                  \  /#################| #
# ####################\__________________________________\/##################| #
# ###########################################################################| #
# ########################### +-------------------+ #########################| #
# ########################### |  code written by  | #########################| #
# ########################### |  ---------------  | #########################| #
# ########################### |   Nils  Neumann   | #########################| #
# ########################### | www.der-zyklop.de | #########################| #
# ########################### +-------------------+ #########################| #
# ###########################################################################| #
# ____________________________________________________________________________ #


module.exports = (grunt) ->

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig

    # load content from the package.json
    pkg: grunt.file.readJSON('package.json')

    # Set up some vars
    paths:
      base: 'public/'
      assets: '<%= paths.base %>assets/'
      coffee: '<%= paths.assets %>coffee/'
      js: '<%= paths.assets %>js/'
      sass: '<%= paths.assets %>sass/'
      css: '<%= paths.assets %>styles/'
      sassfilename: 'styles'
      jsfilename: 'app'

    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */'


    # process coffee-files
    coffee:
      all:
        options:
          join: false
          bare: true
        files:
          '<%= paths.coffee %>pre_js/<%= paths.jsfilename %>.js': [
            '<%= paths.coffee %>pxwrkLib.coffee'
            '<%= paths.coffee %>pxwrkViewLib.coffee'
            '<%= paths.coffee %>item.coffee'
            '<%= paths.coffee %>list.coffee'
            '<%= paths.coffee %>itemDetailView.coffee'
            '<%= paths.coffee %>itemView.coffee'
            '<%= paths.coffee %>listView.coffee'
            '<%= paths.coffee %>appView.coffee'
            '<%= paths.coffee %>router.coffee'
            '<%= paths.coffee %>manischApp.coffee'
          ]
        # files: [
        #   expand: true
        #   cwd: '<%= paths.coffee %>'
        #   src: ['*.coffee']
        #   dest: '<%= paths.coffee %>pre_js'
        #   ext: '.js'
        # ]

    # minify js-files
    uglify:
      options:
        banner: '<%= banner %>'
      js:
        files:
          '<%= paths.js %><%= paths.jsfilename %>.min.js': [
            '<%= paths.coffee %>pre_js/jquery*.js'
            '<%= paths.coffee %>pre_js/underscore.js'
            '<%= paths.coffee %>pre_js/backbone.js'
            '<%= paths.coffee %>pre_js/<%= paths.jsfilename %>.js'
          ]
        options:
          mangle: false


    # process sass-files
    sass:
      all:
        options:
          compass: true
          style: 'compressed'
        files: '<%= paths.sass %>pre_css/<%= paths.sassfilename %>.css': '<%= paths.sass %><%= paths.sassfilename %>.sass'

    # minify css-files
    cssmin:
      options:
        banner: '<%= banner %>'
      all:
        files:
          '<%= paths.css %><%= paths.sassfilename %>.css': [
            '<%= paths.sass %>pre_css/*.css'
          ]

    uncss:
      dist:
        files:
          'assets/styles/foo.css': ['index.php']

    watch:
      options:
        livereload: true
      livereload:
        files: [
          '<%= paths.css %>**/*.css'
          '<%= paths.js %>**/*.js'
        ]
        tasks: ['reload']
      sass:
        files: ['<%= paths.sass %>**/*.sass']
        tasks: ['sass']
      css:
        files: ['<%= paths.sass %>pre_css/*.css']
        tasks: ['cssmin']
      coffee:
        files: ['<%= paths.coffee %>*.coffee']
        tasks: ['coffee']
      js:
        files: [
          '<%= paths.coffee %>pre_js/*.js'
        ]
        tasks: ['uglify']
      tmpl:
        files: [
          'site/templates/*'
          'site/snippets/*'
          'site/plugins/*'
        ]
        tasks: ['reload']

    php:
      all:
        options:
          port: 1337
          hostname: 'localhost'
          base: '<%= paths.base %>'
          keepalive: true

    open:
      all:
        path: 'http://<%= php.all.options.hostname %>:<%= php.all.options.port%>'


  grunt.registerTask "reload", "reload Chrome on OS X", ->
    require("child_process").exec("osascript " +
        "-e 'tell application \"Google Chrome\" " +
          "to tell the active tab of its first window' " +
        "-e 'reload' " +
        "-e 'end tell'")


  grunt.registerTask('uncss', ['uncss'])
  grunt.registerTask('server', ['open','php'])
  grunt.registerTask('default', ['reload','watch'])
