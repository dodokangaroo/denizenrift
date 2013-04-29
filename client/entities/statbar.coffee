class StatBar

	spr: null
	fill: null
	back: null

	constructor: (col = 0)->

		@spr = new PIXI.DisplayObjectContainer
		# toString else 0/1 gets converted to bool
		@back = new PIXI.Sprite PIXI.Texture.fromFrame "Bar #{Number(col).toString(10)} Back.png"
		@fill = new PIXI.Sprite PIXI.Texture.fromFrame "Bar #{Number(col).toString(10)} Fill.png"

		@fill.position.x = 2
		@fill.position.y = 1

		@spr.addChild @back
		@spr.addChild @fill

window.StatBar = StatBar