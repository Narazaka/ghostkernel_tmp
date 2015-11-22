# Ukagaka baseware ghost instance kernel
class GhostKernel
  # constructor
  # @param shiorif [Shiorif] SHIORI interface
  # @param view [Shell] Shell interface
  # @param ssp [SakuraScriptPlayer] Sakura Script runner
  # @param manager [GhostManager] Ghosts manager
  # @param plugins [Array<any>] plugins
  constructor: (@shiorif, @view, @ssp, @manager, @plugins) ->


if module?.exports?
  module.exports = GhostKernel: GhostKernel
else
  @GhostKernel = GhostKernel
