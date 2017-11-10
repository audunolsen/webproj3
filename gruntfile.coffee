module.exports = (grunt) ->

	# Retrieve all the devDependencies from the package.json file
	require('load-grunt-config') grunt, jitGrunt: 
		
		# Jit-grunt ensures load time of Grunt does not slow down even if there are many plugins
		jitGrunt: true

		# Load custom tasks, same as 'grunt.loadTasks'
		customTasksDir: 'grunt/custom-tasks'
	
	# Measures the time each task takes
	require('time-grunt') grunt
	
	### Some "custom taksts" do not work with customTasksDir
   because they're driven by chokidar's watch event, they're not actually grunt tasks
	and therefore need to be separately required instead ###
	
	# Cross-platform desktop error notifications with node-notifier
	require './grunt/custom-tasks/notify-errors'
	
	# Sync deletion of privileged files and directories
	require './grunt/custom-tasks/privil-sync-delete'
	
	# Failsafe when adding src/ files already existing in dist/
	require './grunt/custom-tasks/file-exists'
	
	# Compile watch for pug include changes, and compile the files sourcing the includes
	require './grunt/custom-tasks/pug-includes'