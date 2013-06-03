@getMonday = (d) ->
  d = new Date(d)
  day = d.getDay()
  diff = d.getDate() - day + (day == 0 ? -6 : 1)
  new Date(d.setDate(diff))