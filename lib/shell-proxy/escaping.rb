module Escaping
  def __escapinate(v)
    case v
    when RawString
      v.quote
    when BareString
      v
    when String
      "'#{v.gsub(/'/, "\\'").gsub("\\", "\\\\")}'"
    when Fixnum
      v
    end
  end
end

