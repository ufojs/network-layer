module.exports = (grunt) ->

  @initConfig

    pkg: grunt.file.readJSON('package.json'),

    bower:
      install:
        options:
          copy: false

    uglify:
      build:
        src: 'lib/client.bundle.js'
        dest: 'lib/client.bundle.min.js'

    browserify:
      dist:
        src: 'src/client.coffee'
        dest: 'lib/client.bundle.js'
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

    karma:
      integration:
        configFile: 'integration-test/karma.conf.js'

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
  @loadNpmTasks 'grunt-karma'
  @loadNpmTasks 'grunt-bower-task'

  @registerTask 'installDeps', 'bower:install'
  @registerTask 'compile', [
    'installDeps'
    'browserify'
    'uglify'
  ]
  @registerTask 'integration-test', [
    'compile'
    'karma'
  ]
  @registerTask 'unit-test', 'mochaTest'
  @registerTask 'default', 'compile'
  @registerTask 'develop', ['installDeps', 'watch:test']
