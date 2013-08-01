NIO = Ember.Application.create();
NIO.reopen({
  host: 'https://www.n2odev.com:5000'
})

NIO.IndexRoute = Ember.Route.extend({
  activate: function() {
    if (NIO.TokenFetcher.hasToken()) {
      this.transitionToRoute('main');
    }
  }
});

NIO.MainRoute = Ember.Route.extend({
  beforeModel: function() {
    // returns a promise
    return NIO.Box.fetch()
  },

  model: function() {
    return NIO.Box.findAll()
  },

  events: {
    'selectBox': function(id) {
      box = NIO.Box.find(id);
      //.set('content', box);
    }
  }
});
