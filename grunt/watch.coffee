# module.exports =
# 	
# 	# Dynamic Concat of js files within *[CONCAT] folders
# 	# UNCOMPLETE
# 	dynamicScriptsConcat:
# 		files: 'src/**/*CONCAT*'
# 		tasks: 'dynamicScriptsConcat'
# 		options:
# 			event: ['changed', 'added', 'deleted']
# 			spawn: false
# 
# 	# # Compile > Concat > Minify all .coffee in src/coffee/
# 	# scriptsConcat:
# 	# 	files: 'src/coffee/*.coffee'
# 	# 	tasks: 'scriptsConcat'
# 	# 	options:
# 	# 		event: ['changed', 'added', 'deleted']
# 	# 		spawn: false
# 	# 
# 	# # Compile and distribute accordingly > Minify all .coffee in src/**
# 	# scripts:
# 	# 	files: ['src/**/*.coffee', '!src/coffee/*.coffee']
# 	# 	tasks: 'scripts'
# 	# 	options:
# 	# 		event: ['changed', 'added']
# 	# 		spawn: false
# 
# 	# Compile pug -> minify the html -> clean uneccesary files
# 	markup:
# 		files: ['src/**/*.pug', '!src/includes/*.pug']
# 		tasks: 'markup'
# 		options:
# 			event: ['changed', 'added']
# 			spawn: false
# 
# 	# Auto-delete html or js files in dist/ corresponding to src/ pug or coffee files when deleting
# 	syncDelete:
# 		files: [
# 			'src/**/*.pug'
# 			'!src/includes/*.pug'
# 			'src/**/*.coffee'
# 			'!src/coffee/*.coffee'
# 		]
# 		options:
# 			event: ['deleted']
# 			spawn: false
# 
# 	# Compile pug (only includes - to speed up sync deletion process) -> minify the html -> clean uneccesary files
# 	markup_includes:
# 		files: 'src/includes/*.pug'
# 		tasks: 'markup'
# 		options:
# 			event: ['changed', 'added', 'deleted']
# 			spawn: false
# 
# 	# Compile sass -> autoprefix and compress css -> clean uneccesary files
# 	styles:
# 		files: 'src/**/*.sass'
# 		tasks: 'styles'
# 		options:
# 			event: ['changed', 'added', 'deleted']
# 			spawn: false
# 
# 	# Added files and file deletions are synced with dist/
# 	maintenance:
# 		files: [
# 			'src/**'
# 			# 'src/**/*.*'
# 			# 'src/**/'
# 			# 'src/**/**'
# 			'!src/**/*.coffee'
# 			'!src/**/*.pug'
# 			'!src/**/*.sass'
# 		]
# 		tasks: 'maintenance'
# 		options:
# 			event: ['changed', 'added', 'deleted']
# 			spawn: false
