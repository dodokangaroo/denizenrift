class Bitmap

	ready: false

	constructor: (@url, rdy) ->
		@image = new Image
		@image.src = @url
		@image.onload = =>
			@ready = true
			#callback to notify loaded
			rdy() if rdy?

window.Bitmap = Bitmap