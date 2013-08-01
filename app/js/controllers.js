NIO.ApplicationController = Ember.Controller.extend({
});

NIO.IndexController = Ember.Controller.extend({
  connecting: null,

  connect: function() {
    var self = this;
    this.set('connecting', true);

    NIO.TokenFetcher.getToken(true, function(error, access_token) {
      self.set('connecting', false);

      if (error) {
        // TODO: show a flash message
        console.log('Login Failed')
      } else {
        self.transitionTo('main');
      }
    });
  }
});

NIO.BoxDetailsController = Ember.ObjectController.extend({
  content: NIO.Box.first()
});
