$ ->
	$("#age-filter #min").html(18)
	$("#age-filter #max").html(70)
	$("#age-filter .slider").slider
		range: true
		min: 18
		max: 70
		values: [18, 70]
		slide: (event, ui) ->
			$("#age-filter #min").html(ui.values[0])
			$("#age-filter #max").html(ui.values[1])

	$("#price-filter #min").html(100)
	$("#price-filter #max").html(400)
	$("#price-filter .slider").slider
		range: true
		min: 0
		max: 500
		values: [100, 400]
		slide: (event, ui) ->
			$("#price-filter #min").html(ui.values[0])
			$("#price-filter #max").html(ui.values[1])


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