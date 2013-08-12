AIO.PusherController = Ember.Controller.extend
  pusher: null
  channel: null
  channelName: (->
    if currentUserId = AIO.get 'currentUser.id'
      "private-user-#{currentUserId}"
  ).property 'AIO.currentUser.id'

  initialize: (pusherKey, pusherEndpoint) ->
    # For now log all messages
    Pusher.log = (message) -> console.log message

    AIO.Session.getToken (error, access_token) =>
      unless error
        @set 'pusher', pusher = new Pusher pusherKey,
                                encrypted: true,
                                authEndpoint: pusherEndpoint,
                                auth:
                                  headers:
                                    Authorization: "Bearer #{access_token}"

        @set 'channel', channel = pusher.subscribe @get('channelName')

        channel.bind 'aio:box_updated', (json) =>
          if json.box.id
            # TODO: Rather than refreshing all boxes,
            # Update only the one that was modified.
            AIO.Box.fetch(true)
            .done =>
              this.controllerFor('main').set 'model', AIO.Box.findAll()

        # TODO: test this instance
        channel.bind 'aio:n2o_updated', (json) ->
          if currentUser = AIO.get('currentUser')
            n2o = json['n2o']
            currentUser.set 'max_n2o', n2o['max']
            currentUser.set 'used_n2o', n2o['used']
