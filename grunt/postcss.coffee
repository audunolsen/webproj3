module.exports =
	
	# Global options
	options:
		processors: [ 
			require('autoprefixer')(browsers: [ 'last 4 versions' ])
			require('cssnano')()
		]
		
	# dist_css:
	# 	options:
	# 		map: true
	# 		map: inline: false
	# 		processors: [
	# 			require('autoprefixer')(browsers: 'last 4 versions')
	# 			# require('cssnano')()
	# 		]
	# 		# files: [ {
	# 		# 	expand: true
	# 		# 	cwd: 'src/'
	# 		# 	src: '**/*.css'
	# 		# 	dest: 'dist/'
	# 		# } ]
	# 		src: '**/*.css'