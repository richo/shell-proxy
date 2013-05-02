module CommonProxy
  def __main__(writer = nil, buffer = nil, &block)
    @cmd_buffer = buffer || CmdBuffer.new
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

  def args
    arg_stack.current
  end
end
