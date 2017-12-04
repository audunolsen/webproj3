resultsNum = document.querySelector('.results')
resultsNumObserver = new MutationObserver (mutations) ->
		
	# May seem more intuitive to use toggleClass here, but it doesn't seem to work
	# Refactor later
	if resultsNum.innerHTML is '' then $('.results').addClass('hide').removeClass('show')
	else $('.results').removeClass('hide').addClass('show')

# configuration of the observer:
config = 
	childList: true
	subtree: true

# pass in the target node, as well as the observer options
resultsNumObserver.observe resultsNum, config