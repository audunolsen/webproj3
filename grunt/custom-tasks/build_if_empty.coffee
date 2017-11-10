module.exports = (grunt) ->
	
	grunt.registerTask 'build_if_empty', 'Build the dist directory if it doesn\'t already exist', ->
		
		notifier = require 'node-notifier'
		
		distExists = (err, stdout, stderr, cb) ->
			# Carry on if shell command fails
			if err then cb()
		
			# Contine only if shell doesn't find dist
			if stdout.trim() is 'false'
				
				# Notification alerting build process before watch starts
				notifier.notify
					'title'   : 'Building…'
					'message' : 'dist not found, building before watch starts…'
					'icon'    : './grunt/icons/grunt-success.png'
				
				# Rebuild
				grunt.task.run 'default'
					
			else
				
				notifier.notify
					'title'   : 'Updating before watch starts…'
					'message' : 'Running grunt newer on tasks looking for changes…'
					'icon'    : './grunt/icons/grunt-success.png'
				
				# Update
				grunt.task.run 'update_if_newer'
				### Creating a custom task for a single notification may seem redundant
				but it's the easiest way to ensure the notification appears after the 
				previous task completes, alternative solution is hooking onto the task runner ###
			
			grunt.task.run 'watch_ready'
			
			cb()
		
		# Configure shell task to look for dist/ and echo true or false
		shell = grunt.config.get 'shell'
		shell['distExists'] =
			command: '[ -d dist/ ] && echo "true" || echo "false"'
			options: callback: distExists
		grunt.config.set 'shell', shell
		grunt.task.run 'shell:distExists'