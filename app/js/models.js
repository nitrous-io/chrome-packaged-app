NIO.Box = Ember.Object.extend({
  id                    : null,

  backend_available     : null,
  box_server_uri        : null,
  box_template_id       : null,
  container_name        : null,
  host                  : null,
  memory                : null,
  owner_id              : null,
  port                  : null,
  region_id             : null,
  name                  : null,
  state                 : null,
  storeage              : null,

  running: (function() {
    this.get('state') === 'running'
  }).property('state'),

  stopped: (function() {
    this.get('state') === 'stopped'
  }).property('state')

});

NIO.Box.reopenClass({
  store: [],

  fetchFromRemote: function(deferred) {
    var host = NIO.get('host');

    NIO.TokenFetcher.getToken(false, function(error, access_token) {
      if (error) {
        deferred.reject(error);
      }

      $.ajax({
        url: host + '/api/v0/boxes',
        headers: { 'Authorization': 'Bearer ' + access_token }
      })
      .done(function(data, status) {
        if (status == 200) {
          var boxes = JSON.parse(data)['boxes'];

          // store boxes in local storage
          chrome.storage.local.set({
            'boxes': boxes
          }, function() {
            deffered.resolve(boxes)
          });
        } else {
          console.log('Fetching boxes failed', error, status);
          deferred.reject();
        }
      })
    });
  },

  fetch: function() {
    var store = this.store;
    var deferred = jQuery.Deferred();

    deferred.done(function(boxes) {
      // add them to store
      boxes.forEach(function(box) {
        store.push(NIO.Box.create(box));
      })
    });

    chrome.storage.local.get('boxes', function(result) {
      if (result && ('boxes' in result)) {
        deferred.resolve(result.boxes);
      } else {
        fetchFromRemote(deferred);
      }
    });

    return deferred.promise();
  },

  findAll: function() {
    return this.store
  },

  find: function(id) {
    var box = null;
    this.store.some(function(value) {
      box = value;
      return box.id === id
    });

    return box;
  },

  first: function() {
    return this.store[0]
  }

});
