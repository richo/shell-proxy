require './shell_proxy'

ShellProxy.new.__main__ do
  cd "Somedir"

  __subshell do
    touch "somefile"
    mkdir "foo/bar/thing", { :p => nil }
  end

  __chdir "/tmp" do
    touch "rawr"
  end

  rm "foo",  { :r => nil, :f => nil }
  mongod({ :config => "/usr/local/etc/mongod.conf" })
end
