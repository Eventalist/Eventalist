// EVENT MODEL----------------------------

var EventModel = Backbone.Model.extend({

	initialize: function(){

	},

	defaults: {
		date: '10-10-2014',
		title: 'Party',
		category_id: 1,
		address: 'NYC',
		price: '$0',
		link: 'http://www.gooogle.com',
		description: 'party party',
		venue: "",
		venure_website: "",
		latitude: "440.7127",
		longitude: "74.0059",
	}

});


// EVENT COLLECTION------------------------

var EventCollection = Backbone.Collection.extend({
	url: '/events',
	model: EventModel
})

var eventsCollection = new EventCollection()



// EVENT LIST VIEW-------------------------

var EventView = Backbone.View.extend({

	tag: 'div',

	attributes: {
		class: "listItem col-md-12"
	},

	template: _.template( $('#template-event-list').html() ),

	events: {
		"click button.moreInfo": "modalView"
	},

	modalView: function(){

		var eventModalView = new ModalView({ model: this.model })

	},

	initialize: function(){

		this.render()

	},

	render: function(){
		this.$el.html( this.template(this.model.attributes) );
	}

})



//ALL EVENTS LIST VIEW-------------------------

var EventsListView = Backbone.View.extend({

	initialize: function(){

		this.listenTo(this.collection, 'all', this.render)
		this.collection.fetch()

	},

	render: function(){

		var self = this
		this.$el.empty()

		_.each(this.collection.models, function(eachEvent){

			if(eachEvent.attributes.category_id == self.attributes.category_id){

				var eventView = new EventView({model: eachEvent})
				eventView.render();
				self.$el.append( eventView.el )

			}else if (self.attributes.category_id == 0) {
				var eventView = new EventView({model: eachEvent})
				eventView.render();
				self.$el.append( eventView.el );
			}

		})
	}

})


// var musicEventsView = new EventsListView({collection: eventsCollection, el: $('ul.music'), attributes: {category_id: 1}})

// var artEventsView = new EventsListView({collection: eventsCollection, el: $('ul.art'), attributes: {category_id: 2}})

// var theaterEventsView = new EventsListView({collection: eventsCollection, el: $('ul.theater'), attributes: {category_id: 3}})


// EVENT MODAL VIEW-------------------------

var ModalView = Backbone.View.extend({

	template: _.template( $('#template-event-modal').html() ),

	initialize: function(){
		this.render()
	},

	render: function(){

		this.$el.html( this.template(this.model.attributes) )
		$('div#modalEventView').html(this.$el)
	},

})


// Subscription ------------------------

$("button#subscribeUser").on("click", function(){

	var name = $("input.name").val();
	var email = $("input.email").val();


	$.post("http://127.0.0.1:9292/users", {name: name, email: email}, function(user){

		if ($("input.art").prop("checked") == true){
			$.post("http://127.0.0.1:9292/subscriptions", {user_id: user.id, category_id: 1})
		};
		if ($("input.music").prop("checked") == true){
			$.post("http://127.0.0.1:9292/subscriptions", {user_id: user.id,name: name, email: email, category_id: 2})
		};
		if ($("input.theater").prop("checked") == true){
			$.post("http://127.0.0.1:9292/subscriptions", {user_id: user.id,name: name, email: email, category_id: 3})
		};

		$("input.name").val("");
		$("input.email").val("");
		$("input.art").prop("checked", false);
		$("input.music").prop("checked", false);
		$("input.theater").prop("checked", false);

		var sendEmail = function(){
			$.get('http://127.0.0.1:9292/users/' + user.id + '/subscriptions')
		}
		setTimeout(sendEmail, 2000);
	})
})

$('ul.nav').on('click', function(event){
	$('.active').toggleClass('active')
	$(event.target).parent().toggleClass('active');
})

var AppRouter = Backbone.Router.extend({
routes: {
	"": "index",
	"art": "art",
	"theater": "theater",
	"music": "music",
	"free": "free",
	"nightlife": "nightlife"

	},
})



var router = new AppRouter();

router.on("route:index", function(){
	var allEventsView = new EventsListView({collection: eventsCollection, el: $('ul.events'), attributes: {category_id: 0}})

})

router.on("route:art", function(){

	var artEventsView = new EventsListView({collection: eventsCollection, el: $('ul.events'), attributes: {category_id: 2}})

})

router.on("route:theater", function(){

	var theaterEventsView = new EventsListView({collection: eventsCollection, el: $('ul.events'), attributes: {category_id: 3}})

})

router.on("route:music", function(){

	var musicEventsView = new EventsListView({collection: eventsCollection, el: $('ul.events'), attributes: {category_id: 1}})

})

router.on("route:free", function() {

	var freeEventsView = new EventsListView({collection: eventsCollection, el: $('ul.events'),
		attributes: {category_id: 4}})
})

router.on("route:nightlife", function() {

	var nightlifeEventsView = new EventsListView({collection: eventsCollection, el: $('ul.events'),
		attributes: {category_id: 5}})
})

Backbone.history.start()




