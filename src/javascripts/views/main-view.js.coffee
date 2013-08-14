AIO.MainView = Em.View.extend
  elementId: 'aio-main-view'
  sidebarVisible: true

  didInsertElement: ->
    @_super()
    @$('webview').on 'loadstop.main-view', (e) ->
      if contentWindow = e.target.contentWindow
        contentWindow.postMessage 'chromeWebView', AIO.get('host')

  willDestroyElement: ->
    @_super()
    @$('webview').off 'loadstop.main-view'

  toggleSidebar: ->
    if sidebarVisible = @toggleProperty('sidebarVisible')
      @$().css 'padding-left', 320
      @$('#app-sidebar').css 'left', 0
    else
      @$().css 'padding-left', 0
      @$('#app-sidebar').css 'left', -320
