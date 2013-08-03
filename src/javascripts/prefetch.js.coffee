NIO.Prefetch = (modelClasses=[]) ->
  deferred = jQuery.Deferred()

  flushModelClasses = ->
    if modelClasses.length
      modelClass = modelClasses.shift()
      modelClass.fetch()
      .always ->
        flushModelClasses()
    else
      deferred.resolve()

  flushModelClasses()
  deferred.promise()
