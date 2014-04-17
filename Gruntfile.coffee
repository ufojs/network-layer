coffeeify = require 'coffeeify'

module.exports = (grunt) ->

  @initConfig

    pkg: grunt.file.readJSON('package.json'),

    uglify:
      build:
        src: 'lib/peer.bundle.js'
        dest: 'lib/peer.bundle.min.js'

    browserify:
      dist:
        src: 'src/peer.coffee'
        dest: 'lib/peer.bundle.js'
      options:
        transform: ['coffeeify']
        browserifyOptions:
          extensions: ['.coffee']
        bundleOptions:
          standalone: 'ufo'

    coffee:
      config:
        options:
          bare: true
          files: [
            expand: true
            src: ['src/*.coffee']
            dest: 'lib'
            ext: '.js'
            ]

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
        src: ['test/*.coffee']

    watch:
      test:
        files: ['test/*.coffee', 'src/*.coffee']
        tasks: 'mochaTest'
      compile:
        files: ['src/*.coffee']
        tasks: 'browserify'

    clean: ['lib/', 'node_modules/']

  @loadNpmTasks 'grunt-browserify'
  @loadNpmTasks 'grunt-contrib-uglify'
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-mocha-test'

  @registerTask 'compile', [
    'browserify'
    'uglify'
  ]

  @registerTask 'test', 'mochaTest'

  @registerTask 'default', [
    'compile'
    'mochaTest'
  ]