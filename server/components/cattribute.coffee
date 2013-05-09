Component = require '../ef/component'
Attribute = require './attr/attribute'
DependantAttribute = require './attr/dependantattribute'

# a collection of attributes for a hero, item, etc
class CAttribute extends Component

	id: 'attribute'
	attributes: null

	constructor: ->
		@attributes = {}

	add: (name, a) ->
		@attributes[name] = a

	get: (name) ->
		@attributes[name]

	remove: (name) ->
		delete @attributes[name]

	has: (name) ->
		@attributes[name]?

	dump: ->
		console.log "Attributes"
		console.log "----------"
		for name, a of @attributes
			console.log "#{name}: #{a.value}"

CAttribute.Factory = 

	createHeroAttributes: ->

		c = new CAttribute

		c.add 'hp', new DependantAttribute 100
		c.add 'mp', new DependantAttribute 100

		c.add 'str', new Attribute 10
		c.add 'agi', new Attribute 10
		c.add 'vit', new Attribute 10
		c.add 'int', new Attribute 10

		c.add 'ad', new DependantAttribute 0
		c.add 'md', new DependantAttribute 0

		c.get('ad').addDependant c.get('str'), 2.00 # ad is +200% str
		c.get('ad').addDependant c.get('agi'), 1.00 # ad is +100% agi

		c.get('md').addDependant c.get('int'), 2.50 # md is +250% int

		c.get('hp').addDependant c.get('vit'), 5.00 # hp is +500% vit
		c.get('hp').addDependant c.get('str'), 2.00 # hp is +100% str

		c.get('mp').addDependant c.get('int'), 5.00 # mp is +500% int

		return c

module.exports = CAttribute