// EVENT LIST VIEW

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


