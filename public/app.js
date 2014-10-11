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
	
	tag: 'li',

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



// ALL EVENTS LIST VIEW-------------------------

// var EventsView = Backbone.View.extend({

// 	initialize: function(){
// 		this.listenTo(this.collection, 'all', this.render)
// 		this.collection.fetch()
	
// 	},

// 	render: function(){

// 		var self = this
		
// 		_.each(this.collection.models, function(event){

// 			var eventView = new EventView({model: event})
// 			eventView.render();
// 			self.$el.append( eventView.el )

// 		})

// 	}

// })


// var allEventsList = new EventsView({collection: eventsCollection, el: $('ul.events')})

var PaginatedEventView = Backbone.View.extend({

	initialize: function(){
		console.log('new paginated view initialized')
		this.listenTo(this.collection, 'all', this.paginate(10, 1))
		this.collection.fetch()
	},

	 paginate : function(perPage, page) {
       page = page-1;
       var collection = this;
       collection = _(collection.rest(perPage*page));
       collection = _(collection.first(perPage));    
       return collection.map( function(model) { return model.toJSON() } ); 
    },

	// render: function(){
		
	// 	for(var i = 0, i < 10; i++){
			


	// 		_.each(this.collection.models, function(event){
	// 			var eventView = new EventView({model: event})
	// 			eventView.render()
	// 			self.$el.append( eventView.el )

	// 		})
	// 	}

	// },

})



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

		$.get('http://127.0.0.1:9292/users/:' + user.id + '/subscriptions')

	})


})








