module PosixProxy
  module Builtins
    def builtin(name)
      self.send(:define_method, name) do |*args|
        opts = case args[-1]
               when Hash
                 args.pop
               else
                 {}
               end

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
