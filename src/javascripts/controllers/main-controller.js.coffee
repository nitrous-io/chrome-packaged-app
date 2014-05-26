AIO.MainController = Em.Controller.extend
  webViewURL: null
  webViewSignedIn: false

  signOut: ->
    AIO.CurrentUser.reset()
    AIO.AccessToken.reset()
    AIO.Box.reset()
    AIO.SignInToken.reset()
    AIO.set 'currentUser', null
    AIO.set 'accessToken', null
    $('#aio-main-view webview').off 'loadstop.main-controller'
    @set 'webViewSignedIn', false
    @set 'webViewURL', 'about:blank'
    @send 'signedOut'
