$ ->
	
	searchField = $('#search-field')
	
	toggleError = (elm, visibility, errorMsg) ->
		elm.after('<span class="error hide"></span>')
		errorElm = $('span.error')
		if visibility is 'show'
			errorElm.addClass('show').removeClass('hide')
			elm.addClass('error-field')
		if visibility is 'hide' 
			errorElm.addClass('hide').removeClass('show')
			elm.removeClass('error-field')
		errorElm.text errorMsg
	
	
	# Return filename without path (string)
	basename   = (path)   -> return path.substr path.lastIndexOf('/')+1
	# Strip quotes from arg (if any)
	stripQuote = (string) -> return string.replace(/^"(.*)"$/, '$1')
	
	# Callback when ajax request is made
	result = (obj, search) ->
		
		# Word searched for
		query = obj.responseHeader.params.q
		
		# Quit function early if no files are found
		if obj.response.numFound is 0
			alert 'No matches found for "' + query + '"'
			return
		
		# File found
		file  = stripQuote JSON.stringify(obj.response.docs[0].id)
		
		# Display results
		alert  'You searcehd for: ' + query + '\n\
				 Files found: ' 		 + basename(file)

	$('#search-btn').on 'click', ->
		
		search = searchField.val()
		
		# Show error if search is empty and quit function
		if search is ''
			toggleError searchField, 'show', 'Field is empty'
			return
		# Remove error field class iff it exists
		# else 
		# 	searchField.removeClass('error-field')
		# 	toggleError('hide')
		
		$.ajax
			url: 'http://localhost:8983/solr/gettingstarted/select?indent=on&q=' + search + '&wt=json'
			success: (data) -> result(data)
			dataType: 'jsonp'
			jsonp: 'json.wrf'