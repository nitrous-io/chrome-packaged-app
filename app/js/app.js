NIO = Ember.Application.create();

NIO.Box = Ember.Object.extend({
  name: null,
  state: null,

  running: (function() {
    return this.get('state') === 'running'
  }).property('state')

});

NIO.Router.map(function() {
  // put your routes here
});

NIO.IndexRoute = Ember.Route.extend({
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
