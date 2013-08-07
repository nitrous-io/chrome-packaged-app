NIO.Session = Ember.Object.extend
  access_token    : null
  scope           : null
  token_type      : null
  expires_in      : null
  refresh_token   : null

NIO.Session.reopenClass
  create: (attrs, callback) ->
    this._super(attrs)
    
    chrome.storage.local.set { 'session': attrs }, ->
      callback()
    
  getCurrent: (callback) ->
    chrome.storage.local.get 'session', (result) =>
      if result && ('session' of result)
        callback null, Ember.Object.create(result['session'])
      else
        callback 'session not available'

  getToken: (callback) ->
    NIO.Session.getCurrent (error, session) =>
      if error
        return callback(error)

      if access_token = session.get('access_token')
        callback null, access_token
      else
        callback 'access token not available'

  clear: () ->
    chrome.storage.local.remove 'session'
