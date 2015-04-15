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
    //var data = {
    //  "observations" : [{
    //    'tag': this.model.get('tag'),
    //    'address': this.model.get('address'),
    //    'latitude': this.model.get('latitude'),
    //    'longitude': this.model.get('longitude'),
    //    'image': "",//this.model.get('image'),
    //    'timestamp': new Date().getTime()
    //  }]
    //};

    var data = new FormData();
    ////data.append('observations', JSON.stringify(observations));
    data.append('tag', this.model.get('tag'));
    data.append('address', this.model.get('address'));
    data.append('latitude', this.model.get('latitude'));
    data.append('longitude', this.model.get('longitude'));
    data.append('image', this.model.get('image'));
    data.append('termscondition', this.model.get('termscondition'));
    data.append('timestamp', new Date().getTime());
    //this.send(data);
    this.send(data);
  },

  removeSubviews: function() {
    this.subviews.forEach(
      function(view) { 
        view.remove(); 
      }
    );
  },

  renderThanks: function(data) {
    $(document).on('opened.fndtn.reveal', '[data-reveal]', function () {
      var modal = $(this);
      modal.foundation('reveal', 'close');
    });

    this.removeSubviews();
    
    var name = data.animal_id;
    
    this.$el.html(JST['thanks']({name: name}));
  },

  send: function(formData) {
    var options = {
          url: '/observations',
          type: 'POST',
          data: formData,
          processData: false,
          contentType: false,
          context: this
        };

    $('#spinner-modal').foundation('reveal', 'open');

    var request = $.ajax(options)
      .then(function(response) {
        this.renderThanks(response);
      }, function(error) {
        console.log(error);
      });
  }
});













