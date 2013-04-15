$ ->
	$("#age-filter #min").html(10)
	$("#age-filter #max").html(100)
	$("#age-filter .slider").slider
		range: true
		min: 10
		max: 100
		values: [10, 100]
		slide: (event, ui) ->
			$("#age-filter #min").html(ui.values[0])
			$("#age-filter #max").html(ui.values[1])

	$("#price-filter #min").html(0)
	$("#price-filter #max").html(100000)
	$("#price-filter .slider").slider
		range: true
		min: 0
		max: 100000
		values: [0, 100000]
		slide: (event, ui) ->
			$("#price-filter #min").html(ui.values[0])
			$("#price-filter #max").html(ui.values[1])

	# $(".datepicker").datepicker()
	# $(".datepicker").datepicker "option", "showAnim", "fadeIn"

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