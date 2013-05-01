module CommonProxy

end

INDENT_PADDING="  "

class RawString < String
  def quote
    inspect
  end
end

class BareString < String
end

%w[
  cmd_buffer.rb
  shell_writer.rb
  posix.rb
].each do |f|
  require File.expand_path("../shell-proxy/#{f}", __FILE__)
end

def raw(s)
  RawString.new(s)
end

def bare(s)
  BareString.new(s)
end
