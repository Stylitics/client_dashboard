$ ->
	$("#open-filters").click (e) ->
		e.preventDefault()
		if $(".left .sidebar").is(":visible")
			$(".left .sidebar").hide "slide",
			direction: "left"
			, 500
			$("#open-filter-icon").removeClass('icon-chevron-left')
			$("#open-filter-icon").addClass('icon-chevron-right')
		else
			$(".left .sidebar").show "slide",
				direction: "left"
				, 500
			$("#open-filter-icon").removeClass('icon-chevron-right')
			$("#open-filter-icon").addClass('icon-chevron-left')