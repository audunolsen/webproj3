do (module) ->
	
	grunt     = require 'grunt'
	hooker    = require 'hooker'
	notifier  = require 'node-notifier'
	open 		 = require 'open'
	encode 	 = require 'encode-html'
	stripAnsi = require 'strip-ansi'
	pkgJson   = require '../../package.json'
	pkgName   = pkgJson.name
	taskName  = undefined
	
	# Get current taskname by hooking into the grunt task runner.
	grunt.util.hooker.hook grunt.task, 'runTaskFn', pre: (context) ->
		taskName = context.nameArgs
	
	# Which levels should output notifications
	levels = [ 'warn', 'error', 'fatal' ]

	levels.some (level) ->
		
		i = 0
		tasklog = []
		messages = []
		
		grunt.util.hooker.hook grunt.log, level, (obj) ->
			
			# Push current task to tasklog arr, used to compare current and previous tasks
			tasklog.push [i, taskName]
			
			current 	= i
			prior 	= i - 1
			
			# Reset error vars when task is changed, preventing stacking of old errors
			if i > 1 && tasklog[current][1] isnt tasklog[prior][1]
				messages = []
				HTMLtemplate = []
				errorFinal = ''
				message = ''
			
			i++
			
			# Push all parts of grunt.log output to array			
			messages.push obj.toString()
			# In case same error occurs twice or more, removes duplicate arr elms
			messages = messages.filter (item, index, self) ->
				index == self.indexOf(item)
			# Join to a string
			message = messages.join('\n')
			# Encode html entities (e.g. pug fails and displays tags in err msg)
			message = encode message
			# Convert to non breaking spaces in case of e.g. error pointers
			message = message.replace(/ /g, '&nbsp;')
			### Remove ansi color information if any. NOTE: grunt.log.uncolor()
			doesn't work, hence the the stripAnsi dependency ###
			message = stripAnsi message
			# parce error content to html
			HTMLmessage = '<main><h2> Task failed: ' + taskName + '</h2> \
								<p>' + message.split('\n').join('<br>') + '</p></main> \
								<footer><img src="icons/grunt-fail.png" width="60"><h3> Project: ' + pkgName + '</h3></footer>'
			# Split error template into array				
			HTMLtemplate = grunt.file.read('grunt/error-wrap.html', 'utf8').split('\n')
			# Place error content at the 27th line
			HTMLtemplate.splice(30, 1, HTMLmessage)
			# Final error string
			errorFinal = HTMLtemplate.join('\n')
			# Write the final error string to file
			grunt.file.write 'grunt/error.html', errorFinal
			
			# Notify user of the error
			notifier.notify {
				'title'   	: 'Error: ' + pkgName
				'subtitle'	: 'Task failed: ' + taskName
				'message' 	: 'Show the error?'
				'icon'    	: './grunt/icons/grunt-fail.png'
				'sound'   	: 'Funk'
				'timeout'	: 7
				'wait'	 	: true
				'actions'	: 'Show'
				'closeLabel': 'Ignore'
			}, (error, response) ->
				if response is 'activate' then open 'grunt/error.html'
		
		### Short circuit loop because some tasks tend to
		log identical output for both warn and error ###
		level == levels[0]