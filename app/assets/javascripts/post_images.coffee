window.addEventListener("turbolinks:load",->
  el = document.getElementById('images')
  if el != null
    sortable = Sortable.create(el,
    onUpdate: (evt) ->
        $.ajax
          url: 'sort'
          type: 'patch'
          data: { from: evt.oldIndex, to: evt.newIndex }
    )
 ,false)