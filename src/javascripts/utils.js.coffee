AIO.Utils =
  makeRequest: (type, endpoint, deferred) ->
    unless AIO.get('online')
      return false

    host = AIO.get 'host'
    deferred ||= jQuery.Deferred()

    AIO.Session.getToken (error, access_token) =>
      if error
        console.log 'access token not available'
        deferred.reject (errror)

      jQuery.ajax({
        url: "#{host}/api/v0/#{endpoint}"
        type: type
        timeout: 20 * 1000  # 20 seconds
        headers: { 'Authorization': "Bearer #{access_token}" }
      })
      .done (data) ->
        deferred.resolve data
      .fail ->
        AIO.set 'requestFailed', true
        AIO.set 'lastRequest', [ type, endpoint, deferred ]

    deferred

  openInWebView: (path, width, height) ->
    host = AIO.get 'host'

    this.makeRequest('GET', 'user/sign_in_token')
    .done (data) =>
      token = encodeURIComponent data.sign_in_token
      redirectUrl = encodeURIComponent "#{host}/#{path}"

      $('webview').attr 'src', "#{host}/users/sign_in_with_token?sign_in_token=#{token}&redirect_to=#{redirectUrl}"

      $('webview').on 'loadstart', ->
        $('webview').css {
          'visibility': 'hidden'
          'z-index': 99
        }
        $('#facade-webview').show()
        $('#facade-webview .loading').removeClass('hide')

      $('webview').on 'loadstop', (event) ->
        this.contentWindow.postMessage 'chromeWebView', host
        $('webview').css {
          'visibility': 'visible'
          'z-index': 101
        }
        $('#facade-webview').hide()
        $('#facade-webview .loading').addClass('hide')

