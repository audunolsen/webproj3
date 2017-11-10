module.exports =

	dynamic_coffee:
		options:
			sourceMap: true
		expand: true
		cwd: 'src/'
		src: [
			'**/*.coffee'
			'!**/*CONCAT*/*.coffee'
		]
		dest: 'dist/'
		ext: '.TMP.js'
