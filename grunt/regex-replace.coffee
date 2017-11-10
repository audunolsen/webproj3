module.exports =

	sourcemap_dynamic_uglify:
		src: [ 'dist/**/*.js.map' ]
		actions: [
			{
				search: /((\.\.\/)+)/g
				replace: 'file://' + process.env.PWD + '/'
			}
		]