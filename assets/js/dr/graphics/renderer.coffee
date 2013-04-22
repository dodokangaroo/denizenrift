class Renderer

	constructor: (@canvas) ->
		@ctx = @canvas.getContext '2d'

		w = parseInt($(@canvas).css('width'), 10)
		h = parseInt($(@canvas).css('height'), 10)

		#update canvas size
		@canvas.width = w
		@canvas.height = h

		@ctx.width = w
		@ctx.height = $(@canvas).css 'height'

	clear: ->
		@ctx.clearRect 0, 0, 800, 600

	drawCircle: (x, y, r) ->
		@ctx.fillStyle = "rgba(64, 255, 64, 0.5)"
		@ctx.strokeStyle = "rgba(32, 128, 32, 0.8)"
		@ctx.lineWidth = 2

		@ctx.beginPath()
		@ctx.arc x, y, r, 0, Math.PI*2, true
		@ctx.closePath()
		@ctx.stroke()
		@ctx.fill()

	drawDebugText: (x, y, txt) ->
		@ctx.save()
		@ctx.fillStyle = "#000"
		@ctx.font = "16px ProggyCleanTT"
		@ctx.fillText txt, x, y
		@ctx.restore()

window.Renderer = Renderer