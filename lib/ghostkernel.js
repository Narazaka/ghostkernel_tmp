(function() {
  var GhostKernel;

  GhostKernel = (function() {
    function GhostKernel(shiorif, view, ssp, manager, plugins) {
      this.shiorif = shiorif;
      this.view = view;
      this.ssp = ssp;
      this.manager = manager;
      this.plugins = plugins;
    }

    return GhostKernel;

  })();

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = {
      GhostKernel: GhostKernel
    };
  } else {
    this.GhostKernel = GhostKernel;
  }

}).call(this);

//# sourceMappingURL=ghostkernel.js.map
