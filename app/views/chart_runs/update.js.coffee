$("#filter-loading").removeClass("hide")
$.get "/charts/trend-line/chart_runs/" + $("#trend-chart-filter-form").data("id") + "/check"