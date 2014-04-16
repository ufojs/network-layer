coffeeify = require 'coffeeify'

module.exports = (grunt) ->

  @initConfig

    pkg: grunt.file.readJSON('package.json'),

    uglify:
      build:
        src: 'lib/ufoPacket.bundle.js'
        dest: 'lib/ufoPacket.bundle.min.js'

    browserify2:
      development:
        entry: './src/ufoPacket.coffee'
        compile: './lib/ufoPacket.bundle.js'
        debug: yes
        beforeHook: (bundle)->
           bundle.transform coffeeify

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
        files: ['test/*.coffee']
        tasks: 'mochaTest'
      compile:
        files: ['src/*.coffee']
        tasks: 'browserify2'

    clean: ['lib/', 'node_modules/']

  @loadNpmTasks 'grunt-browserify2'
  @loadNpmTasks 'grunt-contrib-uglify'
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-mocha-test'

  @registerTask 'compile', [
    'browserify2'
    'uglify'
  ]

  @registerTask 'test', 'mochaTest'

  @registerTask 'default', [
    'compile'
    'mochaTest'
  ]