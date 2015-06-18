var App = window.App != null ? window.App : {};

App.FormView = Backbone.View.extend({
  tagName: 'form', 

  attributes: { 'method':'POST', 'ENCTYPE':'multipart/form-data', 'ACTION':'/observations'},

  initialize: function(options) {
    _.bindAll(this, 
      'render', 
      'renderSubview',
      'initializeSubviews',
      'initializeIdentifierView',
      'initializeLocationView',
      'initializeImageView',
      'initializeTermsconditionsView',
      'initializeSubmitView',
      'updateAnimalIdentifier',
      'updateImage',
      'preparePayload',
      'send',
      'removeSubviews',
      'renderThanks'
    );

    if (options !== undefined) {
      this.geocodingProvider = options.geocodingProvider;
      this.locationProvider = options.locationProvider;
      this.imageProvider = options.imageProvider;
    };

    this.model = new App.Observation();
    this.subviews = [];
    this.initializeSubviews();
  },

  initializeSubviews: function() {
    this.initializeIdentifierView();
    this.initializeLocationView();
    this.initializeImageView();
    this.initializeTermsconditionsView();
    this.initializeSubmitView();
    return this;
  },

  initializeIdentifierView: function() {
    var view = new App.IdentifierView();
    this.listenTo(view, 'didUpdateAnimalIdentifier', this.updateAnimalIdentifier);
    this.subviews.push(view);
  },

  initializeLocationView: function() {
    var view = new App.LocationView({ 
      locationProvider: this.locationProvider,
      geocodingProvider: this.geocodingProvider,
      model: this.model
    });
    this.listenTo(view, 'didUpdateLocation2', this.updateLocation);
    this.subviews.push(view);
  },

  initializeImageView: function() {
    if (this.imageProvider.isAvailable()) {
      var view = new App.ImageView();
      this.listenTo(view, 'didUpdateImage', this.updateImage);
      this.subviews.push(view);
    }
  },

  initializeTermsconditionsView: function() {
    var view = new App.TermsconditionView({ model: this.model });
    this.listenTo(view, 'didUpdateLocation2', this.updateTermscondition);
    this.subviews.push(view);
  },

  initializeSubmitView: function() {
    var view = new App.SubmitView({ model: this.model });
    this.listenTo(view, 'sendForm', this.preparePayload);
    this.subviews.push(view);
  },

  render: function() {
    //this.$el.append("<div class='row'><div class='large-6 columns'><p>Our aim is to assess Sulphur-crested Cockatoos' habitat use and movements around Sydney.<br/>Please report your sightings of tagged cockatoos, even if it’s the same bird on the same day. All reports help to build our understanding of these characters.</p></div></div>");
    this.subviews.forEach(this.renderSubview);
    this.addCsrfToken();
    return this;
  },

  renderSubview: function(subview, index, array) {
    var el = subview.render().el;
    this.$el.append(el);
  },

  addCsrfToken: function() {
     var token = $("meta[name='csrf-token']").attr('content');
     this.$el.append("<input type='hidden' name='authenticity_token' value='" + token + "'>");
  },

  updateAnimalIdentifier: function(newIdentifier) {
    this.model.set('tag', newIdentifier);
  },

  updateAddress: function(address) {
    var addr = address.results[0].formatted_address;
    this.model.set('address', addr);
  },

  updateTermscondition: function(checkbox) {
    var tac = checkbox.results[0].formatted_address;
    this.model.set('termscondition', tac);
  },

  updatePosition: function(geoposition) {
    var lat = geoposition.coords.latitude;
    var lon = geoposition.coords.longitude;

    this.model.set('latitude', lat);
    this.model.set('longitude', lon);
  },

  updateLocation: function(location) {

  },

  updateImage: function(imageEl) {
    this.model.set('image', imageEl);
  },

  preparePayload: function() {
    var form = new FormData(),
        tag = this.model.get('tag'),
        address = this.model.get('address'),
        latitude = this.model.get('latitude'),
        longitude = this.model.get('longitude'),
        image = this.model.get('image'),
        termscondition = this.model.get('termscondition');

    if (tag)            { form.append('tag', tag); }
    if (address)        { form.append('address', address); }
    if (latitude)       { form.append('latitude', latitude); }
    if (longitude)      { form.append('longitude', longitude); }
    if (image)          { form.append('image', image); }
    if (termscondition) { form.append('termscondition', termscondition); }

    form.append('timestamp', new Date().getTime());

    this.send(form);
  },

  removeSubviews: function() {
    this.subviews.forEach(
      function(view) { 
        view.remove(); 
      }
    );
  },

  renderThanks: function(data, modal) {
    this.removeSubviews();    
    this.$el.html(JST['thanks']({name: data.animal.name}));
  },

  send: function(formData) {
    var observation,
        options = {
          url: '/observations',
          type: 'POST',
          data: formData,
          processData: false,
          contentType: false,
        },
        onSuccess = this.renderThanks,
        modal = $('#spinner-modal');

    $('#app-container').fadeTo(333, 0.5);
    $('input[type=submit]').prop('disabled', true);

    var request = $.ajax(options)
      .then(function(response) {
        observation = response;
        return $.get('/animals/' + response.animal_id + '.json');
      }, function(error) {
        console.log(error);
      })
      .always(function() { $('#app-container').fadeTo(333, 1); })
      .then(function(animal) {
        observation.animal = animal;
        onSuccess(observation);
      });
  }
});













