class Entity

	@UID: 0

	id: null
	components: null

	constructor: ->
		@id = Entity.UID++
		@components = []

	add: (c) ->
		c.parent = this
		@components[c.cid] = c
		c.added()
		c2.siblingAdded c for id, c2 of @components when c2 isnt c
			

	remove: (c) ->
		c.removed()
		delete @components[c.cid]
		c2.siblingRemoved c for id, c2 of @components when c2 isnt c

	has: (id) ->
		@components[id]?

	get: (id) ->
		@components[id]

	update: ->
		for id, c of @components
			c.update()

module.exports = Entity