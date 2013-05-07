Bonus = require './bonus'

# final bonus with timeout
class TimedBonus extends Bonus

	value: 0
	multiplier: 0

	constructor: (time, @value = 0, @multiplier = 0) ->
		super @value, @multiplier
		setTimeout @remove, time

	remove: =>
		@parent.removeFinalBonus @

module.exports = TimedBonus