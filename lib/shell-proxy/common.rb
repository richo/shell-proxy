module CommonProxy
  def __main__(writer = nil, &block)
    @cmd_buffer = CmdBuffer.new
    instance_exec(&block)
    @cmd_buffer.write(writer || __writer)
  end

end
