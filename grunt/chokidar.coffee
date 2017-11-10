module.exports =
	
	# Restart chokidar (watch) task when grunt config files are changed
	configFiles:
		files: [
			'gruntfile.{coffee,js}'
			'grunt/**/*.{coffee,js}'
			'grunt/**/*.yaml'
			'custom_taks/**/*.{coffee,js}'
		]
		options: reload: true
		
	# Added files and file deletions are synced with dist/
	maintenance:
		files: [
			'src/**'
			'src/**/*.*'
			'src/**/'
			'src/**/**'
			'!src/**/*.{coffee,pug,sass,scss,html,js,css}'
		]
		tasks: 'sync'
		options:
			event: [ 'change', 'add', 'unlink', 'addDir', 'unlinkDir' ]
			spawn: false
	
	# Compile coffee -> concat js -> clean temp dir
	dynamic_concat:
		files: 'src/**/*CONCAT*/*.{js,coffee}'
		tasks: 'dynamic_concat'
		options:
			event: [ 'change', 'add' ]
			spawn: false
	
	# Update the final concated js file when deleteing the partitioned source files
	# Requires no task because it only needs to activate the gruntfile's sync delete
	dynamic_concat_delete:
		files: 'src/**/*CONCAT*/*.{js,coffee}'
		options:
			event: 'unlink'
			spawn: false
	
	# Compile sass directories -> prefix/minify css -> clean unecessary files		
	dynamic_sass_dir:
		files: 'src/**/*SASS*/**/*.{sass,scss}'
		tasks: 'dynamic_sass_dir'
		options:
			event: [ 'change', 'add', 'unlink' ]
			spawn: false
	
	# Uglify js in src/ and parallelly distribute to dist/		
	dynamic_uglify:
		files: [ 'src/**/*.js', '!src/**/*CONCAT*/**/*.js' ]
		tasks: 'dynamic_uglify'
		options:
			event: [ 'change', 'add' ]
			spawn: false
	
	# Compile coffee -> uglify js -> Clean temp files		
	dynamic_coffee:
		files: [ 'src/**/*.coffee', '!src/**/*CONCAT*/**/*.coffee' ]
		tasks: 'dynamic_coffee'
		options:
			event: [ 'change', 'add' ]
			spawn: false
			
	# Compile pug -> minify the html
	markup:
		files: [ 'src/**/*.pug', '!src/includes/**/*.pug' ]
		tasks: 'markup'
		options:
			event: [ 'change', 'add' ]
			spawn: false
			
	# minify the html in src and distribute accordingly to dist
	htmlmin_only:
		files: [ 'src/**/*.html', '!src/includes/**/*.html' ]
		tasks: 'newer:htmlmin:dist'
		options:
			event: [ 'change', 'add' ]
			spawn: false
	
	# prefix and minify lone .css files and distribute accordingly to dist
	dynamic_css:
		files: 'src/**/*.css'
		tasks: 'dynamic_css'
		options:
			event: [ 'change', 'add' ]
			spawn: false
			
	# prefix and minify lone {sass,scss} files and distribute accordingly to dist
	dynamic_sass:
		files: [ 'src/**/*.{sass,scss}', '!src/**/*SASS*/**/*.{sass,scss}' ]
		tasks: 'dynamic_sass'
		options:
			event: [ 'change', 'add' ]
			spawn: false
			
	# Compress and distribute all image files accordingly
	compress_img:
		files: 'src/**/*.{png,jpg,jpeg,gif}'
		tasks: 'imagemin'
		options:
			event: 'add'
			spawn: false
			
	# Auto-delete files or directories in dist/ which correspond to files or directories in src/ with special priviliges.
	# No task defined because functionality is triggered by chokidar watch event
	privil_sync_delete:
		files: [
			'src/**/*.{html,pug,coffee,js,css,scss,sass}'
			'!src/includes/**/*.pug'
			'!src/**/*CONCAT*/**/*.{coffee,js}'
			'!src/**/*SASS*/**/*.{sass,scss}'
		]
		options:
			event: 'unlink'
			spawn: false
	
	# Do not compile pug includes, but compile the files that source include files
	# No task defined because functionality is triggered by chokidar watch event
	compile_retrievers:
		files: 'src/includes/**/*.pug'
		options:
			event: 'change'
			spawn: false