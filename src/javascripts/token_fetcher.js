NIO.TokenFetcher = (function() {
  var host = NIO.get('host');
  var clientId = NIO.get('clientId');
  var clientSecret = NIO.get('clientSecret');
  var redirectUri = 'https://' + chrome.runtime.id +
                    '.chromiumapp.org/nitrous';
  var redirectRe = new RegExp(redirectUri + '[#\?](.*)');

  var access_token = null;

  return {
    hasToken: function() {
      if (access_token) {
        return true;
      }
    },

    getToken: function(interactive, callback) {
      // In case we already have an access_token cached, simply return it.
      if (this.hasToken()) {
        callback(null, access_token);
        return;
      }

      var options = {
        'interactive': interactive,
        url: host+'/oauth/authorize?client_id=' + clientId +
            '&response_type=code' +
            '&scope=public+boxes+push+web+user'+
            '&redirect_uri=' + encodeURIComponent(redirectUri)
      }
      chrome.identity.launchWebAuthFlow(options, function(redirectUri) {
        console.log('launchWebAuthFlow completed', chrome.runtime.lastError,
            redirectUri);

        if (chrome.runtime.lastError) {
          callback(new Error(chrome.runtime.lastError));
          return;
        }

        // Upon success the response is appended to redirectUri, e.g.
        // https://{app_id}.chromiumapp.org/provider_cb#access_token={value}
        //     &refresh_token={value}
        // or:
        // https://{app_id}.chromiumapp.org/provider_cb#code={value}
        var matches = redirectUri.match(redirectRe);
        if (matches && matches.length > 1)
          handleProviderResponse(parseRedirectFragment(matches[1]));
        else
          callback(new Error('Invalid redirect URI'));
      });

      function parseRedirectFragment(fragment) {
        var pairs = fragment.split(/&/);
        var values = {};

        pairs.forEach(function(pair) {
          var nameval = pair.split(/=/);
          values[nameval[0]] = nameval[1];
        });

        return values;
      }

      function handleProviderResponse(values) {
        console.log('providerResponse', values);
        if (values.hasOwnProperty('access_token'))
          setAccessToken(values.access_token);
        // If response does not have an access_token, it might have the code,
        // which can be used in exchange for token.
        else if (values.hasOwnProperty('code'))
          exchangeCodeForToken(values.code);
        else
          callback(new Error('Neither access_token nor code avialable.'));
      }

      function exchangeCodeForToken(code) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST',
                 host + '/oauth/token'
                 );
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.onload = function () {
          // When exchanging code for token, the response comes as json, which
          // can be easily parsed to an object.
          if (this.status === 200) {
            var response = JSON.parse(this.responseText);
            console.log(response);
            if (response.hasOwnProperty('access_token')) {
              setAccessToken(response.access_token);
            } else {
              callback(new Error('Cannot obtain access_token from code.'));
            }
          } else {
            console.log('code exchange status:', this.status);
            callback(new Error('Code exchange failed'));
          }
        };
        xhr.send('client_id=' + clientId +
                 '&client_secret=' + clientSecret +
                 '&redirect_uri=' + redirectUri +
                 '&code=' + code +
                 '&grant_type=authorization_code'
                );
      }

      function setAccessToken(token) {
        access_token = token;
        console.log('Setting access_token: ', access_token);
        callback(null, access_token);
      }
    },

    removeCachedToken: function(token_to_remove) {
      if (access_token == token_to_remove)
        access_token = null;
    },

    removeToken: function() {
      access_token = null;
    }
  }
})();
