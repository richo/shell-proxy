module PosixProxy include CommonProxy
end

%w[
  builtins.rb
  escaping.rb

  case.rb
  for.rb
  if.rb
  temp.rb

  string_comparator.rb
  number_comparator.rb
  fs_comparator.rb

  replacer

  arg_proxy.rb
  cmdstub.rb
].each do |f|
  require File.expand_path("../posix/#{f}", __FILE__)
end

module PosixProxy
  include Escaping
  extend Builtins
  COMPARATORS = Hash.new { |h, k| raise "No comparator for #{k}" }
  COMPARATORS[String] = StringComparator
  COMPARATORS[Bignum] = NumberComparator
  COMPARATORS[Fixnum] = NumberComparator

  builtin :echo

  def __subshell(&block)
    @cmd_buffer << "("
    @cmd_buffer.indent
    yield
    @cmd_buffer.undent
    @cmd_buffer << ")"
  end

  def cmp(this, type)
    COMPARATORS[type].new(this)
  end

  def replace(text, opts={})
    Replacer.new(text, opts)
  end

  def __chdir(dir, &block)
    __subshell do
      cd(dir)
      yield
    end
  end

  def cd(dir)
    __eval("cd #{dir}")
  end

  def mkdir(dir)
    __eval("mkdir #{dir}")
  end

  def touch(file)
    __eval("touch #{__escapinate file}")
  end

  def __case(value, &block)
    CaseStub.new(__escapinate(value), &block).__handle(@cmd_buffer)
  end

  def __for(over, iter, &block)
    ForStub.new(over, iter, &block).__handle(@cmd_buffer)
  end

  def __if(condition, &block)
    IfStub.new(condition, &block).__handle(@cmd_buffer)
  end

  def mkdtemp(&block)
    MkTemp.new(@cmd_buffer).with(&block)
  end

  def __set(variable, value)
    __eval("#{variable}=#{__escapinate(value)}")
  end

  def __set?(variable)
    raw(%<[ -n "#{variable}" ]>)
  end

  def __unset(*variables)
    __eval("unset #{variables.join(" ")}")
  end

  def __export(variable, value=nil)
    export = "export #{variable}"
    export << "=#{__escapinate(value)}" if value
    __eval(export)
  end

  def basename(value)
    raw("$(basename #{value})")
  end

  def __call(fn, *args)
    call = fn
    unless args.empty?
      call << " "
      call << args.map do |arg|
        __escapinate(arg)
      end.join(" ")
    end
    __eval(call)
  end

  def __return(val)
    __eval("return #{__escapinate(val)}")
  end

  def __function(name, arity=nil, &block)
    @cmd_buffer << "#{name}() {"
    @cmd_buffer.indent
    arg_stack.push(arity)
    yield
    arg_stack.pop
    @cmd_buffer.undent
    @cmd_buffer << "}"
  end

  def arg_stack
    @arg_stack ||= ArgStack.new(ArgProxy)
  end

  def __process_args(args)
    args.map do |v|
      __escapinate(v)
    end.join(" ")
  end

  def __process_opts(opts)
    outputs = []
    __process_and_escape(opts) do |value|
      outputs << value
    end
    outputs.join(" ")
  end

  def __process_and_escape(opts)
    opts.each do |k, v|
      k = k.to_s
      k = (k.length == 1 ? "-" : "--") + k
      yield __escapinate(k)
      yield __escapinate(v) unless v.nil?
    end
  end

end
