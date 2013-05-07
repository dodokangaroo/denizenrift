class Entity

	@UID: 0

	id: null
	components: null

	constructor: ->
		@id = Entity.UID++
		@components = []

	add: (c) ->
		c.parent = this
		components[c.id] = c
		c.added()
		for id, c2 of components
			c2.siblingAdded c

	remove: (c) ->
		c.removed()
		delete components[c.id]
		for id, c2 of components
			c2.siblingRemoved c

	has: (id) ->
		components[id]?

	get: (id) ->
		components[id]

	update: ->
		for id, c of components
			c.update()

module.exports = Entity