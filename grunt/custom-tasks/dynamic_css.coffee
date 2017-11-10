module.exports = (grunt) ->
 
 	# NOTE: this may not need its own custom task, but for the sake of proper sourcemaps, this is the easisest way for now
	grunt.registerTask 'dynamic_css', 'dynamic prefixing and minification of all css files', ->

		# read all files with .css file extension
		grunt.file.expand('src/**/*.css').forEach (file) ->
			
			distFile = 'dist' + file.slice(3) # Destination file
			pwd = process.env.PWD # Project path

			# Get the current config from needed plugins	
			postcss = grunt.config.get 'postcss'
			regex   = grunt.config.get 'regex-replace'
			
			# Prefix and minify all matching css files
			postcss[file] =
				options:
					map:
						inline: false
						# prev: tempDir + '/' + tempFile + '.map'
				src: file
				dest: distFile
				
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
			grunt.config.set 'postcss', postcss
			grunt.config.set 'regex-replace', regex
			
			# Run tasks
			grunt.task.run [
				'newer:postcss:' + file
				'newer:regex-replace:' + file
			]