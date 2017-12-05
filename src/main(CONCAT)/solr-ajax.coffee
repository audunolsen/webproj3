$ ->
	
	searchField = $('#search-field')
	
	# Return filename without path (string)
	# basename   = (path)   -> return path.substr path.lastIndexOf('/')+1
	# Strip quotes from arg (if any)
	# stripQuote = (string) -> return string.replace(/^"(.*)"$/, '$1')
	
	parseDate = (date) -> 
		if date is undefined then date = '2000-01-01' # TEMPORARY: Assign dummydate
		return date.toString().substring 0, 10
	
	result = (obj) ->
		
		$('.filter').addClass('hide').removeClass('show')
		$('.result-cards').empty()
		$('.filter-inner').empty()
		
		console.log 'showing results'
		
		query = obj.responseHeader.params.q
		found = obj.response.numFound
		
		showErr = if found isnt 0 or query is '' then false else true
		$('.no-results').text if showErr then 'No results for "' + query + '"' else ''
		$('.results').text if found > 0 then 'Found '+ found + ' results for "' + query + '"' else ''
		if not query or not found then return
		
		years = []
		categories = []
		for data in obj.response.docs
			categories.push data.keywords.toString()
			years.push parseInt parseDate(data.creation_date)
			
		if years.length > 1 or categories.length > 1 then populateFilter(years, categories)
		
		if $('.filter').hasClass('hide')
			
			$('html, body').animate
				scrollTop: $('#cards').offset().top
			, 300
		
		else 
			
			$('html, body').animate
				scrollTop: $('.filter-link').offset().top-15
			, 300
		
		# cardTemplate = $('.template-card').
		i = 1
		for doc in obj.response.docs
			
			cardTemplate = $('.card-template:first').clone().addClass i.toString()
			
			$('.result-cards').append(cardTemplate)
			
			$('.card-template.'+i+' p.category').text "category: " + doc.keywords
			$('.card-template.'+i+' h2.title').text doc.pdf_docinfo_title
			$('.card-template.'+i+' p.author').text "Written by " + doc.author + " – " + parseDate(doc.creation_date)
			$('.card-template.'+i+' p.summary').text doc.subject
			$('.card-template.'+i+' .pdf-link').attr 'href', 'docs/' + doc.stream_name
			$('.card-template.'+i+' .hidden-data .year-hidden').text parseInt parseDate(doc.creation_date)
			$('.card-template.'+i+' .hidden-data .category-hidden').text doc.keywords
			
			i++
		
		setTimeout ->
			i = 0
			interval = setInterval ->
				cards = $('.result-cards .card-template')
				card = cards[i]
				$(card).addClass 'show'
				i++
				if i is cards.length then clearInterval interval
			, 100
		, 500

	$('#search-btn').click (e) ->
		
		e.preventDefault()
		
		search = searchField.val()
		
		$.ajax
			# url: 'http://user:cnzyCXC2XAdV@35.188.28.4/solr/ptil/select?q=' + search
			url: 'http://35.188.28.4/solr/ptil/select?q=' + search
			cache: false
			# xhrFields: withCredentials: true
			# beforeSend: (xhr) ->
			# 	xhr.setRequestHeader 'Authorization', 'Basic ' + btoa('user:cnzyCXC2XAdV')
			type: 'GET'
			success: (data) -> result(data)
			dataType: 'jsonp'
			jsonp: 'json.wrf'