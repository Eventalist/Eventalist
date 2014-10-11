// EVENT MODEL----------------------------

var EventModel = Backbone.Model.extend({

	initialize: function(){
		// console.log('event model initialized')
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

	tag: 'li',

	template: _.template( $('#template-event-list').html() ),

	events: {
		"click button.moreInfo": "modalView"
	},

	modalView: function(){

		var eventModalView = new ModalView({ model: this.model })

	},

	initialize: function(){
		// console.log('new event view initialized')
		this.render()
	},

	render: function(){
		this.$el.html( this.template(this.model.attributes) );
	}

})



// ALL EVENTS LIST VIEW-------------------------

var EventsView = Backbone.View.extend({

	initialize: function(){

		// console.log('all events list initialized')
		this.listenTo(this.collection, 'all', this.render)
		this.collection.fetch()

	},

	render: function(){

		var self = this

		_.each(this.collection.models, function(event){

			var eventView = new EventView({model: event})
			eventView.render();
			self.$el.append( eventView.el )

			// console.log(eventView)

		})

	}

})


var allEventsList = new EventsView({collection: eventsCollection, el: $('ul.events')})



// EVENT MODAL VIEW-------------------------

var ModalView = Backbone.View.extend({

	template: _.template( $('#template-event-modal').html() ),

	initialize: function(){
		console.log('new modal view initialized')
		this.render()
	},

	render: function(){

		this.$el.html( this.template(this.model.attributes) )
		$('div.modal-content').html(this.$el)
	},

})


// SUBSCRIPTION VIEW-----------------------

// var SubscriptionView = Backbone.View.extend({

// 	initilize: function(){
// 		console.log("sub view initilized")

// 	},
// 	events: {
// 		"click button.subscribe": "subscribe"

// 	},

// 	subscribe: function(){
// 		console.log("button pushed")

// 	}
// })


$("button#subscribeUser").on("click", function(){
	console.log("butotn clicked")
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

	})
	$("input.name").val("");
	$("input.email").val("");
	$("input.art").prop("checked", false);
	$("input.music").prop("checked", false);
	$("input.theater").prop("checked", false);

})








