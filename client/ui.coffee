class UI

	login: 
		div: null
		btnLogin: null
		txtUsername: null
		txtPassword: null
		txtStatus: null

	loading: null
	canvas: null

	lobby:
		div: null
		btnFindGame: null

	preGameLobby:
		div: null
		heroes: null
		me:
			div: null
			hero: null
			name: null

	constructor: ->
		@login.div = $('.login')
		@login.btnLogin = $('.btnlogin')
		@login.txtUsername = $('.txtusername')
		@login.txtPassword = $('.txtpassword')
		@login.txtStatus = $('.txtstatus')

		@loading = $('.loading')
		@canvas = $('.canvas')

		@lobby.div = $('.lobby')
		@lobby.btnFindGame = $('.btnfindgame')

		@preGameLobby.div = $('.pregamelobby')
		@preGameLobby.heroes = $('.pregamelobbybox .heroes')

		@preGameLobby.me.div = $('.pregamelobbybox .yourteam .player.p0')
		@preGameLobby.me.hero = $('.pregamelobbybox .yourteam .player.p0 .herobox .portrait')
		@preGameLobby.me.name = $('.pregamelobbybox .yourteam .player.p0 .name')

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

	showLobby: ->
		@lobby.div.removeClass 'invisible'

	hideLobby: ->
		@lobby.div.addClass 'invisible'

	showPreGameLobby: ->
		@preGameLobby.div.removeClass 'invisible'

	hidePreGameLobby: ->
		@preGameLobby.div.addClass 'invisible'

	initPreGameLobbyHeroes: (heroes) ->
		for i, hero of heroes
			continue if i is '0'
			txt = """
				  <div class='herobox' value='#{i}'>
					<div class='portrait hero#{i}'></div>
					<div class='name unselectable'>#{hero.name}</div>
				  </div>
				  """
			@preGameLobby.heroes.append txt

	heroBoxes: ->
		$('.herobox')

window.UI = UI