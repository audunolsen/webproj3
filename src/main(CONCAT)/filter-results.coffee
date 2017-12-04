$('.filter-link').click ->
	
	$('html, body').animate
		scrollTop: $('.filter').offset().top
	, 300

$('.filter').bind 'click', (event) ->
  
	clicked = $(event.target)
  
	show = []
	hide = []
  
	if clicked.hasClass('tag') then clicked.toggleClass('checked unchecked')
	
	tags = $('.tag')
	
	for tag in tags
		tag = $(tag)
		if tag.hasClass('checked') then show.push tag.text() else hide.push tag.text()
	
	isActive = (elm) -> $(elm).find('.tag.checked').length isnt 0	
	
	bothActive = if isActive($('.filter .years')) and isActive($('.filter .categories')) then true else false
		
	if show.length then filterResults(hide, show, bothActive) 
	else
		$('.filter-feedback').addClass('hide').removeClass('show')
		$('.result-cards .card-template').show()
	
filterResults = (hide, show, bothActive) ->
	
	cards = $('.result-cards .card-template')
	
	for card in cards
		
		card 		= $(card)
		year 		= card.find('.year-hidden').text()
		category = card.find('.category-hidden').text()
		
		### TODO: Refactor -> move functions out of loop, declaring single func with
		year and category as params ###
		yearMatch = (element) -> element is year
		categoryMatch = (element) -> element is category
		
		if bothActive
			if show.some(yearMatch) and show.some(categoryMatch) then card.show() else card.hide()
		else	
			if hide.some(yearMatch) and hide.some(categoryMatch) then card.hide() else card.show()
	
	
	hiddenCards = $('.result-cards .card-template[style*="display: none;"]').length
	shownCards = $('.result-cards .card-template').length - hiddenCards
	
	filterFeedback(hiddenCards, shownCards)

filterFeedback = (hiddenQty, shownQty) ->
	
	$('.filter-feedback').addClass('show').removeClass('hide')
	
	if not shownQty
		$('.filter-feedback').addClass('alert')
		$('.filter-feedback p').text 'No results with current filters'
	
	else 
		$('.filter-feedback').removeClass('alert')
		$('.filter-feedback p').text 'Filtered down to ' + shownQty + if shownQty is 1 then ' result' else ' results'
	
	