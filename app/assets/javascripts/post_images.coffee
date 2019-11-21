window.addEventListener("load",->
  el = document.getElementById('images')
  if el != null
    sortable = Sortable.create(el)
 ,false)