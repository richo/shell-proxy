INDENT_PADDING="  "

class RawString < String
  def quote
    inspect
  end
end

class BareString < String
end

%w[
  common.rb
  cmd_buffer.rb
  arg_stack.rb
  shell_writer.rb
  posix.rb
  vim.rb
].each do |f|
  require File.expand_path("../shell-proxy/#{f}", __FILE__)
end

def raw(s)
  RawString.new(s)
end

def bare(s)
  BareString.new(s)
end
