// EVENT MODEL----------------------------

var EventModel = Backbone.Model.extend({
	
	initialize: function(){
		console.log('event model initialized')
	},

	defaults: {
		date: '10-10-2014',
		title: 'Party',
		category_id: 1,
		address: 'NYC',
		price: '$0',
		link: 'http://www.gooogle.com',
		description: 'party party'
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
		console.log('new event view initialized')
		this.render()
	},

	render: function(){
		this.$el.html( this.template(this.model.attributes) );
	}

})



// ALL EVENTS LIST VIEW-------------------------

var EventsView = Backbone.View.extend({

	initialize: function(){

		console.log('all events list initialized')
		this.listenTo(this.collection, 'all', this.render)
		this.collection.fetch()
	
	},

	render: function(){

		var self = this
		
		_.each(this.collection.models, function(event){

			var eventView = new EventView({model: event})
			eventView.render();
			self.$el.append( eventView.el )

			console.log(eventView)

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

var SubscriptionView = Backbone.View.extend({
	events: function(){

	}

})









