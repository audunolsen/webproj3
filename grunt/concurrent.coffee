module.exports =
	
	options: logConcurrentOutput: false
	ready: ['build_if_empty']
	watch: ['chokidar', 'browserSync']