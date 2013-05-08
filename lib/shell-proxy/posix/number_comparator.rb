class NumberComparator
  include Escaping
  def initialize(me)
    @me = me
  end

  %w[eq neq gt lt].each do |op|
    self.send(:define_method, op) do |other|
      return raw(%<[ #{__escapinate @me} -#{op} #{__escapinate other} ]>)
    end
  end
end
