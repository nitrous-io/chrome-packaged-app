originalWindowAddEventListener = window.addEventListener

window.addEventListener = (type) ->
  return if type == 'unload' || type == 'beforeunload'
  originalWindowAddEventListener.apply window, arguments
