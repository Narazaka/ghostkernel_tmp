(function() {
  var GhostManager;

  GhostManager = (function() {
    GhostManager.prototype.ghosts = null;

    function GhostManager(profile, plugins) {
      this.profile = profile;
      this.plugins = plugins;
      this.ghosts = [];
    }

    GhostManager.prototype.boot_ghost = function(ghostpath, storage, namedmanager) {
      return this.get_kernel(ghostpath, storage, namedmanager).then(function(kernel) {
        return kernel.start();
      });
    };

    GhostManager.prototype.get_kernel = function(ghostpath, shellpath, balloonpath, storage, namedmanager) {
      return Promise.all([this._get_ghost(ghostpath, storage), this._get_shell(ghostpath, shellpath, storage), this._get_balloon(balloonpath, storage)]).then(function(arg) {
        var balloon, named, shell, shiori, shiorif, ssp;
        shiori = arg[0], shell = arg[1], balloon = arg[2];
        shiorif = new Shiorif(shiori);
        named = namedmanager.register_named(shell, balloon);
        ssp = new SakuraScriptPlayer(named);
        return new GhostKernel(shiorif, named, ssp);
      });
    };

    GhostManager._canondirpath = function(dirpath) {
      var path_separator;
      path_separator = dirpath.match(/[\\\/]/)[0];
      return dirpath.replace(new RegExp('\\' + path_separator + '?$'), path_separator);
    };

    GhostManager.prototype._get_ghost = function(ghostpath, storage) {
      this.on_load_ghost_files(ghostpath);
      return GhostManager._get_ghost_directory(ghostpath, storage).then((function(_this) {
        return function(directory) {
          _this.on_ghost_load(ghostpath, directory);
          return GhostManager._load_ghost(directory);
        };
      })(this)).then((function(_this) {
        return function(ghost) {
          _this.on_ghost_loaded(ghostpath, ghost);
          return ghost;
        };
      })(this));
    };

    GhostManager._get_ghost_directory = function(ghostpath, storage) {
      var dirpath;
      dirpath = GhostManager._canondirpath(storage.ghost_master_path(ghostpath));
      return storage.ghost_master(ghostpath);
    };

    GhostManager._load_ghost = function(directory) {
      return ShioriLoader.detect_shiori(storage.backend.fs, dirpath).then(function(shiori) {
        return shiori.load(dirpath);
      });
    };

    GhostManager.prototype._get_shell = function(ghostpath, shellpath, storage) {
      this.on_load_shell_files(ghostpath, shellpath);
      return GhostManager._get_shell_directory(ghostpath, shellpath, storage).then((function(_this) {
        return function(directory) {
          _this.on_shell_load(ghostpath, shellpath, directory);
          return GhostManager._load_shell(directory);
        };
      })(this)).then((function(_this) {
        return function(shell) {
          _this.on_shell_loaded(ghostpath, shellpath, shell);
          return shell;
        };
      })(this));
    };

    GhostManager._get_shell_directory = function(ghostpath, shellpath, storage) {
      return storage.shell(ghostpath, shellpath);
    };

    GhostManager._load_shell = function(directory) {
      var shell;
      shell = new cuttlebone.Shell(directory.asArrayBuffer());
      return shell.load();
    };

    GhostManager.prototype._get_balloon = function(balloonpath, storage) {
      this.on_load_balloon_files(balloonpath);
      return GhostManager._get_balloon_directory(balloonpath, storage).then((function(_this) {
        return function(directory) {
          _this.on_balloon_load(balloonpath, directory);
          return GhostManager._load_balloon(directory);
        };
      })(this)).then((function(_this) {
        return function(balloon) {
          _this.on_balloon_loaded(balloonpath, shell);
          return balloon;
        };
      })(this));
    };

    GhostManager._get_balloon_directory = function(balloonpath, storage) {
      return storage.balloon(balloonpath);
    };

    GhostManager._load_balloon = function(directory) {
      var balloon;
      balloon = new cuttlebone.Balloon(directory.asArrayBuffer());
      return balloon.load();
    };

    return GhostManager;

  })();

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = {
      GhostManager: GhostManager
    };
  } else {
    this.GhostManager = GhostManager;
  }

}).call(this);

//# sourceMappingURL=ghostmanager.js.map
