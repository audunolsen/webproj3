module.exports = (grunt) ->
	
	### Creating a custom task for a single notification may seem redundant
	but it's the easiest way to ensure the notification appears after the 
	previous task completes, alternative solution is hooking onto the task runner ###
	grunt.registerTask 'dist_built', 'Alert that dist/ was successfully built', ->
		
		notifier = require 'node-notifier'
		
		# Notification alerting of dist successfully built
		notifier.notify
			'title'   : 'Dist/ successfully built!'
			'message' : 'The distribution directory is finished'
			'icon'    : './grunt/icons/grunt-success.png'