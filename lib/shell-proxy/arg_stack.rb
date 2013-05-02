class ArgStack
  attr_reader :stack, :proxy
  def initialize(proxy)
    @stack = []
    @proxy = proxy
  end

  def current
    raise "NotInFunction" if stack.empty?
    @stack.last
  end

  def push(args)
    @stack.push(proxy.new(args))
  end

  def pop
    @stack.pop
  end
end
