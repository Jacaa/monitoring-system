$(document).on 'turbolinks:load', ->

  # Change cookies info
  $('.cookies-eu-content-holder').text('This website uses cookies. By continuing to use this site you agree to the use of cookies.')

  # Create DataTable
  table = $('#events').DataTable(
    order: [2, 'desc'],
    iDisplayLength: 10,
    columnDefs: [ {
      targets: [0, 1, 3]
      orderable: false
    } ]
  )

  # Date filter

  # FILTER - select range
  # Get the earliest date from table events
  earliestDate = table.column(2).data().sort()[0]
  # Create datepicker
  $('#start-date').datepicker
    dateFormat: "dd M yy"
    changeMonth: true
    changeYear: true
    onSelect: ->
      # ALERT - Start date can't be later than end day
      startDate = $('#start-date').datepicker('getDate')
      endDate = $('#end-date').datepicker('getDate')
      if startDate > endDate
        alert "Incorrect range - start date can't be later than end day"
        $('#start-date').datepicker('setDate', earliestDate)
      else
        table.draw()
  # Set the earliest date from datetable as start day
  $('#start-date').datepicker('setDate', earliestDate)

  # Get today date
  todayDate = new Date()
  # Create datepicker
  $('#end-date').datepicker
    dateFormat: "dd M yy"
    changeMonth: true
    changeYear: true
    onSelect: ->
      # ALERT - End date can't be earlier than start day
      startDate = $('#start-date').datepicker('getDate')
      endDate = $('#end-date').datepicker('getDate')
      if endDate < startDate
        alert "Incorrect range - end date can't be earlier than start day"
        $('#end-date').datepicker('setDate', todayDate)
      else
        table.draw()
  # Set today date end day
  $('#end-date').datepicker('setDate', todayDate)

  # Reset date range
  $('#reset-date-range-btn').click ->
    $('#start-date').datepicker('setDate', earliestDate)
    $('#end-date').datepicker('setDate', todayDate)
    table.draw()

# FILTER - predefined

  today = new Date()

  yesterdayDate = today.setTime(today.getTime() - (24 * 60 * 60 * 1000))
  yesterdayDate = new Date(yesterdayDate)

  last7Days = today.setTime(today.getTime() - (6 * 24 * 60 * 60 * 1000))
  last7Days = new Date(last7Days)

  last30Days = today.setTime(today.getTime() - (23 * 24 * 60 * 60 * 1000))
  last30Days = new Date(last30Days)

  $('#today-filter').click ->
    $('#start-date').datepicker('setDate', todayDate)
    $('#end-date').datepicker('setDate', todayDate)
    table.draw()

  $('#yesterday-filter').click ->
    $('#start-date').datepicker('setDate', yesterdayDate)
    $('#end-date').datepicker('setDate', yesterdayDate)
    table.draw()

  $('#last-7-days-filter').click ->
    $('#start-date').datepicker('setDate', last7Days)
    $('#end-date').datepicker('setDate', todayDate)
    table.draw()

  $('#last-30-days-filter').click ->
    $('#start-date').datepicker('setDate', last30Days)
    $('#end-date').datepicker('setDate', todayDate)
    table.draw()

  $('#all-filter').click ->
    $('#start-date').datepicker('setDate', earliestDate)
    $('#end-date').datepicker('setDate', todayDate)
    table.draw()
    
  # Detect changes in direction and photo filters
  $('select').on('change', ->
    table.draw()
  )

  # Create new table depends on filters
  $.fn.dataTable.ext.search.push (settings, data, dataIndex) ->
    # Values from filters
    startDate = $('#start-date').datepicker('getDate')
    endDate = $('#end-date').datepicker('getDate')
    filterDirection = $('#direction').val()
    filterPhoto = $('#photo').val()
    # Data from table
    if endDate != null
      endDate.setHours(endDate.getHours()+24)
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

  # Event listener to the two range filtering inputs to redraw on input
  $('#start-day, #end-day').change ->
    table.draw()
