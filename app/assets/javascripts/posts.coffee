$('#posts-table').DataTable
  processing: true
  serverSide: true
  pagingType: 'full_numbers'
  ajax: $('#posts-table').data('source')

$('input.tokenize').tokenfield
  autocomplete:
    source: (request, response) ->
      $.ajax
        url: '/admin/tags'
        dataType: 'JSON'
        data:
          search_term: request.term
        success: (data) ->
          if data.tags
            response(data.tags.map (item) ->
              item = item.table if item.table
              {
                label: item.name,
                value: item.name
              }
            )
          return
        error: (res) ->
          console.log(res.responseText)
          return
