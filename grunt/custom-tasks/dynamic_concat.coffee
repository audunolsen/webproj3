module.exports = (grunt) ->

	grunt.registerTask 'dynamic_concat', 'iterates over all directories named *CONCAT* and compiles contained js and coffee files', ->

		# read all subdirectories from src folder and match specified directories
		grunt.file.expand('src/**/*CONCAT*').forEach (dir) ->
			
			file = 'dist' + dir.slice(3).replace(/\((.*)\)/g, '') + '.js' # Destination file
			tempDir = 'grunt/grunt-cache' + dir.slice(3) # Temp dir
			tempFile = file.substring(file.lastIndexOf('/') + 1) # Filename without path 
			pwd = process.env.PWD # Project path

			# Get the current config from needed plugins
			
			coffee = grunt.config.get 'coffee'
			concat = grunt.config.get 'concat_with_sourcemaps'
			uglify = grunt.config.get 'uglify'
			regex = grunt.config.get 'regex-replace'
			
			# Set the config for matching directories
			
			# STEP 1 - Compile all coffe files (if any) and distribute them to a temp directory in dist/
			coffee[dir] =
				options:
					bare: true
					sourceMap: true
				expand: true
				flatten: true
				src: dir + '/**/*.coffee'
				dest: tempDir
				ext: '.TMP.js'
				
			# STEP 2 - Uglify all js files (if any) and distribute them to a temp directory in dist/
			# It may seem redundant to uglify each js file before and after Concatination (it is), 
			# but the concat task needs a complete set of sourcemaps to work.
			uglify[dir] =
				options:
					preserveComments: false
					compress: false
					sourceMap: true
				expand: true
				flatten: true
				src: dir + '/*.js'
				dest: tempDir
				ext: '.TMP.js'
				
			# STEP 3 - Concat all js files and its sourcemaps in the temp directory, while ignoring earlier output file of this task
			concat[dir] =
				options:
					sourceRoot: 'file://' + pwd + '/'
				src: [ 
					tempDir + '/*.js'
					'!' + tempDir + '/' + tempFile
				]
				dest: tempDir + '/' + tempFile
				
			# STEP 4 - Uglify (again) the newly concated js file in the temp directory
			uglify[tempDir] =
				options:
					compress: true
					sourceMap: true
					sourceMapIn: tempDir + '/' + tempFile + '.map'
					sourceMapName: file + '.map'
				src: tempDir + '/' + tempFile
				dest: file
				
			# STEP 4 - Bug fix! Final sourcemap has 'undefined' in its sources attribute showing the otherwise correct path.
			# Use regex task to remove this unwanted part of the string
			regex[dir] = 
				src: file + '.map'
				actions: [
					{
						search: 'undefined'
						replace: ''
						flags: 'g'
					}
				]
			
			# Save the new config for the plugins
				
			grunt.config.set 'coffee', coffee
			grunt.config.set 'concat_with_sourcemaps', concat
			grunt.config.set 'uglify', uglify
			grunt.config.set 'regex-replace', regex

			
			# Run desired tasks
			
			grunt.task.run [
				'newer:coffee:' + dir
				'newer:uglify:' + dir
				'newer:concat_with_sourcemaps:' + dir
				'newer:uglify:' + tempDir
				'newer:regex-replace:' + dir
			]				