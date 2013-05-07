Attribute = require './attribute'

class DependantAttribute extends Attribute

	dependants: null
	dependantEffects: null
	x: 0

	constructor: (@baseValue = 0, @baseMultiplier = 0) ->

		@dependants = []
		@dependantEffects = []

		super @baseValue, @baseMultiplier

	addDependant: (d, percent) ->
		@dependants.push d
		@dependantEffects.push percent
		@calculate()

	removeDependant: (d) ->
		i = @dependants.indexOf d
		@dependants.splice i, 1 if i >= 0
		@dependantEffects.splice i, 1 if i >= 0
		@calculate()

	# use this to modify baseValue, eg. attr gets +20% of another attr
	getModifiers: ->
		total = 0

		for i, d of @dependants
			p = @dependantEffects[i]
			total += d.value * p

		return total



module.exports = DependantAttribute