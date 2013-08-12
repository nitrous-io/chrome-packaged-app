AIO.MainView = Em.View.extend
  sidebarVisible: true

  toggleSidebar: ->
    if sidebarVisible = @toggleProperty('sidebarVisible')
      $('#app').css 'padding-left', 320
      $('#app-sidebar').css 'left', 0
    else
      $('#app').css 'padding-left', 0
      $('#app-sidebar').css 'left', -320
