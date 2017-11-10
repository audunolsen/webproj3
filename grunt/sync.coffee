module.exports =

	main:
		files: [ {
			cwd: 'src/'
			src: [
				'**'
				'!**/*CONCAT*/**'
				'!**/*SASS*/**'
				'!includes/**'
				'!**/*.{pug,html,coffee,js,css,sass,scss}'
			]
			dest: 'dist/'
		} ]
		#Never remove specified files from destination. Default: none
		ignoreInDest: [
			'bower_components/**'
			'**/*.html'
			'**/*.js'
			'**/*.css'
			'**/*.*.map'
		]
		#Remove all files from dest that are not found in src. Default: false
		updateAndDelete: true
