// EVENT MODEL----------------------------

var EventModel = Backbone.Model.extend({
	
	initialize: function(){
		console.log('event model initialized')
	},

	defaults: {
		date: '10-10-2014',
		title: 'Party'
	}	

});

// EVENT COLLECTION------------------------

var EventCollection = Backbone.Collection.extend({
	url: '/events',
	model: EventModel
})


// EVENT LIST VIEW-------------------------

var EventView = Backbone.View.extend({
	
	tag: 'li',

	template: _.template( $('#template-event-list').html() ),

	initialize: function(){
		console.log('new event view initialized')
		this.render()
	},

	render: function(){
		this.$el.html( this.template(this.model.attributes) );
	}

})

//
