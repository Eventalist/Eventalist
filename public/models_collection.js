var EventModel = Backbone.Model.extend({
	urlRoot: '/events'
});

var EventCollection = Backbone.Collection.extend({
	url: '/events',
	model: EventModel
})

collection = new EventCollection();