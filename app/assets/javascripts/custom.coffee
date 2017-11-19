# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# FUNCTIONS

# Convert dates to format like '09 Nov 2017 15:04:21'
convertDate = (date) ->
  month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  dd = new Date(date).getDate()
  if dd < 10 then dd = '0' + dd else JSON.stringify(dd)
  bb = new Date(date).getMonth()
  yyyy = new Date(date).getFullYear()
  hh = new Date(date).getHours()
  if hh < 10 then hh = '0' + hh else JSON.stringify(hh)
  mm = new Date(date).getMinutes()
  if mm < 10 then mm = '0' + mm else JSON.stringify(mm)
  ss = new Date(date).getSeconds()
  if ss < 10 then ss = '0' + ss else JSON.stringify(ss)
  date = dd+' '+month[bb]+' '+yyyy+' '+hh+':'+mm+':'+ss
  return date

# Return event data when pass filters, if not replace event with word 'filtered'
filter = (event, startDate, endDate, directionFilter, photoFilter) ->
  date = new Date(event[0])
  direction = event[1]
  photo = event[2]
  if (direction.includes(directionFilter) or directionFilter == 'all') 
    if (photo.includes(photoFilter) or photoFilter == 'all')
      if startDate == null and endDate == null then return event
      if startDate == null and date <= endDate then return event
      if endDate == null and date >= startDate then return event
      if date <= endDate and date >= startDate then return event
      return 'filtered'
    return 'filtered'
  return 'filtered'

# Prepare data for chart
prepareData = (table) ->
  # Get data from table
  directions = table.column(1).data()
  dates = table.column(2).data()
  photo = table.column(3).data()

  # Get filters values
  [startDate, endDate] = getDateRange('#start-date', '#end-date')
  [directionFilter, photoFilter] = getFiltersValues('#direction', '#photo')

  # Combine dates with directions and photo
  # Events array looks like [[date, direction, photo], ...]
  events = dates.map((e, i) ->
    [e, directions[i], photo[i]]
  )

  # Apply filters
  events = events.map((e) ->
    filter(e, startDate, endDate, directionFilter, photoFilter)
  )

  # Check if events array has any non "filtered" event
  for event in events
    unless event == 'filtered'
      hasNonFilteredEvent = true
      break
    else 
      hasNonFilteredEvent = false

  # If events has any non 'filtered' event prepare data
  # else set data for chart to 'No data'
  if hasNonFilteredEvent
    # Delete all "filtered" elements
    events = events.filter (event) ->
      event != 'filtered'

    # Delete date in format Date and replace it with strings 'date', 'hour'
    # like:
    # Thu Nov 09 2017 15:20:19 GMT+0100 (CET) -> '09 Nov 2017', '15:20:19'
    events = events.map((e) ->
      # Events array format -> [[date, direction, photo], ...]
      # Take event's date and convert it to string
      date = convertDate(e[0])
      # Delete date in Date format
      e.splice(0, 1)
      # Add at index 0 Hour and then Date
      e.splice(0, 0, (date.slice(12, 14)+':00:00'))
      e.splice(0, 0, (date.slice(0, 11)))
      # Return event
      e
    )

    # Finally events looks like
    # [['09 Nov 2017', '15:20:19', 'in', 'no-photo'], [...]]
    # console.log events

    # Axis X of the chart - create labels
    # Check if only one day was chosen
    # startDate is in format like: Thu Nov 09 2017 15:20:19 GMT+0100 (CET)
    # convert it to string '09 Nov 2017 15:20:19'
    # and take 11 elements -> 09 Nov 2017
    if convertDate(startDate).slice(0,11) == convertDate(endDate).slice(0,11)
      xAxis = [ '00:00:00', '01:00:00', '02:00:00', '03:00:00', '04:00:00',
                '05:00:00', '06:00:00', '07:00:00', '08:00:00', '09:00:00',
                '10:00:00', '11:00:00', '12:00:00', '13:00:00', '14:00:00',
                '15:00:00', '16:00:00', '17:00:00', '18:00:00', '19:00:00',
                '20:00:00', '21:00:00', '22:00:00', '23:00:00']
      setHours = true
    else
      # Number of days to show
      numberOfDays = (endDate.getTime()-startDate.getTime())/(24*60*60*1000)
      numberOfDays = Math.ceil(numberOfDays)
      xAxis = []
      # Calculates all dates from chosen date range
      for i in [0...numberOfDays]
        date = new Date(startDate.getTime() + (i * 24 * 60 * 60 * 1000))
        xAxis.push(convertDate(date).slice(0,11))
      setHours = false

    # Create results array in format [[date or hour, walkedIn, walkedOut], ...]
    results = xAxis.map((e) ->
      [e, 0, 0]
    )
    # Calculate number of walked in and walked out in every date/hour
    for event in events
      if setHours then i = xAxis.indexOf(event[1]) else i = xAxis.indexOf(event[0])
      if event[2].includes('in') then results[i][1]+= 1 else results[i][2]+= 1
  else
    results = ['No data']
    xAxis = ['No data']

  walkedIn = []
  walkedOut = []
  unless results == ['No data']
    for data in results
      walkedIn.push(data[1])
      walkedOut.push(data[2])

  return [xAxis, walkedIn, walkedOut]

# Update the chart with new data
updateChart = (chart, labels, dataset1, dataset2) ->
  # Remove datasets
  chart.data.labels.pop()
  for dataset in chart.data.datasets
    dataset.data.pop()
  # Add new datasets
  chart.data.labels = labels
  chart.data.datasets[0].data = dataset1
  chart.data.datasets[1].data = dataset2
  chart.update(0)

# Get values from datepickers
getDateRange = (startID, endID) ->
  startDate = $(startID).datepicker('getDate')
  endDate = $(endID).datepicker('getDate')
  unless endDate == null
    endDate.setHours(endDate.getHours()+24)
    endDate.setSeconds(endDate.getSeconds()-1)
  return [startDate, endDate]

# Get values from filters
getFiltersValues = (direction, photo) ->
  direction = $(direction).val()
  photo = $(photo).val()
  return [direction, photo]

# Just makes three functions into one
updateTableAndChart = (table, chart, updateTable)->
  [dates, walkedIn, walkedOut] = prepareData(table)
  updateChart(chart, dates, walkedIn, walkedOut)
  if updateTable then table.draw()

# Change type of the chart
changeCharType = (chart, config, newType, showLine) ->
  ctx = $('#chart')
  chart.destroy()
  temp = jQuery.extend(true, {}, config)
  if newType == 'line'
    temp.options.scales.xAxes[0].gridLines.offsetGridLines = false
  else
    temp.options.scales.xAxes[0].gridLines.offsetGridLines = true
  temp.data.datasets[0].showLine = showLine
  temp.data.datasets[1].showLine = showLine
  temp.type = newType
  chart = new Chart(ctx, temp)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# DOM IS READY
$(document).on 'turbolinks:load', ->

  # Change cookies info
  text = 'This website uses cookies. '
  text += 'By continuing to use this site you agree to the use of cookies.'
  $('.cookies-eu-content-holder').text(text)

  # Create DataTable
  table = $('#events').DataTable(
    order: [2, 'desc'],
    iDisplayLength: 10,
    columnDefs: [ {
      targets: [0, 1, 3]
      orderable: false
    } ]
  )

  # Set needed variables
  earliestDate = table.column(2).data().sort()[0] # Earliest from data table

  latestDate = table.column(2).data().sort().reverse()[0] # Latest from data table
  
  todayDate = new Date() # Today
  
  today = new Date() # Variable to help calculate other dates

  yesterdayDate = today.setTime(today.getTime() - (24 * 60 * 60 * 1000))
  yesterdayDate = new Date(yesterdayDate)

  last7Days = today.setTime(today.getTime() - (6 * 24 * 60 * 60 * 1000))
  last7Days = new Date(last7Days)

  last30Days = today.setTime(today.getTime() - (23 * 24 * 60 * 60 * 1000))
  last30Days = new Date(last30Days)

  # Create datepickers
  $('#start-date').datepicker
    dateFormat: "dd M yy"
    changeMonth: true
    changeYear: true
    onSelect: ->
      # ALERT - Start date can't be later than end day
      [startDate, endDate] = getDateRange('#start-date', '#end-date')
      if startDate > endDate
        alert "Incorrect range - start date can't be later than end day"
        $('#start-date').datepicker('setDate', earliestDate)
      else
        updateTableAndChart(table, chart, true)

  # Create datepicker
  $('#end-date').datepicker
    dateFormat: "dd M yy"
    changeMonth: true
    changeYear: true
    onSelect: ->
      # ALERT - End date can't be earlier than start day
      [startDate, endDate] = getDateRange('#start-date', '#end-date')
      if endDate < startDate
        alert "Incorrect range - end date can't be earlier than start day"
        $('#end-date').datepicker('setDate', todayDate)
      else
        updateTableAndChart(table, chart, true)

  # Set defaults values of datepickers
  $('#start-date').datepicker('setDate', earliestDate)
  $('#end-date').datepicker('setDate', latestDate)

  # Predefined date filters

  # Filters behaviour
  $('#today-filter').click ->
    $('#start-date').datepicker('setDate', todayDate)
    $('#end-date').datepicker('setDate', todayDate)
    updateTableAndChart(table, chart, true)

  $('#yesterday-filter').click ->
    $('#start-date').datepicker('setDate', yesterdayDate)
    $('#end-date').datepicker('setDate', yesterdayDate)
    updateTableAndChart(table, chart, true)

  $('#last-7-days-filter').click ->
    $('#start-date').datepicker('setDate', last7Days)
    $('#end-date').datepicker('setDate', todayDate)
    updateTableAndChart(table, chart, true)

  $('#last-30-days-filter').click ->
    $('#start-date').datepicker('setDate', last30Days)
    $('#end-date').datepicker('setDate', todayDate)
    updateTableAndChart(table, chart, true)

  $('#all-filter, #reset-date-range-btn').click ->
    $('#start-date').datepicker('setDate', earliestDate)
    $('#end-date').datepicker('setDate', latestDate)
    updateTableAndChart(table, chart, true)

  # Detect changes in direction and photo filters
  $('select').on('change', ->
    updateTableAndChart(table, chart, true)
  )

  # Create new table depends on filters
  $.fn.dataTable.ext.search.push (settings, data, dataIndex) ->
    # Values from filters
    [startDate, endDate] = getDateRange('#start-date', '#end-date')
    [filterDirection, filterPhoto] = getFiltersValues('#direction', '#photo')
    # Data from table
    rowDirection = data[1].replace(/\s/g,'')
    rowDate = new Date(data[2])
    rowPhoto = data[3]

    # Filters logic
    if (filterDirection == rowDirection or filterDirection == 'all') 
      if (filterPhoto == rowPhoto or filterPhoto == 'all')
        if startDate == null and endDate == null
          return true
        if startDate == null and rowDate <= endDate
          return true
        if endDate == null and rowDate >= startDate
          return true
        if rowDate <= endDate and rowDate >= startDate
          return true
        false
      false
    false

  # Draw a new chart
  [dates, walkedIn, walkedOut] = prepareData(table)
  config =
    type: 'bar'
    data:
      labels: dates
      datasets: [ 
        {
          label: 'Walked in'
          borderColor: '#359e2c'
          borderWidth: 2
          showLine: true
          backgroundColor: '#359e2c'
          fill: false
          data: walkedIn
        }
        {
          label: 'Walked out'
          borderColor: '#9e2c2c'
          borderWidth: 2
          showLine: true
          backgroundColor: '#9e2c2c'
          fill: false
          data: walkedOut
        }
      ]
    options:
      responsive: true
      scales:
        xAxes: [
          {
            barPercentage: 0.3
            categoryPercentage: 0.60
            ticks: {
              maxRotation: 90
            }
            gridLines: {
                offsetGridLines: true
            }
          }
        ]
  ctx = $('#chart')
  chart = new Chart(ctx, config)

  # Open filters menu
  $('#open-menu').click ->
    $('#left-panel').toggle()

  # Change chart type
  $("#line").click ->
    chart = changeCharType(chart, config, 'line', true);
    updateTableAndChart(table, chart, false)
    
  $("#bar").click ->
    chart = changeCharType(chart, config, 'bar', true)
    updateTableAndChart(table, chart, false)

  $("#points").click ->
    chart = changeCharType(chart, config, 'line', false);
    updateTableAndChart(table, chart, false)