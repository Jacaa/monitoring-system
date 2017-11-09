$(document).on 'turbolinks:load', ->

  # Change cookies info
  $('.cookies-eu-content-holder').text('This website uses cookies. By continuing to use this site you agree to the use of cookies.')

  # DataTables
  $('#events').DataTable(
    order: [2, 'desc'],
    iDisplayLength: 20,
    columnDefs: [ {
      targets: [0, 1, 3]
      orderable: false
    } ]
  )