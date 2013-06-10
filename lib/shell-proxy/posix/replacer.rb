class Replacer
  def initialize(text, opts={})
    @cmd = "\\sed"
    @no_shell = !!opts[:no_shell]
    self.and(text, opts)
  end

  def with(text)
    @cmd << %< -e "s#{@s}#{@text}#{@s}#{text}#{@s}#{@opts}">
    self
  end

  def and(text, opts={})
    @text = text
    @s = opts[:seperator] || "|"
    @opts = opts[:sed_opts] || ""
    self
  end

  def to_s
    if @no_shell
      @cmd
    else
      BareString.new("$(#{@cmd})")
    end
  end

  def exec(input)
    BareString.new(%<$(echo "#{input}" | #{@cmd})>)
  end

end
