do (module) ->
	
	grunt = require 'grunt'

	# Auto-delete files or directories in dist/ which correspond to files or directories in src/ 
	# with special priviliges. This is necessary because items with special priviliges are
	# controlled by other GruntJS tasks and is therefore ignored by the default sync task
	grunt.event.on 'chokidar', (action, filepath, target) ->
		
		# Quit function if action isnt a file or directory deletion
		actions = ['unlink', 'unlinkDir']
		if action not in actions then return
		
		deleteFiles = (filetype, []) ->
			
			args 				  = arguments[1]
			files 			  = []
			
			distPath 		  = 'dist'
			tempPath 		  = 'grunt/grunt-cache'
			fileName 		  = filepath.slice(3).split('.')[0]
			
			concatedName 	  = fileName.replace(/(\((.*)$)/g, '')
			tempConcatedName = (fileName.substr 0, fileName.indexOf(')')+1) \
								  + (concatedName.substr concatedName.lastIndexOf('/'))
			
			if 'dist' in args
				dist = distPath + fileName + filetype
				files.push dist
			if 'distMap' in args
				distMap = distPath + fileName + filetype + '.map'
				files.push distMap
			if 'temp' in args
				temp = tempPath + fileName + '.TMP' + filetype
				files.push temp
			if 'tempMap' in args
				tempMap = tempPath + fileName + '.TMP' + filetype + '.map'
				files.push tempMap
			if 'tempConcated' in args
				tempConcated = tempPath + tempConcatedName + filetype
				files.push tempConcated
			if 'tempConcatDir' in args
				tempConcatedDir = tempPath + fileName
				files.push tempConcatedDir
			if 'tempConcatedMap' in args
				tempConcatedMap = tempPath + tempConcatedName + filetype + '.map'
				files.push tempConcatedMap
			if 'concated' in args
				concated = distPath + concatedName + filetype
				files.push concated
			if 'concatedMap' in args
				concatedMap = distPath + concatedName + filetype + '.map'
				files.push concatedMap
				
			files.forEach (file) ->
				grunt.file.delete file
				grunt.log.write '>> File "' + file + '" Deleted.\n'
				
		# TODO: Delete concatenated files when the source concat folders are deleted
		if /(\(CONCAT\))$/.test filepath	# Regex matching js concat folders
			deleteFiles '.js', ['tempConcated', 'tempConcatDir', 'tempConcatedMap', 'concated', 'concatedMap']
		
		if /(\(SASS\))$/.test filepath	# Regex matching sass concat folders
			deleteFiles '.css', ['tempConcated', 'tempConcatDir', 'tempConcatedMap', 'concated', 'concatedMap']
		
		# If you delete files inside the concat directories, then the deletion needs to be reflected in the final concated file
		# The below if clause will sync delete all the tmp files in grunt-cache/ and the delete final concated file before running dynamic_concat task to create a new concated file
		
		if /\(CONCAT\)/.test filepath # Regex matching files inside concat folders
			
			if /coffee/.test(filepath) then deleteFiles '.js', ['temp', 'tempMap']
			if /js/.test(filepath)     then deleteFiles '.js', ['temp', 'tempMap']
				
			deleteFiles '.js', ['tempConcated', 'tempConcatedMap', 'concated', 'concatedMap']
			grunt.task.run 'dynamic_concat'
				
		else
			
			if /css/.test(filepath)    then deleteFiles '.css', ['dist', 'distMap']
			if /sass/.test(filepath)   then deleteFiles '.css', ['dist', 'distMap', 'temp', 'tempMap']
			if /scss/.test(filepath)   then deleteFiles '.css', ['dist', 'distMap', 'temp', 'tempMap']
			if /pug/.test(filepath)    then deleteFiles '.html', ['dist', 'temp']
			if /html/.test(filepath)   then deleteFiles '.html', ['dist']
			if /coffee/.test(filepath) then deleteFiles '.js', ['dist', 'distMap', 'temp', 'tempMap']
			if /js/.test(filepath)     then deleteFiles '.js', ['dist', 'distMap']