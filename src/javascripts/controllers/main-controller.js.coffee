AIO.MainController = Em.Controller.extend
  webViewURL: 'about:blank'
  webViewSignedIn: false

  signOut: ->
    AIO.CurrentUser.reset()
    AIO.AccessToken.reset()
    AIO.SignInToken.reset()
    AIO.set 'currentUser', null
    AIO.set 'accessToken', null
    $('#aio-main-view webview').off 'loadstop.main-controller'
    @set 'webViewSignedIn', false
    @set 'webViewURL', 'about:blank'
    @send 'signedOut'
