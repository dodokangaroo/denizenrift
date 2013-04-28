;(function(e,t,n){function i(n,s){if(!t[n]){if(!e[n]){var o=typeof require=="function"&&require;if(!s&&o)return o(n,!0);if(r)return r(n,!0);throw new Error("Cannot find module '"+n+"'")}var u=t[n]={exports:{}};e[n][0].call(u.exports,function(t){var r=e[n][1][t];return i(r?r:t)},u,u.exports)}return t[n].exports}var r=typeof require=="function"&&require;for(var s=0;s<n.length;s++)i(n[s]);return i})({1:[function(require,module,exports){
(function() {
  var game, login, onLogin, selectHero, sio, userlist,
    _this = this;

  require('./game.coffee');

  require('./utils/utils.coffee');

  require('./utils/input.coffee');

  require('./data/config.coffee');

  sio = null;

  game = null;

  userlist = [];

  $().ready(function() {
    return login(function(user) {
      var _this = this;

      selectHero(user, function(heroclass) {
        sio.emit('setclass', heroclass);
        return game = new Game(sio, user, heroclass, userlist);
      });
      sio.on('userlist', function(users) {
        return userlist = users;
      });
      return sio.on('userjoin', function(user) {
        return userlist.push(user);
      });
    });
  });

  login = function(fn) {
    $('.login').removeClass('invisible');
    console.log('Connecting');
    sio = io.connect();
    sio.on('connect', function() {
      console.log('Connected');
      return onLogin(fn);
    });
    return sio.on('disconnect', function() {
      sio.socket.reconnect();
      return console.log('Disconnected');
    });
  };

  onLogin = function(fn) {
    $('.input').removeClass('invisible');
    $('.spinner').addClass('invisible');
    $(document).keydown(function(e) {
      if (e.which === Key.ENTER) {
        return $('.btnlogin').click();
      }
    });
    return $('.btnlogin').click(function() {
      var err, pass, user;

      user = $('.txtusername').val();
      pass = $('.txtpassword').val();
      $('.txtusername').removeClass('error');
      $('.txtpassword').removeClass('error');
      err = false;
      $('.txtstatus').html('');
      if (user.length < 4) {
        err = true;
        $('.txtusername').addClass('error');
        $('.txtstatus').append('<p>Username must be 4 or more chars</p>');
      }
      if (pass.length < 6) {
        err = true;
        $('.txtpassword').addClass('error');
        $('.txtstatus').append('<p>Password must be 6 or more chars</p>');
      }
      if (!err) {
        $('.input').addClass('invisible');
        $('.spinner').removeClass('invisible');
        $('.txtpassword').val('');
        console.log('Logging in');
        return sio.emit('login', user, pass, function(res) {
          if (res.success) {
            console.log('Login success');
            $('.login').addClass('invisible');
            $(document).unbind('keydown');
            $('.btnlogin').unbind('click');
            return fn(res.user);
          } else {
            console.log('Login failed');
            $('.input').removeClass('invisible');
            $('.spinner').addClass('invisible');
            return $('.txtstatus').html('Authentication failed');
          }
        });
      }
    });
  };

  selectHero = function(user, fn) {
    var hero, i, _ref,
      _this = this;

    $('.selecthero').removeClass('invisible');
    _ref = Config.Classes;
    for (i in _ref) {
      hero = _ref[i];
      $('.selectherobox').append("<div class='herobox' value='" + i + "'>\n	<div class='portrait hero" + i + "'></div>\n	<div class='name unselectable'>" + hero.Name + "</div>\n</div>");
    }
    return $('.herobox').live('click', function(e) {
      var heroIndex;

      $('.selecthero').addClass('invisible');
      heroIndex = $(e.currentTarget).attr('value');
      $('.herobox').unbind('click');
      return fn(heroIndex);
    });
  };

}).call(this);


},{"./game.coffee":2,"./utils/utils.coffee":3,"./data/config.coffee":4,"./utils/input.coffee":5}],3:[function(require,module,exports){
(function() {
  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();

}).call(this);


},{}],4:[function(require,module,exports){
(function() {
  window.Config = {
    Classes: {
      0: {
        Name: "Mage",
        Description: "I'm a mage!",
        Health: 200,
        Attacks: [0]
      },
      1: {
        Name: "Squire",
        Description: "I'm a squire!",
        Health: 300,
        Attacks: []
      },
      2: {
        Name: "Monk",
        Description: "I'm a monk!",
        Health: 250,
        Attacks: []
      },
      3: {
        Name: "Hunter",
        Description: "I'm a hunter!",
        Health: 250,
        Attacks: []
      }
    },
    GraphicOffset: {
      Classes: {
        0: {
          x: 128,
          y: 464
        },
        1: {
          x: 64,
          y: 464
        },
        2: {
          x: 128,
          y: 480
        },
        3: {
          x: 0,
          y: 464
        }
      }
    },
    Maps: {
      0: {
        Name: "Cake Land"
      }
    }
  };

}).call(this);


},{}],5:[function(require,module,exports){
(function() {
  var Input,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Input = (function() {
    function Input() {
      this.addMouseListener = __bind(this.addMouseListener, this);
      this.addKeyboardListener = __bind(this.addKeyboardListener, this);
    }

    Input.prototype.keys = [];

    Input.prototype.mouseX = 0;

    Input.prototype.mouseY = 0;

    Input.prototype.mouseDown = false;

    Input.prototype.addKeyboardListener = function(div) {
      var _this = this;

      div.keydown(function(e) {
        return _this.keys[e.which] = true;
      });
      return div.keyup(function(e) {
        return _this.keys[e.which] = false;
      });
    };

    Input.prototype.addMouseListener = function(div) {
      var _this = this;

      div.mousemove(function(e) {
        _this.mouseX = e.pageX - $(div)[0].offsetLeft;
        return _this.mouseY = e.pageY - $(div)[0].offsetTop;
      });
      div.mousedown(function(e) {
        return _this.mouseDown = true;
      });
      return div.mouseup(function(e) {
        return _this.mouseDown = false;
      });
    };

    return Input;

  })();

  window.Input = new Input;

  window.Key = {
    ANY: -1,
    LEFT: 37,
    UP: 38,
    RIGHT: 39,
    DOWN: 40,
    ENTER: 13,
    CONTROL: 17,
    SPACE: 32,
    SHIFT: 16,
    BACKSPACE: 8,
    CAPS_LOCK: 20,
    DELETE: 46,
    END: 35,
    ESCAPE: 27,
    HOME: 36,
    INSERT: 45,
    TAB: 9,
    PAGE_DOWN: 34,
    PAGE_UP: 33,
    LEFT_SQUARE_BRACKET: 219,
    RIGHT_SQUARE_BRACKET: 221,
    A: 65,
    B: 66,
    C: 67,
    D: 68,
    E: 69,
    F: 70,
    G: 71,
    H: 72,
    I: 73,
    J: 74,
    K: 75,
    L: 76,
    M: 77,
    N: 78,
    O: 79,
    P: 80,
    Q: 81,
    R: 82,
    S: 83,
    T: 84,
    U: 85,
    V: 86,
    W: 87,
    X: 88,
    Y: 89,
    Z: 90,
    F1: 112,
    F2: 113,
    F3: 114,
    F4: 115,
    F5: 116,
    F6: 117,
    F7: 118,
    F8: 119,
    F9: 120,
    F10: 121,
    F11: 122,
    F12: 123,
    F13: 124,
    F14: 125,
    F15: 126,
    DIGIT_0: 48,
    DIGIT_1: 49,
    DIGIT_2: 50,
    DIGIT_3: 51,
    DIGIT_4: 52,
    DIGIT_5: 53,
    DIGIT_6: 54,
    DIGIT_7: 55,
    DIGIT_8: 56,
    DIGIT_9: 57,
    NUMPAD_0: 96,
    NUMPAD_1: 97,
    NUMPAD_2: 98,
    NUMPAD_3: 99,
    NUMPAD_4: 100,
    NUMPAD_5: 101,
    NUMPAD_6: 102,
    NUMPAD_7: 103,
    NUMPAD_8: 104,
    NUMPAD_9: 105,
    NUMPAD_ADD: 107,
    NUMPAD_DECIMAL: 110,
    NUMPAD_DIVIDE: 111,
    NUMPAD_ENTER: 108,
    NUMPAD_MULTIPLY: 106,
    NUMPAD_SUBTRACT: 109
  };

}).call(this);


},{}],2:[function(require,module,exports){
(function() {
  var Game, stats,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require('./entities/gamemap.coffee');

  require('./entities/hero.coffee');

  require('./utils/input.coffee');

  require('./cmds/mv.coffee');

  require('./cmds/chat.coffee');

  require('./cmds/setclass.coffee');

  require('./cmds/userjoin.coffee');

  require('./cmds/userleft.coffee');

  stats = new Stats();

  stats.setMode(0);

  stats.domElement.style.position = 'absolute';

  stats.domElement.style.left = '0px';

  stats.domElement.style.top = '0px';

  Game = (function() {
    Game.prototype.entities = [];

    Game.prototype.users = {};

    Game.prototype.spriteSheets = ['sprites/entities.json'];

    Game.prototype.lastX = -1;

    Game.prototype.lastY = -1;

    function Game(sio, user, heroclass, userlist) {
      var canvas, loader,
        _this = this;

      this.sio = sio;
      this.user = user;
      this.heroclass = heroclass;
      this.userlist = userlist;
      this.loop = __bind(this.loop, this);
      this.addUser = __bind(this.addUser, this);
      canvas = $('.dr .canvas');
      this.stage = new PIXI.Stage;
      this.renderer = PIXI.autoDetectRenderer(1024, 640);
      canvas.append(this.renderer.view);
      canvas.append(stats.domElement);
      Input.addKeyboardListener($(document));
      Input.addMouseListener(canvas);
      this.setupCmds();
      loader = new PIXI.AssetLoader(this.spriteSheets);
      loader.onComplete = function() {
        _this.init();
        return _this.run();
      };
      loader.load();
    }

    Game.prototype.init = function() {
      var u, _i, _len, _ref, _results;

      this.map = new GameMap(0);
      this.stage.addChild(this.map.spr);
      this.entities.push(this.map);
      this.hero = new Hero(this, this.heroclass);
      this.hero.x = 128;
      this.hero.y = 128;
      this.hero.userControlled = true;
      this.entities.push(this.hero);
      _ref = this.userlist;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        u = _ref[_i];
        _results.push(this.addUser(u));
      }
      return _results;
    };

    Game.prototype.setupCmds = function() {
      new CmdMv(this.user, this, this.sio);
      new CmdChat(this.user, this, this.sio);
      new CmdSetClass(this.user, this, this.sio);
      new CmdUserJoin(this.user, this, this.sio);
      return new CmdUserLeft(this.user, this, this.sio);
    };

    Game.prototype.addUser = function(u) {
      var h;

      h = new Hero(this, u.heroclass);
      h.x = u.x;
      h.y = u.y;
      h.data = u;
      this.entities.push(h);
      return this.users[u.id] = h;
    };

    Game.prototype.run = function() {
      return this.loop();
    };

    Game.prototype.loop = function() {
      var e, lastX, lastY, _i, _len, _ref;

      stats.begin();
      requestAnimFrame(this.loop);
      _ref = this.entities;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        e.update();
      }
      if (lastX !== this.hero.x || lastY !== this.hero.y) {
        lastX = this.hero.x;
        lastY = this.hero.y;
        this.sio.emit('mv', this.hero.x, this.hero.y);
      }
      if (Math.random() > 0.99) {
        this.sio.emit('chat', "Some random message " + (Math.random()));
      }
      this.renderer.render(this.stage);
      return stats.end();
    };

    return Game;

  })();

  window.Game = Game;

}).call(this);


},{"./entities/gamemap.coffee":6,"./entities/hero.coffee":7,"./utils/input.coffee":5,"./cmds/mv.coffee":8,"./cmds/chat.coffee":9,"./cmds/setclass.coffee":10,"./cmds/userjoin.coffee":11,"./cmds/userleft.coffee":12}],8:[function(require,module,exports){
(function() {
  var CmdMv;

  CmdMv = (function() {
    function CmdMv(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('mv', function(id, x, y) {
        user = _this.game.users[id];
        if (user == null) {
          return;
        }
        user.x = x;
        return user.y = y;
      });
    }

    return CmdMv;

  })();

  window.CmdMv = CmdMv;

}).call(this);


},{}],9:[function(require,module,exports){
(function() {
  var CmdChat;

  CmdChat = (function() {
    function CmdChat(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('chat', function(id, message) {
        user = _this.game.users[id];
        if (user == null) {
          return;
        }
        return console.log("" + user.data.name + " said: " + message);
      });
    }

    return CmdChat;

  })();

  window.CmdChat = CmdChat;

}).call(this);


},{}],10:[function(require,module,exports){
(function() {
  var CmdSetClass;

  CmdSetClass = (function() {
    function CmdSetClass(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('setclass', function(id, heroclass) {
        user = _this.game.users[id];
        if (user == null) {
          return;
        }
        return user.setClass(heroclass);
      });
    }

    return CmdSetClass;

  })();

  window.CmdSetClass = CmdSetClass;

}).call(this);


},{}],11:[function(require,module,exports){
(function() {
  var CmdUserJoin;

  CmdUserJoin = (function() {
    function CmdUserJoin(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('userjoin', function(u) {
        console.log("User " + u.id + " joined");
        return _this.game.addUser(u);
      });
    }

    return CmdUserJoin;

  })();

  window.CmdUserJoin = CmdUserJoin;

}).call(this);


},{}],12:[function(require,module,exports){
(function() {
  var CmdUserLeft;

  CmdUserLeft = (function() {
    function CmdUserLeft(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('userleft', function(id) {
        console.log("User " + id + " left");
        user = _this.game.users[id];
        if (user == null) {
          return;
        }
        _this.game.entities.splice(_this.game.entities.indexOf(user), 1);
        _this.game.stage.removeChild(user.spr);
        return delete _this.game.users[id];
      });
    }

    return CmdUserLeft;

  })();

  window.CmdUserLeft = CmdUserLeft;

}).call(this);


},{}],6:[function(require,module,exports){
(function() {
  var GameMap,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require('../data/config.coffee');

  GameMap = (function() {
    GameMap.prototype.w = 1024;

    GameMap.prototype.h = 640;

    GameMap.prototype.spr = null;

    function GameMap(id) {
      this.id = id;
      this.update = __bind(this.update, this);
      this.spr = new PIXI.Sprite(PIXI.Texture.fromImage('img/map.png'));
      this.data = Config.Maps[this.id];
      this.name = this.data.Name;
    }

    GameMap.prototype.update = function() {};

    return GameMap;

  })();

  window.GameMap = GameMap;

}).call(this);


},{"../data/config.coffee":4}],7:[function(require,module,exports){
(function() {
  var Hero,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require('../data/config.coffee');

  require('../utils/input.coffee');

  Hero = (function() {
    Hero.prototype.speed = 2;

    Hero.prototype.userControlled = false;

    Hero.prototype.spr = null;

    Hero.prototype.data = null;

    function Hero(game, heroclass) {
      this.game = game;
      this.heroclass = heroclass;
      this.update = __bind(this.update, this);
      this.setClass = __bind(this.setClass, this);
      this.setClass(this.heroclass);
    }

    Hero.prototype.setClass = function(heroclass) {
      this.heroclass = heroclass;
      if (this.spr != null) {
        this.game.stage.removeChild(this.spr);
      }
      this.spr = new PIXI.MovieClip([PIXI.Texture.fromFrame("Hero " + this.heroclass + " 0.png"), PIXI.Texture.fromFrame("Hero " + this.heroclass + " 1.png"), PIXI.Texture.fromFrame("Hero " + this.heroclass + " 2.png"), PIXI.Texture.fromFrame("Hero " + this.heroclass + " 3.png")]);
      return this.game.stage.addChild(this.spr);
    };

    Hero.prototype.update = function() {
      var dx, dy;

      if (this.userControlled) {
        dx = 0;
        dy = 0;
        if (Input.keys[Key.W]) {
          dy -= this.speed;
        }
        if (Input.keys[Key.S]) {
          dy += this.speed;
        }
        if (Input.keys[Key.A]) {
          dx -= this.speed;
        }
        if (Input.keys[Key.D]) {
          dx += this.speed;
        }
        if (this.x + dx < 0) {
          dx = 0;
        }
        if (this.x + dx > 1024 - 16) {
          dx = 0;
        }
        if (this.y + dy < 0) {
          dy = 0;
        }
        if (this.y + dy > 640 - 16) {
          dy = 0;
        }
        if (dx !== 0 && dy !== 0) {
          dx *= Math.SQRT1_2;
          dy *= Math.SQRT1_2;
        }
        this.x += dx;
        this.y += dy;
        if (dx < 0) {
          this.spr.gotoAndStop(2);
        }
        if (dx > 0) {
          this.spr.gotoAndStop(0);
        }
        if (dy < 0) {
          this.spr.gotoAndStop(3);
        }
        if (dy > 0) {
          this.spr.gotoAndStop(1);
        }
      }
      this.spr.position.x = this.x | 0;
      return this.spr.position.y = this.y | 0;
    };

    return Hero;

  })();

  window.Hero = Hero;

}).call(this);


},{"../data/config.coffee":4,"../utils/input.coffee":5}]},{},[1])
;