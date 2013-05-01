module VimProxy include CommonProxy
  class InvalidMethodName < Exception; end
  def cd(dir)
    __eval("cd #{dir}")
  end

  def __function(name, &block)
    raise InvalidMethodName, "Methods must start with caps" unless (name =~ /[A-Z]/) == 0
    @cmd_buffer << "function! #{name}()"
    @cmd_buffer.indent
    yield
    @cmd_buffer.undent
    @cmd_buffer << "endfunction"
  end

  def touch(file)
    __eval("!touch #{file}")
  end

  def __subshell(&block)
    @cmd_buffer << '" subshell currently not implemented'
  end

  def __chdir(dir, &block)
    __eval "let __here=\"cd \" . getcwd()"
    __eval "cd #{dir}"
    @cmd_buffer.indent
    block.call
    @cmd_buffer.undent
    __eval "exec __here"
  end

  def __set(variable, value)
    __eval "let #{variable}=#{value}"
  end

end
