populateFilter = (years, categories) ->
	
	rmDuplicates = (arr) -> arr.filter (item, index, self) -> return index == self.indexOf(item)
	
	years = rmDuplicates years.sort()
	categories = rmDuplicates categories
	
	if years.length > 1
		
		$('.filter-inner').append('<div class="years"><p class="filter-title">year</p)></div>')
		
		for year in years
			$('<div class="tag unchecked" title="' + year + '">' + year + '</div>').appendTo('.years')
	
	if categories.length > 1
		
		$('.filter-inner').append('<div class="categories"><p class="filter-title">category</p)></div>')
		
		for category in categories
			$('<div class="tag unchecked" title="' + category + '">' + category + '</div>').appendTo('.categories')
			
	if years.length is 1 and categories.length is 1 then $('.filter').addClass('hide').removeClass('show')	
	else $('.filter').addClass('show').removeClass('hide') 