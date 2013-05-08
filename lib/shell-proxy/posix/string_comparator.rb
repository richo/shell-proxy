class StringComparator
  include Escaping
  def initialize(me)
    @me = me
  end

  def eq(other)
    return raw(%<[ #{__escapinate @me} = #{__escapinate other} ]>)
  end

  def neq(other)
    return raw(%<[ #{__escapinate @me} != #{__escapinate other} ]>)
  end
end
