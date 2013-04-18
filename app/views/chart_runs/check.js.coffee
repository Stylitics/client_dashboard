<% if @not_ready == true %>
setTimeout () ->
  $.get "/charts/trend-line/chart_runs/" + $("#trend-chart-filter-form").data("id") + "/check"
, 10000
<% else %>
window.location.refresh()
<% end %>