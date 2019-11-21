window.addEventListener("load",->
  el = document.getElementById('images')
  if el != null
    sortable = Sortable.create(el,
    # onUpdate: (evt) ->
    #   xhr = new XMLHttpRequest();
    #   xhr.open('PATCH', ('sort'));
    #   xhr.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
    #   xhr.send( data: { from: evt.oldIndex, to: evt.newIndex } );
    # )
    onUpdate: (evt) ->
        $.ajax
          url: 'sort'
          type: 'patch'
          data: { from: evt.oldIndex, to: evt.newIndex }
    )
 ,false)
# $ ->
#   el = document.getElementById("images")
#   if el != null
#     sortable = Sortable.create(el,
#       delay: 0,
#       onUpdate: (evt) ->
#         $.ajax
#           url: 'posts/' + $("#post_id").val() + '/sort'
#           type: 'patch'
#           data: { from: evt.oldIndex, to: evt.newIndex }
#     )