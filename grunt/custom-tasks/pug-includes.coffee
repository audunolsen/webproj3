do (module) ->
	
	grunt    = require 'grunt'
	shell    = grunt.config.get 'shell'
	pug      = grunt.config.get 'pug'
	min      = grunt.config.get 'htmlmin'
	
	# Pug includes do not need to compile, but the files sourcing them do.
	grunt.event.on 'chokidar', (action, filepath, target) ->
		
		# Quit function if action isnt a file modification
		if action isnt 'change' then return
		
		# Remove path and any potential line breaks
		basename = (path) -> return (path.substr path.lastIndexOf('/')+1).trim()
		
		# Callback function using stdout of below shell[filepath] task
		compileRetrievers = (err, stdout, stderr, cb) ->
			# Carry on if shell command fails
			if err then cb()
			
			# Split stdout into array where each elm is an individual file
			files = stdout.split('\n')
			# Remove falsey elements from array
			files = files.filter(Boolean)
			
			files.forEach (file) ->
				
				# Define destination file
				destFile = 'grunt/grunt-cache/' + file.substring(0, file.lastIndexOf('.')).slice(3) + '.TMP.html'
				
				# Compile the found sourcing files
				pug[file] =
					files: [ { 
						src: file
						dest: destFile
					} ]
				grunt.config.set 'pug', pug
				grunt.task.run 'pug:' + file
				grunt.task.run 'newer:htmlmin:temp'
			
			cb()
		
		# Use a grep command to find all files sourcing modified pug include
		shell[filepath] =
			command: 'grep -rl --include=\\*.pug ' + basename(filepath) + ' src 2> /dev/null'
			options: callback: compileRetrievers
		grunt.config.set 'shell', shell
		grunt.task.run 'shell:' + filepath