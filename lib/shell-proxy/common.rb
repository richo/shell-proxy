module CommonProxy
  def __main__(writer = nil, &block)
    @cmd_buffer = CmdBuffer.new
    instance_exec(&block)
    @cmd_buffer.write(writer || __writer)
  end

  def __eval(str)
    @cmd_buffer << str
  end

  # XXX Holy shit wat
  def __emit(str)
    __writer.flush
  end

  def __writer
    @writer ||= ShellWriter.new($stdout)
  end

end
