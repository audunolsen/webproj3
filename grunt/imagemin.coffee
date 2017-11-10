module.exports =
	options: cache: false
	dist: files: [ {
		expand: true
		cwd: 'src/'
		src: [ '**/*.{png,jpg,jpeg,gif}' ]
		dest: 'dist/'
	} ]
