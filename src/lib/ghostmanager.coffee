# Ukagaka baseware ghost manager
class GhostManager
  # @property [Array<GhostKernel>] ghost instances
  ghosts: null

  # constructor
  constructor: (@profile, @plugins) ->
    @ghosts = []

  boot_ghost: (ghostpath, storage, namedmanager) ->
    @get_kernel(ghostpath, storage, namedmanager).then((kernel) ->
      kernel.start()
    )

  # build ghost kernel
  # @param ghostpath [string] ghostpath
  # @param shellpath [string] shellpath
  # @param balloonpath [string] balloonpath
  # @param storage [NanikaStorage] storage
  # @param namedmanager [NamedManager] named manager
  # @return [Promise<GhostKernel>] ghost kernel instance
  get_kernel: (ghostpath, shellpath, balloonpath, storage, namedmanager) ->
    Promise.all([
      @_get_ghost(ghostpath, storage)
      @_get_shell(ghostpath, shellpath, storage)
      @_get_balloon(balloonpath, storage)
    ]).then(([shiori, shell, balloon]) ->
      shiorif = new Shiorif(shiori)
      named = namedmanager.register_named(shell, balloon)
      ssp = new SakuraScriptPlayer(named)
      new GhostKernel(shiorif, named, ssp)
    )

  # ensure path separator at dirpath' end
  # @param dirpath [string] dirpath
  # @return [string] dirpath that ends with path separator
  @_canondirpath: (dirpath) ->
    path_separator = dirpath.match(/[\\\/]/)[0]
    dirpath.replace(new RegExp('\\' + path_separator + '?$'), path_separator)

  # get ghost(shiori) instance
  # @param ghostpath [string] ghostpath
  # @param storage [NanikaStorage] storage
  # @return [Promise<Shiori>] ghost(shiori) instance
  _get_ghost: (ghostpath, storage) ->
    @on_load_ghost_files(ghostpath)
    GhostManager._get_ghost_directory(ghostpath, storage)
    .then((directory) =>
      @on_ghost_load(ghostpath, directory)
      GhostManager._load_ghost(directory)
    ).then((ghost) =>
      @on_ghost_loaded(ghostpath, ghost)
      ghost
    )

  # get ghost directory contents
  # @param ghostpath [string] ghostpath
  # @param storage [NanikaStorage] storage
  # @return [Promise<NanikaDirectory>] ghost directory contents
  @_get_ghost_directory: (ghostpath, storage) ->
    dirpath = GhostManager._canondirpath(storage.ghost_master_path(ghostpath))
    storage.ghost_master(ghostpath)

  # load ghost(shiori)
  # @param [NanikaDirectory] ghost directory contents
  # @return [Promise<Shiori>] ghost(shiori) instance
  @_load_ghost: (directory) ->
    ShioriLoader.detect_shiori(storage.backend.fs, dirpath).then((shiori) ->
      shiori.load(dirpath)
    )

  # get shell instance
  # @param ghostpath [string] ghostpath
  # @param shellpath [string] shellpath
  # @param storage [NanikaStorage] storage
  # @return [Promise<Shell>] shell instance
  _get_shell: (ghostpath, shellpath, storage) ->
    @on_load_shell_files(ghostpath, shellpath)
    GhostManager._get_shell_directory(ghostpath, shellpath, storage)
    .then((directory) =>
      @on_shell_load(ghostpath, shellpath, directory)
      GhostManager._load_shell(directory)
    ).then((shell) =>
      @on_shell_loaded(ghostpath, shellpath, shell)
      shell
    )

  # get hell directory contents
  # @param ghostpath [string] ghostpath
  # @param shellpath [string] shellpath
  # @param storage [NanikaStorage] storage
  # @return [Promise<NanikaDirectory>] shell directory contents
  @_get_shell_directory: (ghostpath, shellpath, storage) ->
    storage.shell(ghostpath, shellpath)

  # load shell
  # @param [NanikaDirectory] shell directory contents
  # @return [Promise<Shell>] shell instance
  @_load_shell: (directory) ->
    shell = new cuttlebone.Shell(directory.asArrayBuffer())
    shell.load()

  # get balloon instance
  # @param balloonpath [string] balloonpath
  # @param storage [NanikaStorage] storage
  # @return [Promise<Balloon>] balloon instance
  _get_balloon: (balloonpath, storage) ->
    @on_load_balloon_files(balloonpath)
    GhostManager._get_balloon_directory(balloonpath, storage)
    .then((directory) =>
      @on_balloon_load(balloonpath, directory)
      GhostManager._load_balloon(directory)
    ).then((balloon) =>
      @on_balloon_loaded(balloonpath, shell)
      balloon
    )

  # get balloon directory contents
  # @param balloonpath [string] balloonpath
  # @param storage [NanikaStorage] storage
  # @return [Promise<NanikaDirectory>] balloon directory contents
  @_get_balloon_directory: (balloonpath, storage) ->
    storage.balloon(balloonpath)

  # load balloon
  # @param [NanikaDirectory] balloon directory contents
  # @return [Promise<Balloon>] balloon instance
  @_load_balloon: (directory) ->
    balloon = new cuttlebone.Balloon(directory.asArrayBuffer())
    balloon.load()


if module?.exports?
  module.exports = GhostManager: GhostManager
else
  @GhostManager = GhostManager
