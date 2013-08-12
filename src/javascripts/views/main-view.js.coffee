AIO.MainView = Em.View.extend
  elementId: 'aio-main-view'
  sidebarVisible: true

  toggleSidebar: ->
    if sidebarVisible = @toggleProperty('sidebarVisible')
      @$().css 'padding-left', 320
      @$('#app-sidebar').css 'left', 0
    else
      @$().css 'padding-left', 0
      @$('#app-sidebar').css 'left', -320
