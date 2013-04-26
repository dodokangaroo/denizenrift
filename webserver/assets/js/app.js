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
    sio = io.connect();
    return sio.on('connect', onLogin(fn));
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
        return sio.emit('login', user, pass, function(res) {
          if (res.success) {
            $('.login').addClass('invisible');
            $(document).unbind('keydown');
            $('.btnlogin').unbind('click');
            return fn(res.user);
          } else {
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


},{"./game.coffee":2,"./utils/utils.coffee":3,"./utils/input.coffee":4,"./data/config.coffee":5}],4:[function(require,module,exports){
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


},{}],3:[function(require,module,exports){
(function() {
  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();

}).call(this);


},{}],2:[function(require,module,exports){
(function() {
  var Game,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require('./entities/gamemap.coffee');

  require('./entities/hero.coffee');

  require('./utils/input.coffee');

  require('./cmds/mv.coffee');

  require('./cmds/setclass.coffee');

  require('./cmds/userjoin.coffee');

  require('./cmds/userleft.coffee');

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
      this.hero = new Hero(this.heroclass);
      this.stage.addChild(this.map.spr);
      this.stage.addChild(this.hero.spr);
      this.hero.x = 128;
      this.hero.y = 128;
      this.hero.userControlled = true;
      this.entities.push(this.map);
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
      new CmdSetClass(this.user, this, this.sio);
      new CmdUserJoin(this.user, this, this.sio);
      return new CmdUserLeft(this.user, this, this.sio);
    };

    Game.prototype.addUser = function(u) {
      var h;

      h = new Hero(txEntity, u.heroclass);
      h.x = u.x;
      h.y = u.y;
      this.entities.push(h);
      this.users[u.id] = h;
      return this.stage.addChild(this.h.spr);
    };

    Game.prototype.run = function() {
      return this.loop();
    };

    Game.prototype.loop = function() {
      var e, lastX, lastY, _i, _len, _ref;

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
      return this.renderer.render(this.stage);
    };

    return Game;

  })();

  window.Game = Game;

}).call(this);


},{"./entities/gamemap.coffee":6,"./entities/hero.coffee":7,"./utils/input.coffee":4,"./cmds/mv.coffee":8,"./cmds/setclass.coffee":9,"./cmds/userjoin.coffee":10,"./cmds/userleft.coffee":11}],5:[function(require,module,exports){
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


},{}],8:[function(require,module,exports){
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


},{}],10:[function(require,module,exports){
(function() {
  var CmdUserJoin;

  CmdUserJoin = (function() {
    function CmdUserJoin(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('userjoin', function(u) {
        return _this.game.addUser(u);
      });
    }

    return CmdUserJoin;

  })();

  window.CmdUserJoin = CmdUserJoin;

}).call(this);


},{}],11:[function(require,module,exports){
(function() {
  var CmdUserLeft;

  CmdUserLeft = (function() {
    function CmdUserLeft(user, game, sio) {
      var _this = this;

      this.user = user;
      this.game = game;
      this.sio = sio;
      this.sio.on('userleft', function(id) {
        user = _this.game.users[id];
        if (user == null) {
          return;
        }
        _this.game.entities.splice(_this.game.entities.indexOf(user), 1);
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
    GameMap.prototype.sw = 1024;

    GameMap.prototype.sh = 640;

    GameMap.prototype.dw = 1024;

    GameMap.prototype.dh = 640;

    GameMap.prototype.sx = 0;

    GameMap.prototype.sy = 0;

    GameMap.prototype.spr = new PIXI.Sprite(PIXI.Texture.fromImage('img/map.png'));

    function GameMap(id) {
      this.id = id;
      this.update = __bind(this.update, this);
      this.data = Config.Maps[this.id];
      this.name = this.data.Name;
    }

    GameMap.prototype.update = function() {};

    return GameMap;

  })();

  window.GameMap = GameMap;

}).call(this);


},{"../data/config.coffee":5}],7:[function(require,module,exports){
(function() {
  var Hero,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require('../data/config.coffee');

  Hero = (function() {
    Hero.prototype.sw = 16;

    Hero.prototype.sh = 16;

    Hero.prototype.dw = 16;

    Hero.prototype.dh = 16;

    Hero.prototype.sx = 0;

    Hero.prototype.sy = 0;

    Hero.prototype.speed = 2;

    Hero.prototype.userControlled = false;

    Hero.prototype.spr = null;

    function Hero(heroclass) {
      var spr;

      this.heroclass = heroclass;
      this.update = __bind(this.update, this);
      this.setClass = __bind(this.setClass, this);
      spr = new PIXI.Sprite(PIXI.Texture.fromFrame('Hero 0 1.png'));
      this.setClass(this.heroclass);
    }

    Hero.prototype.setClass = function(heroclass) {
      this.sx = Config.GraphicOffset.Classes[heroclass].x;
      this.sy = Config.GraphicOffset.Classes[heroclass].y;
      return this.basex = Config.GraphicOffset.Classes[heroclass].x;
    };

    Hero.prototype.update = function() {
      var dx, dy;

      if (this.userControlled) {
        dx = 0;
        dy = 0;
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
          this.sx = this.basex + 32;
        }
        if (dx > 0) {
          this.sx = this.basex + 0;
        }
        if (dy < 0) {
          this.sx = this.basex + 48;
        }
        if (dy > 0) {
          return this.sx = this.basex + 16;
        }
      }
    };

    Hero.prototype.draw = function(ctx, x, y) {
      if (x == null) {
        x = this.x;
      }
      if (y == null) {
        y = this.y;
      }
      return Hero.__super__.draw.call(this, ctx, x | 0, y | 0);
    };

    return Hero;

  })();

  window.Hero = Hero;

}).call(this);


},{"../data/config.coffee":5}]},{},[1])
//@ sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvaG9tZS9qb3NoL2Rlbml6ZW5yaWZ0L2NsaWVudC9hcHAuY29mZmVlIiwiL2hvbWUvam9zaC9kZW5pemVucmlmdC9jbGllbnQvdXRpbHMvaW5wdXQuY29mZmVlIiwiL2hvbWUvam9zaC9kZW5pemVucmlmdC9jbGllbnQvdXRpbHMvdXRpbHMuY29mZmVlIiwiL2hvbWUvam9zaC9kZW5pemVucmlmdC9jbGllbnQvZ2FtZS5jb2ZmZWUiLCIvaG9tZS9qb3NoL2Rlbml6ZW5yaWZ0L2NsaWVudC9kYXRhL2NvbmZpZy5jb2ZmZWUiLCIvaG9tZS9qb3NoL2Rlbml6ZW5yaWZ0L2NsaWVudC9jbWRzL212LmNvZmZlZSIsIi9ob21lL2pvc2gvZGVuaXplbnJpZnQvY2xpZW50L2NtZHMvc2V0Y2xhc3MuY29mZmVlIiwiL2hvbWUvam9zaC9kZW5pemVucmlmdC9jbGllbnQvY21kcy91c2Vyam9pbi5jb2ZmZWUiLCIvaG9tZS9qb3NoL2Rlbml6ZW5yaWZ0L2NsaWVudC9jbWRzL3VzZXJsZWZ0LmNvZmZlZSIsIi9ob21lL2pvc2gvZGVuaXplbnJpZnQvY2xpZW50L2VudGl0aWVzL2dhbWVtYXAuY29mZmVlIiwiL2hvbWUvam9zaC9kZW5pemVucmlmdC9jbGllbnQvZW50aXRpZXMvaGVyby5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUFBQTtDQUFBLEtBQUEseUNBQUE7S0FBQSxPQUFBOztDQUFBLENBQUEsS0FBQSxRQUFBOztDQUFBLENBQ0EsS0FBQSxlQUFBOztDQURBLENBRUEsS0FBQSxlQUFBOztDQUZBLENBR0EsS0FBQSxlQUFBOztDQUhBLENBS0EsQ0FBQSxDQUxBOztDQUFBLENBTUEsQ0FBTyxDQUFQOztDQU5BLENBT0EsQ0FBVyxLQUFYOztDQVBBLENBU0EsQ0FBVSxFQUFWLElBQVU7Q0FFSCxFQUFBLENBQUEsQ0FBTixJQUFPLEVBQVA7Q0FDQyxTQUFBLEVBQUE7O0NBQUEsQ0FBaUIsQ0FBQSxDQUFqQixF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QyxDQUFELENBQU0sQ0FBTCxDQUFLLFlBQU47VUF6QkQ7UUFGTztDQXhCUixJQXdCUTs7Q0F4QlIsQ0FxRFksQ0FBTixDQUFOLEtBQU87O0NBQVUsRUFBRCxDQUFDLElBQUw7UUFDWDs7Q0FEd0IsRUFBRCxDQUFDLElBQUw7UUFDbkI7Q0FBVyxDQUFBLENBQVgsVUFBQSxrQkFBTTtDQXREUCxJQXFETTs7Q0FyRE47O0NBSkQ7O0NBQUEsQ0E2REEsQ0FBYyxDQUFkLEVBQU07Q0E3RE4iLCJzb3VyY2VzQ29udGVudCI6WyJyZXF1aXJlICcuL2dhbWUuY29mZmVlJ1xyXG5yZXF1aXJlICcuL3V0aWxzL3V0aWxzLmNvZmZlZSdcclxucmVxdWlyZSAnLi91dGlscy9pbnB1dC5jb2ZmZWUnXHJcbnJlcXVpcmUgJy4vZGF0YS9jb25maWcuY29mZmVlJ1xyXG5cclxuc2lvID0gbnVsbFxyXG5nYW1lID0gbnVsbFxyXG51c2VybGlzdCA9IFtdXHJcblxyXG4kKCkucmVhZHkgLT5cclxuXHJcblx0bG9naW4gKHVzZXIpIC0+XHJcblx0XHRzZWxlY3RIZXJvIHVzZXIsIChoZXJvY2xhc3MpIC0+XHJcblx0XHRcdHNpby5lbWl0ICdzZXRjbGFzcycsIGhlcm9jbGFzc1xyXG5cclxuXHRcdFx0Z2FtZSA9IG5ldyBHYW1lIHNpbywgdXNlciwgaGVyb2NsYXNzLCB1c2VybGlzdFxyXG5cclxuXHRcdHNpby5vbiAndXNlcmxpc3QnLCAodXNlcnMpID0+XHJcblx0XHRcdHVzZXJsaXN0ID0gdXNlcnNcclxuXHJcblx0XHRzaW8ub24gJ3VzZXJqb2luJywgKHVzZXIpID0+XHJcblx0XHRcdHVzZXJsaXN0LnB1c2ggdXNlclxyXG5cclxubG9naW4gPSAoZm4pID0+XHJcblxyXG5cdCNzaG93IHNwaW5uZXIgd2hpbGUgc2lvLmlvIGNvbm5lY3RzXHJcblx0JCgnLmxvZ2luJykucmVtb3ZlQ2xhc3MgJ2ludmlzaWJsZSdcclxuXHJcblx0c2lvID0gaW8uY29ubmVjdCgpXHJcblx0c2lvLm9uICdjb25uZWN0Jywgb25Mb2dpbiBmblxyXG5cclxub25Mb2dpbiA9IChmbikgPT5cclxuXHJcblx0JCgnLmlucHV0JykucmVtb3ZlQ2xhc3MgJ2ludmlzaWJsZSdcclxuXHQkKCcuc3Bpbm5lcicpLmFkZENsYXNzICdpbnZpc2libGUnXHJcblxyXG5cdCQoZG9jdW1lbnQpLmtleWRvd24gKGUpID0+XHJcblx0XHRpZiBlLndoaWNoIGlzIEtleS5FTlRFUlxyXG5cdFx0XHQkKCcuYnRubG9naW4nKS5jbGljaygpXHJcblxyXG5cdCQoJy5idG5sb2dpbicpLmNsaWNrID0+XHJcblxyXG5cdFx0dXNlciA9ICQoJy50eHR1c2VybmFtZScpLnZhbCgpXHJcblx0XHRwYXNzID0gJCgnLnR4dHBhc3N3b3JkJykudmFsKClcclxuXHJcblx0XHQkKCcudHh0dXNlcm5hbWUnKS5yZW1vdmVDbGFzcyAnZXJyb3InXHJcblx0XHQkKCcudHh0cGFzc3dvcmQnKS5yZW1vdmVDbGFzcyAnZXJyb3InXHJcblxyXG5cdFx0ZXJyID0gZmFsc2VcclxuXHJcblx0XHQkKCcudHh0c3RhdHVzJykuaHRtbCAnJ1xyXG5cclxuXHRcdGlmIHVzZXIubGVuZ3RoIDwgNFxyXG5cdFx0XHRlcnIgPSB0cnVlXHJcblx0XHRcdCQoJy50eHR1c2VybmFtZScpLmFkZENsYXNzICdlcnJvcidcclxuXHRcdFx0JCgnLnR4dHN0YXR1cycpLmFwcGVuZCAnPHA+VXNlcm5hbWUgbXVzdCBiZSA0IG9yIG1vcmUgY2hhcnM8L3A+J1xyXG5cdFx0aWYgcGFzcy5sZW5ndGggPCA2XHJcblx0XHRcdGVyciA9IHRydWVcclxuXHRcdFx0JCgnLnR4dHBhc3N3b3JkJykuYWRkQ2xhc3MgJ2Vycm9yJ1xyXG5cdFx0XHQkKCcudHh0c3RhdHVzJykuYXBwZW5kICc8cD5QYXNzd29yZCBtdXN0IGJlIDYgb3IgbW9yZSBjaGFyczwvcD4nXHJcblxyXG5cdFx0aWYgIWVyclxyXG5cdFx0XHQkKCcuaW5wdXQnKS5hZGRDbGFzcyAnaW52aXNpYmxlJ1xyXG5cdFx0XHQkKCcuc3Bpbm5lcicpLnJlbW92ZUNsYXNzICdpbnZpc2libGUnXHJcblxyXG5cdFx0XHQkKCcudHh0cGFzc3dvcmQnKS52YWwgJydcclxuXHJcblx0XHRcdHNpby5lbWl0ICdsb2dpbicsIHVzZXIsIHBhc3MsIChyZXMpID0+XHJcblx0XHRcdFx0XHJcblx0XHRcdFx0aWYgcmVzLnN1Y2Nlc3NcclxuXHRcdFx0XHRcdCQoJy5sb2dpbicpLmFkZENsYXNzICdpbnZpc2libGUnXHJcblxyXG5cdFx0XHRcdFx0JChkb2N1bWVudCkudW5iaW5kICdrZXlkb3duJ1xyXG5cdFx0XHRcdFx0JCgnLmJ0bmxvZ2luJykudW5iaW5kICdjbGljaydcclxuXHJcblx0XHRcdFx0XHRmbiByZXMudXNlclxyXG5cdFx0XHRcdGVsc2VcclxuXHRcdFx0XHRcdCQoJy5pbnB1dCcpLnJlbW92ZUNsYXNzICdpbnZpc2libGUnXHJcblx0XHRcdFx0XHQkKCcuc3Bpbm5lcicpLmFkZENsYXNzICdpbnZpc2libGUnXHJcblx0XHRcdFx0XHQkKCcudHh0c3RhdHVzJykuaHRtbCAnQXV0aGVudGljYXRpb24gZmFpbGVkJ1xyXG5cclxuc2VsZWN0SGVybyA9ICh1c2VyLCBmbikgLT5cclxuXHJcblx0JCgnLnNlbGVjdGhlcm8nKS5yZW1vdmVDbGFzcyAnaW52aXNpYmxlJ1xyXG5cclxuXHRmb3IgaSwgaGVybyBvZiBDb25maWcuQ2xhc3Nlc1xyXG5cdFx0JCgnLnNlbGVjdGhlcm9ib3gnKS5hcHBlbmQgXCJcIlwiXHJcblx0XHRcdFx0XHRcdFx0XHRcdDxkaXYgY2xhc3M9J2hlcm9ib3gnIHZhbHVlPScje2l9Jz5cclxuXHRcdFx0XHRcdFx0XHRcdFx0XHQ8ZGl2IGNsYXNzPSdwb3J0cmFpdCBoZXJvI3tpfSc+PC9kaXY+XHJcblx0XHRcdFx0XHRcdFx0XHRcdFx0PGRpdiBjbGFzcz0nbmFtZSB1bnNlbGVjdGFibGUnPiN7aGVyby5OYW1lfTwvZGl2PlxyXG5cdFx0XHRcdFx0XHRcdFx0XHQ8L2Rpdj5cclxuXHRcdFx0XHRcdFx0XHRcdCAgIFwiXCJcIlxyXG5cclxuXHQkKCcuaGVyb2JveCcpLmxpdmUgJ2NsaWNrJywgKGUpID0+XHJcblxyXG5cdFx0JCgnLnNlbGVjdGhlcm8nKS5hZGRDbGFzcyAnaW52aXNpYmxlJ1xyXG5cclxuXHRcdGhlcm9JbmRleCA9ICQoZS5jdXJyZW50VGFyZ2V0KS5hdHRyICd2YWx1ZSdcclxuXHJcblx0XHQkKCcuaGVyb2JveCcpLnVuYmluZCAnY2xpY2snXHJcblxyXG5cdFx0Zm4gaGVyb0luZGV4IiwiY2xhc3MgSW5wdXRcclxuXHJcblx0a2V5czogW11cclxuXHJcblx0bW91c2VYOiAwXHJcblx0bW91c2VZOiAwXHJcblx0bW91c2VEb3duOiBmYWxzZVxyXG5cclxuXHRhZGRLZXlib2FyZExpc3RlbmVyOiAoZGl2KSA9PlxyXG5cdFx0ZGl2LmtleWRvd24gKGUpID0+XHJcblx0XHRcdEBrZXlzW2Uud2hpY2hdID0gdHJ1ZVxyXG5cdFx0ZGl2LmtleXVwIChlKSA9PlxyXG5cdFx0XHRAa2V5c1tlLndoaWNoXSA9IGZhbHNlXHJcblxyXG5cdGFkZE1vdXNlTGlzdGVuZXI6IChkaXYpID0+XHJcblx0XHRkaXYubW91c2Vtb3ZlIChlKSA9PlxyXG5cdFx0XHRAbW91c2VYID0gZS5wYWdlWCAtICQoZGl2KVswXS5vZmZzZXRMZWZ0XHJcblx0XHRcdEBtb3VzZVkgPSBlLnBhZ2VZIC0gJChkaXYpWzBdLm9mZnNldFRvcFxyXG5cdFx0ZGl2Lm1vdXNlZG93biAoZSkgPT5cclxuXHRcdFx0QG1vdXNlRG93biA9IHRydWVcclxuXHRcdGRpdi5tb3VzZXVwIChlKSA9PlxyXG5cdFx0XHRAbW91c2VEb3duID0gZmFsc2VcclxuXHJcbndpbmRvdy5JbnB1dCA9IG5ldyBJbnB1dFxyXG5cclxud2luZG93LktleSA9IFxyXG5cdEFOWTogLTFcclxuXHJcblx0TEVGVDogMzdcclxuXHRVUDogMzhcclxuXHRSSUdIVDogMzlcclxuXHRET1dOOiA0MFxyXG5cclxuXHRFTlRFUjogMTNcclxuXHRDT05UUk9MOiAxN1xyXG5cdFNQQUNFOiAzMlxyXG5cdFNISUZUOiAxNlxyXG5cdEJBQ0tTUEFDRTogOFxyXG5cdENBUFNfTE9DSzogMjBcclxuXHRERUxFVEU6IDQ2XHJcblx0RU5EOiAzNVxyXG5cdEVTQ0FQRTogMjdcclxuXHRIT01FOiAzNlxyXG5cdElOU0VSVDogNDVcclxuXHRUQUI6IDlcclxuXHRQQUdFX0RPV046IDM0XHJcblx0UEFHRV9VUDogMzNcclxuXHRMRUZUX1NRVUFSRV9CUkFDS0VUOiAyMTlcclxuXHRSSUdIVF9TUVVBUkVfQlJBQ0tFVDogMjIxXHJcblxyXG5cdEE6IDY1XHJcblx0QjogNjZcclxuXHRDOiA2N1xyXG5cdEQ6IDY4XHJcblx0RTogNjlcclxuXHRGOiA3MFxyXG5cdEc6IDcxXHJcblx0SDogNzJcclxuXHRJOiA3M1xyXG5cdEo6IDc0XHJcblx0SzogNzVcclxuXHRMOiA3NlxyXG5cdE06IDc3XHJcblx0TjogNzhcclxuXHRPOiA3OVxyXG5cdFA6IDgwXHJcblx0UTogODFcclxuXHRSOiA4MlxyXG5cdFM6IDgzXHJcblx0VDogODRcclxuXHRVOiA4NVxyXG5cdFY6IDg2XHJcblx0VzogODdcclxuXHRYOiA4OFxyXG5cdFk6IDg5XHJcblx0WjogOTBcclxuXHJcblx0RjE6IDExMlxyXG5cdEYyOiAxMTNcclxuXHRGMzogMTE0XHJcblx0RjQ6IDExNVxyXG5cdEY1OiAxMTZcclxuXHRGNjogMTE3XHJcblx0Rjc6IDExOFxyXG5cdEY4OiAxMTlcclxuXHRGOTogMTIwXHJcblx0RjEwOiAxMjFcclxuXHRGMTE6IDEyMlxyXG5cdEYxMjogMTIzXHJcblx0RjEzOiAxMjRcclxuXHRGMTQ6IDEyNVxyXG5cdEYxNTogMTI2XHJcblxyXG5cdERJR0lUXzA6IDQ4XHJcblx0RElHSVRfMTogNDlcclxuXHRESUdJVF8yOiA1MFxyXG5cdERJR0lUXzM6IDUxXHJcblx0RElHSVRfNDogNTJcclxuXHRESUdJVF81OiA1M1xyXG5cdERJR0lUXzY6IDU0XHJcblx0RElHSVRfNzogNTVcclxuXHRESUdJVF84OiA1NlxyXG5cdERJR0lUXzk6IDU3XHJcblxyXG5cdE5VTVBBRF8wOiA5NlxyXG5cdE5VTVBBRF8xOiA5N1xyXG5cdE5VTVBBRF8yOiA5OFxyXG5cdE5VTVBBRF8zOiA5OVxyXG5cdE5VTVBBRF80OiAxMDBcclxuXHROVU1QQURfNTogMTAxXHJcblx0TlVNUEFEXzY6IDEwMlxyXG5cdE5VTVBBRF83OiAxMDNcclxuXHROVU1QQURfODogMTA0XHJcblx0TlVNUEFEXzk6IDEwNVxyXG5cdE5VTVBBRF9BREQ6IDEwN1xyXG5cdE5VTVBBRF9ERUNJTUFMOiAxMTBcclxuXHROVU1QQURfRElWSURFOiAxMTFcclxuXHROVU1QQURfRU5URVI6IDEwOFxyXG5cdE5VTVBBRF9NVUxUSVBMWTogMTA2XHJcblx0TlVNUEFEX1NVQlRSQUNUOiAxMDkiLCJ3aW5kb3cucmVxdWVzdEFuaW1GcmFtZSA9ICgtPlxyXG4gIHdpbmRvdy5yZXF1ZXN0QW5pbWF0aW9uRnJhbWUgb3IgXHJcbiAgd2luZG93LndlYmtpdFJlcXVlc3RBbmltYXRpb25GcmFtZSBvciBcclxuICB3aW5kb3cubW96UmVxdWVzdEFuaW1hdGlvbkZyYW1lIG9yIFxyXG4gIHdpbmRvdy5vUmVxdWVzdEFuaW1hdGlvbkZyYW1lIG9yIFxyXG4gIHdpbmRvdy5tc1JlcXVlc3RBbmltYXRpb25GcmFtZSBvciBcclxuICAoY2FsbGJhY2ssIGVsZW1lbnQpIC0+XHJcbiAgICB3aW5kb3cuc2V0VGltZW91dCBjYWxsYmFjaywgMTAwMCAvIDYwXHJcbikoKSIsInJlcXVpcmUgJy4vZW50aXRpZXMvZ2FtZW1hcC5jb2ZmZWUnXHJcbnJlcXVpcmUgJy4vZW50aXRpZXMvaGVyby5jb2ZmZWUnXHJcbnJlcXVpcmUgJy4vdXRpbHMvaW5wdXQuY29mZmVlJ1xyXG5cclxucmVxdWlyZSAnLi9jbWRzL212LmNvZmZlZSdcclxucmVxdWlyZSAnLi9jbWRzL3NldGNsYXNzLmNvZmZlZSdcclxucmVxdWlyZSAnLi9jbWRzL3VzZXJqb2luLmNvZmZlZSdcclxucmVxdWlyZSAnLi9jbWRzL3VzZXJsZWZ0LmNvZmZlZSdcclxuXHJcbmNsYXNzIEdhbWVcclxuXHJcblx0ZW50aXRpZXM6IFtdXHJcblx0dXNlcnM6IHt9XHJcblx0c3ByaXRlU2hlZXRzOiBbJ3Nwcml0ZXMvZW50aXRpZXMuanNvbiddXHJcblxyXG5cdGxhc3RYOiAtMVxyXG5cdGxhc3RZOiAtMVxyXG5cclxuXHRjb25zdHJ1Y3RvcjogKEBzaW8sIEB1c2VyLCBAaGVyb2NsYXNzLCBAdXNlcmxpc3QpIC0+XHJcblxyXG5cdFx0Y2FudmFzID0gJCgnLmRyIC5jYW52YXMnKVxyXG5cclxuXHRcdEBzdGFnZSA9IG5ldyBQSVhJLlN0YWdlXHJcblx0XHRAcmVuZGVyZXIgPSBQSVhJLmF1dG9EZXRlY3RSZW5kZXJlciAxMDI0LCA2NDBcclxuXHRcdFx0XHJcblx0XHRjYW52YXMuYXBwZW5kIEByZW5kZXJlci52aWV3XHJcblxyXG5cdFx0QHNldHVwQ21kcygpXHJcblxyXG5cdFx0bG9hZGVyID0gbmV3IFBJWEkuQXNzZXRMb2FkZXIgQHNwcml0ZVNoZWV0c1xyXG5cdFx0bG9hZGVyLm9uQ29tcGxldGUgPSA9PlxyXG5cdFx0XHRAaW5pdCgpXHJcblx0XHRcdEBydW4oKVxyXG5cdFx0bG9hZGVyLmxvYWQoKVxyXG5cclxuXHRpbml0OiAtPlxyXG5cclxuXHRcdEBtYXAgPSBuZXcgR2FtZU1hcCAwXHJcblx0XHRAaGVybyA9IG5ldyBIZXJvIEBoZXJvY2xhc3NcclxuXHJcblx0XHRAc3RhZ2UuYWRkQ2hpbGQgQG1hcC5zcHJcclxuXHRcdEBzdGFnZS5hZGRDaGlsZCBAaGVyby5zcHJcclxuXHJcblx0XHRAaGVyby54ID0gMTI4XHJcblx0XHRAaGVyby55ID0gMTI4XHJcblx0XHRAaGVyby51c2VyQ29udHJvbGxlZCA9IHRydWVcclxuXHJcblx0XHRAZW50aXRpZXMucHVzaCBAbWFwXHJcblx0XHRAZW50aXRpZXMucHVzaCBAaGVyb1xyXG5cclxuXHRcdGZvciB1IGluIEB1c2VybGlzdFxyXG5cdFx0XHRAYWRkVXNlciB1XHJcblxyXG5cdHNldHVwQ21kczogLT5cclxuXHRcdG5ldyBDbWRNdiBAdXNlciwgQCwgQHNpb1xyXG5cdFx0bmV3IENtZFNldENsYXNzIEB1c2VyLCBALCBAc2lvXHJcblx0XHRuZXcgQ21kVXNlckpvaW4gQHVzZXIsIEAsIEBzaW9cclxuXHRcdG5ldyBDbWRVc2VyTGVmdCBAdXNlciwgQCwgQHNpb1xyXG5cclxuXHRhZGRVc2VyOiAodSkgPT5cclxuXHRcdGggPSBuZXcgSGVybyB0eEVudGl0eSwgdS5oZXJvY2xhc3NcclxuXHRcdGgueCA9IHUueFxyXG5cdFx0aC55ID0gdS55XHJcblx0XHRAZW50aXRpZXMucHVzaCBoXHJcblx0XHRAdXNlcnNbdS5pZF0gPSBoXHJcblx0XHRAc3RhZ2UuYWRkQ2hpbGQgQGguc3ByXHJcblxyXG5cdHJ1bjogLT5cclxuXHRcdEBsb29wKClcclxuXHJcblx0bG9vcDogPT5cclxuXHRcdHJlcXVlc3RBbmltRnJhbWUgQGxvb3BcclxuXHJcblx0XHRmb3IgZSBpbiBAZW50aXRpZXNcclxuXHRcdFx0ZS51cGRhdGUoKVxyXG5cclxuXHRcdGlmIGxhc3RYICE9IEBoZXJvLnggb3IgbGFzdFkgIT0gQGhlcm8ueVxyXG5cclxuXHRcdFx0bGFzdFggPSBAaGVyby54XHJcblx0XHRcdGxhc3RZID0gQGhlcm8ueVxyXG5cclxuXHRcdFx0QHNpby5lbWl0ICdtdicsIEBoZXJvLngsIEBoZXJvLnlcclxuXHJcblx0XHRAcmVuZGVyZXIucmVuZGVyIEBzdGFnZVxyXG5cclxud2luZG93LkdhbWUgPSBHYW1lIiwid2luZG93LkNvbmZpZyA9IFxuXG5cdENsYXNzZXM6XG5cdFx0MDpcblx0XHRcdE5hbWU6IFwiTWFnZVwiXG5cdFx0XHREZXNjcmlwdGlvbjogXCJJJ20gYSBtYWdlIVwiXG5cdFx0XHRIZWFsdGg6IDIwMFxuXHRcdFx0QXR0YWNrczogWzBdXG5cdFx0MTpcblx0XHRcdE5hbWU6IFwiU3F1aXJlXCJcblx0XHRcdERlc2NyaXB0aW9uOiBcIkknbSBhIHNxdWlyZSFcIlxuXHRcdFx0SGVhbHRoOiAzMDBcblx0XHRcdEF0dGFja3M6IFtdXG5cdFx0Mjpcblx0XHRcdE5hbWU6IFwiTW9ua1wiXG5cdFx0XHREZXNjcmlwdGlvbjogXCJJJ20gYSBtb25rIVwiXG5cdFx0XHRIZWFsdGg6IDI1MFxuXHRcdFx0QXR0YWNrczogW11cblx0XHQzOlxuXHRcdFx0TmFtZTogXCJIdW50ZXJcIlxuXHRcdFx0RGVzY3JpcHRpb246IFwiSSdtIGEgaHVudGVyIVwiXG5cdFx0XHRIZWFsdGg6IDI1MFxuXHRcdFx0QXR0YWNrczogW11cblxuXHRHcmFwaGljT2Zmc2V0OlxuXHRcdENsYXNzZXM6XG5cdFx0XHQwOlxuXHRcdFx0XHR4OiAxMjhcblx0XHRcdFx0eTogNDY0XG5cdFx0XHQxOlxuXHRcdFx0XHR4OiA2NFxuXHRcdFx0XHR5OiA0NjRcblx0XHRcdDI6XG5cdFx0XHRcdHg6IDEyOFxuXHRcdFx0XHR5OiA0ODBcblx0XHRcdDM6XG5cdFx0XHRcdHg6IDBcblx0XHRcdFx0eTogNDY0XG5cblx0TWFwczpcblx0XHQwOlxuXHRcdFx0TmFtZTogXCJDYWtlIExhbmRcIiIsImNsYXNzIENtZE12XG5cblx0Y29uc3RydWN0b3I6IChAdXNlciwgQGdhbWUsIEBzaW8pIC0+XG5cblx0XHRAc2lvLm9uICdtdicsIChpZCwgeCwgeSkgPT5cblx0XHRcdHVzZXIgPSBAZ2FtZS51c2Vyc1tpZF1cblx0XHRcdHJldHVybiBpZiAhdXNlcj8gI2Vycm9yIHVzZXIgZG9lc250IGV4aXN0XG5cdFx0XHR1c2VyLnggPSB4XG5cdFx0XHR1c2VyLnkgPSB5XG5cbndpbmRvdy5DbWRNdiA9IENtZE12IiwiY2xhc3MgQ21kU2V0Q2xhc3NcblxuXHRjb25zdHJ1Y3RvcjogKEB1c2VyLCBAZ2FtZSwgQHNpbykgLT5cblxuXHRcdEBzaW8ub24gJ3NldGNsYXNzJywgKGlkLCBoZXJvY2xhc3MpID0+XG5cdFx0XHR1c2VyID0gQGdhbWUudXNlcnNbaWRdXG5cdFx0XHRyZXR1cm4gaWYgIXVzZXI/ICNlcnJvciB1c2VyIGRvZXNudCBleGlzdFxuXHRcdFx0dXNlci5zZXRDbGFzcyBoZXJvY2xhc3Ncblxud2luZG93LkNtZFNldENsYXNzID0gQ21kU2V0Q2xhc3MiLCJjbGFzcyBDbWRVc2VySm9pblxuXG5cdGNvbnN0cnVjdG9yOiAoQHVzZXIsIEBnYW1lLCBAc2lvKSAtPlxuXG5cdFx0QHNpby5vbiAndXNlcmpvaW4nLCAodSkgPT5cblx0XHRcdEBnYW1lLmFkZFVzZXIgdVxuXG53aW5kb3cuQ21kVXNlckpvaW4gPSBDbWRVc2VySm9pbiIsImNsYXNzIENtZFVzZXJMZWZ0XG5cblx0Y29uc3RydWN0b3I6IChAdXNlciwgQGdhbWUsIEBzaW8pIC0+XG5cblx0XHRAc2lvLm9uICd1c2VybGVmdCcsIChpZCkgPT5cblx0XHRcdHVzZXIgPSBAZ2FtZS51c2Vyc1tpZF1cblx0XHRcdHJldHVybiBpZiAhdXNlcj8gI2Vycm9yIHVzZXIgZG9lc250IGV4aXN0XG5cdFx0XHRAZ2FtZS5lbnRpdGllcy5zcGxpY2UgQGdhbWUuZW50aXRpZXMuaW5kZXhPZih1c2VyKSwgMVxuXHRcdFx0ZGVsZXRlIEBnYW1lLnVzZXJzW2lkXVxuXG53aW5kb3cuQ21kVXNlckxlZnQgPSBDbWRVc2VyTGVmdCIsInJlcXVpcmUgJy4uL2RhdGEvY29uZmlnLmNvZmZlZSdcclxuXHJcbmNsYXNzIEdhbWVNYXBcclxuXHJcblx0c3c6IDEwMjRcclxuXHRzaDogNjQwXHJcblx0ZHc6IDEwMjRcclxuXHRkaDogNjQwXHJcblxyXG5cdHN4OiAwXHJcblx0c3k6IDBcclxuXHJcblx0c3ByOiBuZXcgUElYSS5TcHJpdGUgUElYSS5UZXh0dXJlLmZyb21JbWFnZSAnaW1nL21hcC5wbmcnXHJcblxyXG5cdGNvbnN0cnVjdG9yOiAoQGlkKSAtPlxyXG5cdFx0QGRhdGEgPSBDb25maWcuTWFwc1tAaWRdXHJcblx0XHRAbmFtZSA9IEBkYXRhLk5hbWVcclxuXHJcblx0dXBkYXRlOiA9PlxyXG5cclxud2luZG93LkdhbWVNYXAgPSBHYW1lTWFwIiwicmVxdWlyZSAnLi4vZGF0YS9jb25maWcuY29mZmVlJ1xyXG5cclxuY2xhc3MgSGVyb1xyXG5cclxuXHRzdzogMTZcclxuXHRzaDogMTZcclxuXHRkdzogMTZcclxuXHRkaDogMTZcclxuXHJcblx0c3g6IDBcclxuXHRzeTogMFxyXG5cclxuXHRzcGVlZDogMlxyXG5cclxuXHR1c2VyQ29udHJvbGxlZDogZmFsc2VcclxuXHJcblx0c3ByOiBudWxsXHJcblxyXG5cdGNvbnN0cnVjdG9yOiAoQGhlcm9jbGFzcykgLT5cclxuXHRcdHNwciA9IG5ldyBQSVhJLlNwcml0ZSBQSVhJLlRleHR1cmUuZnJvbUZyYW1lICdIZXJvIDAgMS5wbmcnXHJcblx0XHRAc2V0Q2xhc3MgQGhlcm9jbGFzc1xyXG5cclxuXHRzZXRDbGFzczogKGhlcm9jbGFzcykgPT5cclxuXHRcdEBzeCA9IENvbmZpZy5HcmFwaGljT2Zmc2V0LkNsYXNzZXNbaGVyb2NsYXNzXS54XHJcblx0XHRAc3kgPSBDb25maWcuR3JhcGhpY09mZnNldC5DbGFzc2VzW2hlcm9jbGFzc10ueVxyXG5cclxuXHRcdEBiYXNleCA9IENvbmZpZy5HcmFwaGljT2Zmc2V0LkNsYXNzZXNbaGVyb2NsYXNzXS54XHJcblxyXG5cdHVwZGF0ZTogPT5cclxuXHJcblx0XHRpZiBAdXNlckNvbnRyb2xsZWRcclxuXHRcdFx0ZHggPSAwXHJcblx0XHRcdGR5ID0gMFxyXG5cclxuXHRcdFx0I2R5IC09IEBzcGVlZCBpZiBJbnB1dC5rZXlzW0tleS5XXVxyXG5cdFx0XHQjZHkgKz0gQHNwZWVkIGlmIElucHV0LmtleXNbS2V5LlNdXHJcblx0XHRcdCNkeCAtPSBAc3BlZWQgaWYgSW5wdXQua2V5c1tLZXkuQV1cclxuXHRcdFx0I2R4ICs9IEBzcGVlZCBpZiBJbnB1dC5rZXlzW0tleS5EXVxyXG5cclxuXHRcdFx0IyBDaGVja2luZyBpZiB0aGUgdXNlciBnb2VzIG91dHNpZGUgYm91bmRhcmllc1xyXG5cdFx0XHRkeCA9IDAgaWYgQHggKyBkeCA8IDBcdFxyXG5cdFx0XHRkeCA9IDAgaWYgQHggKyBkeCA+IDEwMjQgLSAxNlxyXG5cdFx0XHRkeSA9IDAgaWYgQHkgKyBkeSA8IDBcclxuXHRcdFx0ZHkgPSAwIGlmIEB5ICsgZHkgPiA2NDAgLSAxNlxyXG5cclxuXHRcdFx0aWYgZHggIT0gMCAmJiBkeSAhPSAwXHJcblx0XHRcdFx0ZHggKj0gTWF0aC5TUVJUMV8yXHJcblx0XHRcdFx0ZHkgKj0gTWF0aC5TUVJUMV8yXHJcblxyXG5cdFx0XHRAeCArPSBkeFxyXG5cdFx0XHRAeSArPSBkeVxyXG5cclxuXHRcdFx0QHN4ID0gQGJhc2V4ICsgMzIgaWYgZHggPCAwXHJcblx0XHRcdEBzeCA9IEBiYXNleCArIDAgaWYgZHggPiAwXHJcblx0XHRcdEBzeCA9IEBiYXNleCArIDQ4IGlmIGR5IDwgMFxyXG5cdFx0XHRAc3ggPSBAYmFzZXggKyAxNiBpZiBkeSA+IDBcclxuXHJcblx0ZHJhdzogKGN0eCwgeCA9IEB4LCB5ID0gQHkpIC0+XHJcblx0XHRzdXBlciBjdHgsIHggfCAwLCB5IHwgMFxyXG5cclxuXHJcbndpbmRvdy5IZXJvID0gSGVybyJdfQ==
;