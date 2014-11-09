var App = window.App != null ? window.App : {};

App.TermsconditionView = Backbone.View.extend({
  template: window.JST['location/termscondition'],

  events: {
    'keyup #suburb' : '_setSuburb',
    'keyup #street' : '_setStreet'
  },


  initialize: function(options) {
    _.bindAll(this,
      'render',   
      '_validateOptions',
      '_setTermscondition'
    );

    this._validateOptions(options);
  },


  render: function() {
    $(this.el).html(this.template());
    return this;
  },


  _validateOptions: function(options) {
    if (typeof options === "undefined") { throw new Error("Options must be supplied"); };
    if (typeof options.model === "undefined") { throw new Error("A model object must be supplied"); };

    this.model = options.model;
  },


  _setTermscondition: function() {
    var checkbox = this.model.get('street');
    this.model.set('Termscondition', checkbox);
  }
});