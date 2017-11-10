module.exports =
	
	# Global options
	options: pretty: false
	
	dist:
		options: pretty: false
		files: [ {
			expand: true
			cwd: 'src/'
			src: [ '**/*.pug', '!includes/**', '!includes/**/*.pug' ]
			dest: 'grunt/grunt-cache/'
			ext: '.TMP.html'
		} ]
