%w[
  arg_proxy.rb
  case.rb
].each do |f|
  require File.expand_path("../vim/#{f}", __FILE__)
end
module VimProxy include CommonProxy
  class InvalidMethodName < Exception; end
  def cd(dir)
    __eval("cd #{dir}")
  end

  def __function(name, arity = nil, &block)
    raise InvalidMethodName, "Methods must start with caps" unless (name =~ /^[_A-Z]/) == 0
    args = arity && (1..arity).map { |n| "arg#{n}" }.join(", ")
    @cmd_buffer << "function! #{name}(#{args})"
    @cmd_buffer.indent
    arg_stack.push(arity)
    yield
    arg_stack.pop
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

  def __case(value, &block)
    CaseStub.new(value, &block).__handle(@cmd_buffer)
  end

  def __call(fn, *args)
    opts = (args.last.is_a? Hash) ? args.pop : {}
    prefix = opts.include?(:prefix) ? "#{opts[:prefix]}:" : ""
    call = "call #{prefix}#{fn}("
    call << args.join(", ")
    call << ")"
    __eval(call)
  end

  def arg_stack
    @arg_stack ||= ArgStack.new(ArgProxy)
  end

  def echo(arg)
    __eval("echo #{arg}")
  end
end
