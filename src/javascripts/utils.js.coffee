NIO.Utils = {
  openInWebView: (path, width, height) ->
    host = NIO.get 'host'

    NIO.TokenFetcher.getToken true, (error, access_token) =>
      if error
        console.log 'access token not available'
        # force user to login again
        return

      $.ajax
        url: "#{host}/api/v0/user/sign_in_token"
        headers: { 'Authorization': "Bearer #{access_token}" }

      .done (data) ->
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

}

