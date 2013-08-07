AIO.Utils =
  makeRequest: (type, endpoint) -> 
    host = AIO.get 'host'
    deferred = jQuery.Deferred()

    AIO.Session.getToken (error, access_token) =>
      if error
        console.log 'access token not available'
        deferred.reject (errror)

      deferred = jQuery.ajax
        url: "#{host}/api/v0/#{endpoint}"
        type: type,
        headers: { 'Authorization': "Bearer #{access_token}" }
    
    deferred

  openInWebView: (path, width, height) ->
    host = AIO.get 'host'

    this.makeRequest('GET', '/user/sign_in_token')
    .done (data) =>
      token = encodeURIComponent data.sign_in_token
      redirectUrl = encodeURIComponent "#{host}/#{path}"

      chrome.app.window.create 'webviewer.html', {
        bounds: {
          width: width
          height: height
        }
      },
      (webviewer) ->
        webviewer.contentWindow.webview_src = "#{host}/users/sign_in_with_token?sign_in_token=#{token}&redirect_to=#{redirectUrl}"
