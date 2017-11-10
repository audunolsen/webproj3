module.exports =

	dynamic_uglify:
		options:
			preserveComments: false
			compress: true
			sourceMap: true
		files: [ {
			expand: true
			cwd: 'src/'
			src: [ '**/*.js', '!**/*CONCAT*/*.js' ]
			dest: 'dist/'
		} ]
		
	dynamic_uglify_temp:
		options:
			preserveComments: false
			compress: true
			sourceMap: true
		files: [ {
			expand: true
			src: 'dist/**/*.TMP.js'
			dest: 'dist/'
		} ]