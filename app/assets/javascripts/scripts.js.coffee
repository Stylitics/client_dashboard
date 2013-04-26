$ ->
	$("#open-filters").click (e) ->
		e.preventDefault()
		if $(".left").is(":visible")
			$(".left .sidebar").hide "slide",
			direction: "left"
			, 500, ->
				$(".left").hide()
			$("#open-filter-icon").removeClass('icon-chevron-left')
			$("#open-filter-icon").addClass('icon-chevron-right')
		else
			$(".left").show()
			$(".left .sidebar").show "slide",
				direction: "left"
				, 500
			$("#open-filter-icon").removeClass('icon-chevron-right')
			$("#open-filter-icon").addClass('icon-chevron-left')


	$("#my-saved-segments").click (e) ->
		e.preventDefault()
		if $("#filters-container").is(":visible")
			$("#filters-container").hide "slide",
			direction: "top"
			, 500, ->
				$(".left").hide()
			$(this).find('#icon').removeClass('icon-chevron-left')
			$(this).find('#icon').addClass('icon-chevron-right')
		else
			$("#filters-container").show "slide",
				direction: "top"
				, 500
			$(this).find('#icon').removeClass('icon-chevron-right')
			$(this).find('#icon').addClass('icon-chevron-left')