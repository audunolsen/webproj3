module.exports = (grunt) ->

	# Why does this need its own custom task? 
	# Because this environmet needs to use shared config between the coffee and uglify plugins for the sake of proper sourcemaps
	grunt.registerTask 'dynamic_coffee', 'Compiles and uglifies all .coffe files in src/ and distributes them in paralell paths to dist', ->

		# Read all .coffee files
		# Excludes all coffee files in *CONCAT* because those directories have their own tasks
		grunt.file.expand([ 'src/**/*.coffee', '!src/**/*CONCAT*/*.coffee' ]).forEach (file) ->
			
			destFile = 'dist' + file.substring(0, file.lastIndexOf('.')).slice(3) # Destination file
			tempFile = 'grunt/grunt-cache' + file.substring(0, file.lastIndexOf('.')).slice(3) # Temp file
			pwd = process.env.PWD # Project path

			# Get the current config from needed plugins
			coffee = grunt.config.get 'coffee'
			concat = grunt.config.get 'concat_with_sourcemaps'
			uglify = grunt.config.get 'uglify'
			regex = grunt.config.get 'regex-replace'
			
			# Set the config for matching directories
			
			# STEP 1 - Compile all coffe files and distribute them parallelly to dist with a TMP extension/
			coffee[file] =
				options:
					sourceMap: true
				src: file
				dest: tempFile + '.TMP.js'
			
			# STEP 2 - Uglify all js files (if any) and distribute them to a temp directory in dist/
			uglify[file] =
				options:
					preserveComments: false
					compress: true
					sourceMap: true
					sourceMapIn: tempFile + '.TMP.js.map'
				src: tempFile + '.TMP.js'
				dest: destFile + '.js'

			# STEP 4 - Bug fix! Final sourcemap has 'undefined' in its sources attribute showing the otherwise correct path.
			# Use regex task to remove this unwanted part of the string
			regex[file] = 
				src: destFile + '.js.map'
				actions: [
					{
						search: /((\.\.\/)+)/g
						replace: 'file://' + pwd + '/'
					}
				]
			
			# Save the new config for the plugins
			grunt.config.set 'coffee', coffee
			grunt.config.set 'uglify', uglify
			grunt.config.set 'regex-replace', regex
			
			# Run tasks
			grunt.task.run [
				'newer:coffee:' + file
				'newer:uglify:' + file
				'newer:regex-replace:' + file
			]