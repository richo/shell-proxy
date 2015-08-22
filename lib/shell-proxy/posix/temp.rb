class MkTemp
  def initialize(buffer)
    @buffer = buffer
  end

  def with(&blk)
    @buffer << "pushd $(mktemp -dt _vm)"
    blk.call
    # TODO this doesn't currently nuke the tempdir
    @buffer << "popd"
  end
end
