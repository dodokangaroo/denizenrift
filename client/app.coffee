require './game.coffee'
require './utils/utils.coffee'
require './utils/input.coffee'
require './data/config.coffee'

sio = null
game = null
userlist = []

$().ready ->

	login (user) ->
		selectHero user, (heroclass) ->
			sio.emit 'setclass', heroclass

			game = new Game sio, user, heroclass, userlist

		sio.on 'userlist', (users) =>
			userlist = users

		sio.on 'userjoin', (user) =>
			userlist.push user

login = (fn) =>

	#show spinner while sio.io connects
	$('.login').removeClass 'invisible'

	console.log 'Connecting'

	sio = io.connect()
	sio.on 'connect', =>
		console.log 'Connected'
		onLogin fn

	sio.on 'disconnect', ->
		sio.socket.reconnect()
		console.log 'Disconnected'


onLogin = (fn) =>

	$('.input').removeClass 'invisible'
	$('.spinner').addClass 'invisible'

	$(document).keydown (e) =>
		if e.which is Key.ENTER
			$('.btnlogin').click()

	$('.btnlogin').click =>

		user = $('.txtusername').val()
		pass = $('.txtpassword').val()

		$('.txtusername').removeClass 'error'
		$('.txtpassword').removeClass 'error'

		err = false

		$('.txtstatus').html ''

		if user.length < 4
			err = true
			$('.txtusername').addClass 'error'
			$('.txtstatus').append '<p>Username must be 4 or more chars</p>'
		if pass.length < 6
			err = true
			$('.txtpassword').addClass 'error'
			$('.txtstatus').append '<p>Password must be 6 or more chars</p>'

		if !err
			$('.input').addClass 'invisible'
			$('.spinner').removeClass 'invisible'

			$('.txtpassword').val ''

			console.log 'Logging in'
			sio.emit 'login', user, pass, (res) =>
				
				if res.success
					console.log 'Login success'
					$('.login').addClass 'invisible'

					$(document).unbind 'keydown'
					$('.btnlogin').unbind 'click'

					fn res.user
				else
					console.log 'Login failed'
					$('.input').removeClass 'invisible'
					$('.spinner').addClass 'invisible'
					$('.txtstatus').html 'Authentication failed'

selectHero = (user, fn) ->

	$('.selecthero').removeClass 'invisible'

	for i, hero of Config.Classes
		$('.selectherobox').append """
									<div class='herobox' value='#{i}'>
										<div class='portrait hero#{i}'></div>
										<div class='name unselectable'>#{hero.Name}</div>
									</div>
								   """

	$('.herobox').live 'click', (e) =>

		$('.selecthero').addClass 'invisible'

		heroIndex = $(e.currentTarget).attr 'value'

		$('.herobox').unbind 'click'

		fn heroIndex