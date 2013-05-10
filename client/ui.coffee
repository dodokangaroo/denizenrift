class UI

	login: 
		div: null
		btnLogin: null
		txtUsername: null
		txtPassword: null
		txtStatus: null

	selectHero:
		div: null
		box: null

	loading: null
	canvas: null

	lobby:
		div: null
		btnFindGame: null

	constructor: ->
		@login.div = $('.login')
		@login.btnLogin = $('.btnlogin')
		@login.txtUsername = $('.txtusername')
		@login.txtPassword = $('.txtpassword')
		@login.txtStatus = $('.txtstatus')

		@selectHero.div = $('.selecthero')
		@selectHero.box = $('.selectherobox')

		@loading = $('.loading')
		@canvas = $('.canvas')

		@lobby.div = $('.lobby')
		@lobby.btnFindGame = $('.btnfindgame')

	disableDrag: ->
		@canvas[0].draggable = false
		@canvas[0].onmousedown = (e) ->
			e.preventDefault()
			return false

	showSpinner: ->
		@loading.removeClass 'invisible'

	hideSpinner: ->
		@loading.addClass 'invisible'

	showLogin: ->
		@login.div.removeClass 'invisible'

	hideLogin: ->
		@login.div.addClass 'invisible'

	showSelectHero: ->
		@selectHero.div.removeClass 'invisible'

	hideSelectHero: ->
		@selectHero.div.addClass 'invisible'

	showLobby: ->
		@lobby.div.removeClass 'invisible'

	hideLobby: ->
		@lobby.div.addClass 'invisible'

	initSelectHero: (heroes) ->
		for i, hero of heroes
			txt = """
				  <div class='herobox' value='#{i}'>
					<div class='portrait hero#{i}'></div>
					<div class='name unselectable'>#{hero.name}</div>
				  </div>
				  """
			@selectHero.box.append txt

	heroBoxes: ->
		$('.herobox')

window.UI = UI