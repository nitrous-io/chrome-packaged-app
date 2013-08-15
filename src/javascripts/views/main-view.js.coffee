AIO.MainView = Em.View.extend
  elementId: 'aio-main-view'
  sidebarVisible: true
  loading: false
  webviewVisible: false

  didInsertElement: ->
    @_super()
    Em.run.next =>
      @set 'webviewVisible', true
      Em.run.next =>
        $webview = @$('webview')

        $webview.on 'loadstart.main-view', (e) =>
          @set 'loading', true

        $webview.on 'loadstop.main-view', (e) =>
          @set 'loading', false
          if contentWindow = e.target.contentWindow
            contentWindow.postMessage 'chromeWebView', AIO.get('host')

        $webview.on 'newwindow.main-view', (e) ->
          window.open e.originalEvent.targetUrl

  willDestroyElement: ->
    @_super()
    $webview = @$('webview')
    $webview.off 'loadstart.main-view'
    $webview.off 'loadstop.main-view'
    $webview.off 'newwindow.main-view'
    @set 'webviewVisible', false

  toggleSidebar: ->
    if sidebarVisible = @toggleProperty('sidebarVisible')
      @$().css 'padding-left', 320
      @$('#app-sidebar').css 'left', 0
    else
      @$().css 'padding-left', 0
      @$('#app-sidebar').css 'left', -320
