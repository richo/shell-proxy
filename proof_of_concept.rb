require './shell_proxy'

ShellProxy.new.__main__ do
  cd "Somedir"

  touch "somefile"
  mkdir "foo/bar/thing", { :p => nil }

  rm "foo",  { :r => nil, :f => nil }
end
