module.exports =

	options:
		removeComments: true
		collapseWhitespace: true
	
	temp:
		files: [ {
			expand: true
			cwd: 'grunt/grunt-cache/'
			src: [ '**/*.TMP.html' ]
			dest: 'dist/'
			ext: '.html'
		} ]
	
	dist:
		files: [ {
			expand: true
			cwd: 'src/'
			src: [ '**/*.html', '!includes/**' ]
			dest: 'dist/'
		} ]