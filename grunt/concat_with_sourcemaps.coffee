module.exports =

	dist:
		options:
			sourceRoot: '../../'
		files: 'dist/concat-js/concat.js': [ 'dist/compile-coffee/*.js' ]
