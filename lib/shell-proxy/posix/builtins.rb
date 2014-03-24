module PosixProxy
  class InvalidOption < Exception
  end

  module Builtins
    VALIDATE_ARGS = lambda { |opts, allowed_opts|
      opts.each do |k, v|
        unless allowed_opts.keys.include? k
          raise InvalidOption "No such option #{k}"
        end

        if v && !["?", 1].include?(allowed_opts[k])
          raise InvalidOption "#{k} does not accept an argument"
        end
      end
    }
    def builtin(name, allowed_opts=nil)
      self.send(:define_method, name) do |*args|
        opts = case args[-1]
               when Hash
                 args.pop
               else
                 {}
               end

        VALIDATE_ARGS.call(opts, allowed_opts) if allowed_opts

        stub = CmdStub.new(@cmd_buffer)

        cmd = name.to_s
        cmd << " #{__process_opts(opts)}" unless opts.empty?
        cmd << " #{__process_args(args)}"  unless args.empty?
        @cmd_buffer << cmd
        stub
      end
    end
  end
end
