$ ->
	$(".slider").slider
		range: true
		min: 0
		max: 500
		values: [75, 300]
		slide: (event, ui) ->
			console.log ui.values[0] + "<< >>" + ui.values[1]

	$(".datepicker").datepicker()
	$(".datepicker").datepicker "option", "showAnim", "fadeIn"

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