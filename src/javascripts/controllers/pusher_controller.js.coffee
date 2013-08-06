NIO.PusherController = Ember.Controller.extend
  pusher: null
  channel: null
  channelName: (->
    if currentUserId = NIO.get 'currentUser.id'
      "private-user-#{currentUserId}"
  ).property 'NIO.currentUser.id'

  initialize: (pusherKey, pusherEndpoint) ->
    # For now log all messages
    Pusher.log = (message) -> console.log message

    NIO.TokenFetcher.getToken true, (error, access_token) =>
      unless error
        @set 'pusher', pusher = new Pusher pusherKey,
                                encrypted: true,
                                authEndpoint: pusherEndpoint,
                                auth:
                                  headers:
                                    Authorization: "Bearer #{access_token}"

        @set 'channel', channel = pusher.subscribe @get('channelName')

        channel.bind 'aio:box_updated', (json) ->
          if json.box.id
            # TODO: Rather than refreshing all boxes,
            # Update only the one that was modified.
            NIO.Box.fetch(true)
