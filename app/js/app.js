NIO = Ember.Application.create();
NIO.reopen({
  host: 'https://www.n2odev.com:5000'
})

NIO.IndexRoute = Ember.Route.extend({
  activate: function() {
    if (NIO.TokenFetcher.hasToken()) {
      this.transitionTo('main');
    }
  }
});

NIO.MainRoute = Ember.Route.extend({
  beforeModel: function() {
    // return a promise
    return NIO.Box.fetch()
  },

  model: function() {
    return NIO.Box.findAll()
  }
});
