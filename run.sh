killall node
browserify -t coffeeify ./client/app.coffee > ./webserver/assets/js/app.js
wr -v --exec "browserify -t coffeeify ./client/app.coffee > ./webserver/assets/js/app.js" client &
coffee webserver/app.coffee &
