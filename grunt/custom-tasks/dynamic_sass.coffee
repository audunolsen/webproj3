module.exports = (grunt) ->
 
 	# NOTE: this may not need its own custom task, but for the sake of proper sourcemaps, this is the easisest way for now
	grunt.registerTask 'dynamic_sass', 'sass compilation follwed by dynamic prefixing and minification of all sass files', ->

		# read all files with .css file extension
		grunt.file.expand('src/**/*.{sass,scss}', '!src/**/*SASS*/*.{sass,coffee}').forEach (file) ->
			
			distFile = 'dist' + file.substring(0, file.lastIndexOf('.')).slice(3) # Destination file
			tempFile = 'grunt/grunt-cache' + file.substring(0, file.lastIndexOf('.')).slice(3) # Temp file
			pwd = process.env.PWD # Project path

			# Get the current config from needed plugins
			sass = grunt.config.get 'sass'	
			postcss = grunt.config.get 'postcss'
			regex   = grunt.config.get 'regex-replace'
			
			# Compile all .sass files and distribute accordingly to a temp directory
			sass[file] =
				src: file
				dest: tempFile + '.TMP.css'
			
			# Prefix and minify all matching css files
			postcss[file] =
				options:
					map:
						inline: false
				src: tempFile + '.TMP.css'
				dest: distFile + '.css'
				
			# Prepend full local path to all sources in the sourcemap
			regex[file] = 
				src: distFile + '.map'
				actions: [
					{
						search: /((\.\.\/)+)/g
						replace: 'file://' + pwd + '/'
					}
				]
			
			# Save the new config for the plugins
			grunt.config.set 'sass', sass
			grunt.config.set 'postcss', postcss
			grunt.config.set 'regex-replace', regex
			
			# Run tasks
			grunt.task.run [
				'newer:sass:' + file
				'newer:postcss:' + file
				'newer:regex-replace:' + file
			]