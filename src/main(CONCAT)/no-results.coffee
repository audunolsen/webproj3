noResults = document.querySelector('.no-results')
noResultsObserver = new MutationObserver (mutations) ->
		
	# May seem more intuitive to use toggleClass here, but it doesn't seem to work
	# Refactor later
	if noResults.innerHTML is '' then $('.no-results').addClass('hide').removeClass('show')
	else $('.no-results').removeClass('hide').addClass('show')

# configuration of the observer:
config = 
	childList: true
	subtree: true

# pass in the target node, as well as the observer options
noResultsObserver.observe noResults, config