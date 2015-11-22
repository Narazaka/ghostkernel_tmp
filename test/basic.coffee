if require?
  assert = require 'power-assert'
  ghostkernel = require '../src/lib/ghostkernel'
  GhostKernel = ghostkernel.GhostKernel

describe 'GhostKernel', ->
  it 'can be inited', ->
    assert new GhostKernel()
