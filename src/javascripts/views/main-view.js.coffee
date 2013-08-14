AIO.MainView = Em.View.extend
  elementId: 'aio-main-view'
  sidebarVisible: true

  didInsertElement: ->
    @_super()
    $webview = @$('webview')
    $webview.on 'loadstop.main-view', (e) ->
      if contentWindow = e.target.contentWindow
        contentWindow.postMessage 'chromeWebView', AIO.get('host')
    $webview.on 'newwindow.main-view', (e) ->
      window.open e.originalEvent.targetUrl

  willDestroyElement: ->
    @_super()
    $webview = @$('webview')
    $webview.off 'loadstop.main-view'
    $webview.off 'newwindow.main-view'

  toggleSidebar: ->
    if sidebarVisible = @toggleProperty('sidebarVisible')
      @$().css 'padding-left', 320
      @$('#app-sidebar').css 'left', 0
    else
      @$().css 'padding-left', 0
      @$('#app-sidebar').css 'left', -320
