module.exports = (grunt) ->
	
	### Creating a custom task for a single notification may seem redundant
	but it's the easiest way to ensure the notification appears after the 
	previous task completes, alternative solution is hooking onto the task runner ###
	grunt.registerTask 'watch_ready', 'Alert that the watch task is ready', ->
		
		notifier = require 'node-notifier'
		
		# Notification alerting of watch starting
		notifier.notify
			'title'   : 'Ready!'
			'message' : 'Grunt is now listening for changes…'
			'icon'    : './grunt/icons/grunt-success.png'