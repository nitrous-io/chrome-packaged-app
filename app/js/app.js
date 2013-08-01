NIO = Ember.Application.create();

NIO.IndexRoute = Ember.Route.extend({
  redirect: function() {
    var authenticated = this.controllerFor('application').get('authenticated');
    if (authenticated)
      this.transitionTo('main');
  }
});

NIO.MainRoute = Ember.Route.extend({
  model: function() {
    var boxes = [
      NIO.Box.create({
        name: 'Test Box',
        state: 'running'
      }),
      NIO.Box.create({
        name: 'Test Box 2',
        state: 'terminated'
      }),
    ]
    return boxes;
  }
});
