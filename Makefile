all:
	browserify -w -d -t coffeeify client/app.coffee > webserver/assets/js/app.js &
