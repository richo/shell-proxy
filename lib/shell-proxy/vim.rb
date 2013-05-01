module VimProxy include CommonProxy
  class InvalidMethodName < Exception; end
  def cd(dir)
    __eval("cd #{dir}")
  end

  def __function(name, &block)
    raise InvalidMethodName, "Methods must start with caps" unless name[0] =~ /[A-Z]/
    @cmd_buffer << "function! #{name}()"
    @cmd_buffer.indent
    yield
    @cmd_buffer.undent
    @cmd_buffer << "endfunction"
  end

  def touch(file)
    __eval("!touch #{file}")
  end

end
