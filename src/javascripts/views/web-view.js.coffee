AIO.WebView = Em.View.extend
  tagName: 'webview'
  attributeBindings: ['src']

  src: (->
    @get 'controller.webViewURL'
  ).property 'controller.webViewURL'

  didInsertElement: ->
    $webview = @$()

    $webview.on 'loadstop.main-view', (e) =>
      if contentWindow = e.target.contentWindow
        contentWindow.postMessage 'chromeWebView', AIO.get('host')

    $webview.on 'newwindow.main-view', (e) ->
      window.open e.originalEvent.targetUrl

    $webview[0].request.onBeforeRequest.addListener(
      (details) =>
        @get('controller').signOut()
        return { cancel: true }
      { urls: ["*://*/users/sign_out"] },
      ["blocking"])

  willDestroyElement: ->
    @_super()
    $webview = @$()
    $webview.off 'loadstart.main-view'
    $webview.off 'loadstop.main-view'
    $webview.off 'newwindow.main-view'
