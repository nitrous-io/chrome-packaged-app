var nio = (function() {

  var signin_button;
  var boxes_container;

  var tokenFetcher = (function() {
    // Replace clientId and clientSecret with values obtained by you for your
    // application https://github.com/settings/applications.
    var clientId = '2aa25d507f263f954c331c57d04f3e147e39fdaf9c6c4e146d496e99b51ddfd6';
    var clientSecret = 'ac187c7e14fbd91943ba1350c62ec2cd85730ada36614a9f24fa831fc2de0b38';
    var redirectUri = 'https://' + chrome.runtime.id +
                      '.chromiumapp.org/nitrous';
    var redirectRe = new RegExp(redirectUri + '[#\?](.*)');

    var access_token = null;

    return {
      getToken: function(interactive, callback) {
        // In case we already have an access_token cached, simply return it.
        if (access_token) {
          callback(null, access_token);
          return;
        }

        var options = {
          'interactive': interactive,
          url:'https://www.n2odev.com:5000/oauth/authorize?client_id=' + clientId +
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
                   'https://www.n2odev.com:5000/oauth/token'
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
      }
    }
  })();

  function xhrWithAuth(method, url, interactive, callback) {
    var retry = true;
    var access_token;

    console.log('xhrWithAuth', method, url, interactive);
    getToken();

    function getToken() {
      tokenFetcher.getToken(interactive, function(error, token) {
        console.log('token fetch', error, token);
        if (error) {
          callback(error);
          return;
        }

        access_token = token;
        requestStart();
      });
    }

    function requestStart() {
      var xhr = new XMLHttpRequest();
      xhr.open(method, url);
      xhr.setRequestHeader('Authorization', 'Bearer ' + access_token);
      xhr.onload = requestComplete;
      xhr.send();
    }

    function requestComplete() {
      console.log('requestComplete', this.status, this.response);
      if (this.status != 200 && retry) {
        retry = false;
        tokenFetcher.removeCachedToken(access_token);
        access_token = null;
        getToken();
      } else {
        callback(null, this.status, this.response);
      }
    }
  }

  function xhrWithAuth(method, url, interactive, callback) {
    var retry = true;
    var access_token;

    console.log('xhrWithAuth', method, url, interactive);
    getToken();

    function getToken() {
      tokenFetcher.getToken(interactive, function(error, token) {
        console.log('token fetch', error, token);
        if (error) {
          callback(error);
          return;
        }

        access_token = token;
        requestStart();
      });
    }

    function requestStart() {
      var xhr = new XMLHttpRequest();
      xhr.open(method, url);
      xhr.setRequestHeader('Authorization', 'Bearer ' + access_token);
      xhr.onload = requestComplete;
      xhr.send();
    }

    function requestComplete() {
      console.log('requestComplete', this.status, this.response);
      if (this.status != 200 && retry) {
        retry = false;
        tokenFetcher.removeCachedToken(access_token);
        access_token = null;
        getToken();
      } else {
        callback(null, this.status, this.response);
      }
    }
  }

  function fetchBoxesRemotely() {
    xhrWithAuth('GET',
                'https://www.n2odev.com:5000/api/v0/boxes',
                true,
                onBoxesFetched);
  }

  function fetchBoxes() {
    chrome.storage.local.get('boxes', function(result) {
      if (result && ('boxes' in result)) {
        return renderBoxesList(result.boxes);
      } else {
        return fetchBoxesRemotely();
      }
    });
  }

  function launchWebIde(boxId) {
    var onUserSignInToken = function(error, status, response) {
      if (!error && status == 200) {
        var token = encodeURIComponent(JSON.parse(response)['sign_in_token']);
        var redirectUrl = encodeURIComponent('https://www.n2odev.com:5000/app#boxes/' + boxId + '/ide');
        var webview = document.querySelector('webview');

        webview.setAttribute('src', 'https://www.n2odev.com:5000/users/sign_in_with_token?sign_in_token=' + token + '&redirect_to=' + redirectUrl);
        webview.style.display = 'block';
      } else {
        console.log('Fetching user sign in token failed', error, status);
      }
    }

    xhrWithAuth('GET',
            'https://www.n2odev.com:5000/api/v0/user/sign_in_token',
            true,
            onUserSignInToken);
  }

  // Functions updating the User Interface:

  function showButton(button) {
    button.style.display = 'inline';
    button.disabled = false;
  }

  function hideButton(button) {
    if (button) {
      button.style.display = 'none';
    }
  }

  function disableButton(button) {
    if (button) {
      button.disabled = true;
    }
  }

  function renderBoxesList(boxes) {
    boxes.forEach(function(box) {
      var boxEl = document.createElement('div');
      boxEl.id = box.id;
      boxEl.innerHTML = '<span>' + box.name + '</span> - <span>' + box.state + '</span>';

      if (box.state === 'running') {
        boxEl.innerHTML += ' <a class="launch_web_ide_btn" href="#">(Launch Web IDE)</a>';
      }

      boxes_container.appendChild(boxEl);
    });

    boxes_container.style.display = 'block';
    hideButton(signin_button);
  }

  function onBoxesFetched(error, status, response) {
    if (!error && status == 200) {
      var boxes = JSON.parse(response)['boxes'];
      chrome.storage.local.set({
        'boxes': boxes
      }, function() {
        renderBoxesList(boxes);
      });
    } else {
      console.log('Fetching boxes failed', error, status);
      showButton(signin_button);
    }
  }


  // Handlers for the buttons's onclick events.

  function signInAndShowBoxes() {
    tokenFetcher.getToken(true, function(error, access_token) {
      if (error) {
        signin_button = document.querySelector('#signin_btn');
        showButton(signin_button);
      } else {
        fetchBoxes();
      }
    });
  }

  function handleLaunchWebIdeEvents() {
    document.addEventListener('click', function(event) {
      var target = event.target;
      if (target.className == 'launch_web_ide_btn') {
        var boxId = target.parentNode.id;
        return launchWebIde(boxId);
      } else {
        return;
      }
    }, true)
  }

  return {
    onload: function () {
      boxes_container = document.querySelector('#boxes');

      signInAndShowBoxes();
      handleLaunchWebIdeEvents();
    }
  };
})();

window.onload = nio.onload;
