class Camera

	mapW:0
	mapH:0
	gameW:0
	gameH:0

	offSetX: 0
	offSetY: 0

	constructor: (@mapW, @mapH, @gameW, @gameH) ->

	update: (heroX, heroY) =>
		@offSetX = Math.min(Math.max(0, heroX - @gameW/2), @mapW - @gameW) | 0
		@offSetY = Math.min(Math.max(0, heroY - @gameH/2), @mapH - @gameH) | 0

window.Camera = Camera