do (module) ->
	
	grunt    = require 'grunt'
	notifier = require 'node-notifier'
	shell    = grunt.config.get 'shell'
	
	### Check if file already exist in dist/
	Example, src/ has a test.pug file, a failsafe is 
	needed to deny the creation of a index.html file
	which will overwrite and destroy the link between the 
	preprocessor file and the dist/ file. ###
	
	grunt.event.on 'chokidar', (action, filepath, target) ->
		
		# Quit function if action isnt a file add
		if action isnt 'add' then return
		
		# Function replacing extension of filepath
		newExtension = (ext) -> filepath = filepath.split('.')[0] + ext
		
		# Replace extension depending on what extension filepath already has
		# This is a necessary precaution to account for preprocessor languages
		if /pug/.test(filepath)     then newExtension '.html'
		if /sass/.test(filepath)    then newExtension '.css'
		if /scss/.test(filepath)    then newExtension '.css'
		if /coffee/.test(filepath)  then newExtension '.js'
		
		distFile = 'dist' + filepath.slice(3)
		
		fileExists = (err, stdout, stderr, cb) ->
			# Carry on if shell command fails
			if err then cb()
			# Remove path and any potential line breaks
			basename = (path) -> return (path.substr path.lastIndexOf('/')+1).trim()
			# Quit function if file deleted doesnt exist in dist/
			# NOTE: This may be redundat as the shell command kind of does the same.
			if basename(filepath) isnt basename(stdout) then return
			
			# Notification alerting file already existing in dist/
			notifier.notify
				'title'   : 'File not created'
				'message' : basename(filepath) + ' already exists in dist/'
				'icon'    : './grunt/icons/grunt-fail.png'
				'sound'   : 'Funk'
			
			shell[basename(filepath)] =
				command: 'rm -rf ' + filepath
			grunt.config.set 'shell', shell
			grunt.task.run 'shell:' + basename(filepath)
			
			cb()
		
		# Use grunt shell to list and check if file exists in dist/
		shell[filepath] =
			command: 'ls ' + distFile + ' 2> /dev/null'
			options: callback: fileExists
		grunt.config.set 'shell', shell
		grunt.task.run 'shell:' + filepath