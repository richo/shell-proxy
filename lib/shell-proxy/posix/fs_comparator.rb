class FSComparator
  include Escaping

  def exists?(other)
      return raw(%<[ -f #{__escapinate other} ]>)
  end

end
