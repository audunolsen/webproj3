module.exports = (grunt) ->
 
	grunt.registerTask 'dynamic_sass_dir', 'Dynamic concatination and compilation of .sass files in directories named *SASS*', ->

		# read all subdirectories with SASS in the directory name
		grunt.file.expand('src/**/*SASS*').forEach (dir) ->
			
			file = 'dist' + dir.slice(3).replace(/\((.*)\)/g, '') + '.css' # Destination file
			tempDir = 'grunt/grunt-cache' + dir.slice(3) # Temp folder
			tempFile = file.substring(file.lastIndexOf("/") + 1) # Filename without path
			pwd = process.env.PWD # Project path

			# Get the current config from needed plugins			
			sass = grunt.config.get 'sass'
			prefixer = grunt.config.get 'postcss'
			regex = grunt.config.get 'regex-replace'
			
			# Set the config for matching directories
			
			# STEP 1 - Compile all .sass files and distribute to a temp directory
			sass[dir] =
				src: dir + '/main.{sass,scss}'
				dest: tempDir + '/' + tempFile
				
			# STEP 2 - Run postcss on previosly compiled file and distribute prefixed css file
			prefixer[dir] =
				options:
					map:
						inline: false
						prev: tempDir + '/' + tempFile + '.map'
				src: tempDir + '/' + tempFile
				dest: file
				
			# STEP 3 - Prepend full local path to all sources in the sourcemap
			regex[dir] = 
				src: file + '.map'
				actions: [
					{
						search: /((\.\.\/)+)/g
						replace: 'file://' + pwd + '/'
					}
				]
			
			# Save the new config for the plugins
			grunt.config.set 'sass', sass
			grunt.config.set 'postcss', prefixer
			grunt.config.set 'regex-replace', regex
			
			# Run tasks
			grunt.task.run [
				'newer:sass:' + dir
				'newer:postcss:' + dir
				'newer:regex-replace:' + dir
			]