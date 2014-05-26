AIO.MainView = Em.View.extend
  elementId: 'aio-main-view'

  didSetWebViewURL: (->
    if webViewURL = @get('controller.webViewURL')
      $webview = @$('webview')

      $webview.attr 'src', @get('controller.webViewURL')

      $webview.on 'loadstop.main-view', (e) =>
        if contentWindow = e.target.contentWindow
          contentWindow.postMessage 'chromeWebView', AIO.get('host')

      $webview.on 'newwindow.main-view', (e) ->
        window.open e.originalEvent.targetUrl
  ).observes 'controller.webViewURL'

  willDestroyElement: ->
    @_super()
    $webview = @$('webview')
    $webview.off 'loadstart.main-view'
    $webview.off 'loadstop.main-view'
    $webview.off 'newwindow.main-view'
