#= require_tree utils
#= require_tree graphics
#= require_tree entities
#= require_tree data

bmpentities = new Bitmap 'img/entities.png'
bmpmap = new Bitmap 'img/map.png'
bmptowers = new Bitmap 'img/tower.png'

class Game

	entities: []

	tower: null

	constructor: (@user, @heroclass) ->

		@container = $('.dr')
		@canvas = $('.dr .canvas')[0]

		Input.addKeyboardListener $(document)
		Input.addMouseListener @container

		@renderer = new Renderer @canvas

		@map = new GameMap bmpmap, bmpentities, 0
		@hero = new Hero bmpentities, @heroclass

		@hero.x = 128
		@hero.y = 128
		@hero.userControlled = true

		@entities.push @map
		@entities.push @hero

	run: ->
		@loop()

	loop: =>
		requestAnimFrame @loop

		@renderer.clear()

		for e in @entities
			e.update()
			e.draw @renderer.ctx

window.Game = Game