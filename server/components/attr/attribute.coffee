###
# an attribute which can contain bonus modifiers
# final attributes are applied last so should be used
# for temporary effects etc
### 
class Attribute

	baseValue: 0
	baseMultiplier: 0

	value: 0

	bonuses: null
	finalBonuses: null

	constructor: (@baseValue = 0, @baseMultiplier = 0) ->

		@bonuses = []
		@finalBonuses = []

		@calculate()

	addBonus: (b) ->
		b.parent = @
		@bonuses.push b
		@calculate()

	removeBonus: (b) ->
		i = @bonuses.indexOf b
		@bonuses.splice i, 1 if i >= 0
		@calculate()

	addFinalBonus: (b) ->
		b.parent = @
		@finalBonuses.push b
		@calculate()

	removeFinalBonus: (b) ->
		i = @finalBonuses.indexOf b
		@finalBonuses.splice i, 1 if i >= 0
		@calculate()

	calculate: ->
		@value = @baseValue
		@value += @getModifiers()
		@value *= @baseMultiplier + 1

		@addBonusEffects()
		@addFinalEffects()

	addBonusEffects: ->
		bonusValue = 0
		bonusMultiplier = 1

		# add initial bonuses, items etc
		for bonus in @bonuses
			bonusValue += bonus.value
			bonusMultiplier += bonus.multiplier

		@value += bonusValue
		@value *= bonusMultiplier

	addFinalEffects: ->
		# add final bonuses, ability effects
		finalBonusValue = 0
		finalBonusMultiplier = 1

		for bonus in @finalBonuses
			finalBonusValue += bonus.value
			finalBonusMultiplier += bonus.multiplier

		@value += finalBonusValue
		@value *= finalBonusMultiplier
		@value = Math.floor @value

	# use this to modify baseValue, eg. attr gets +20% of another attr
	getModifiers: ->
		return 0

module.exports = Attribute