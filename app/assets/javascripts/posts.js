(function() {
  $('#posts-table').DataTable({
    processing: true,
    serverSide: true,
    pagingType: 'full_numbers',
    ajax: $('#posts-table').data('source')
  });

  $('input.tokenize').tokenfield({
    autocomplete: {
      source: function(request, response) {
        return $.ajax({
          url: '/admin/tags',
          dataType: 'JSON',
          data: {
            search_term: request.term
          },
          success: function(data) {
            if (data.tags) {
              response(data.tags.map(function(item) {
                if (item.table) {
                  item = item.table;
                }
                return {
                  label: item.name,
                  value: item.name
                };
              }));
            }
          },
          error: function(res) {
            console.log(res.responseText);
          }
        });
      }
    }
  });

}).call(this);
