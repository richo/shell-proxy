class FSComparator
  include Escaping

  def exists?(other)
      return raw(%<[ -f #{__escapinate other} ]>)
  end

  def directory?(other)
      return raw(%<[ -d #{__escapinate other} ]>)
  end

end
