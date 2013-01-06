Shell proxy.
============

Totes leeb.

Inputs:

```ruby
require './lib/shell-proxy'

ShellProxy.new.__main__ do
  cd "Somedir"

  __subshell do
    __subshell do
      mkdir "borp"
      cd "borp"
      touch "thing"
    end
    touch("somefile")
    mkdir "foo/bar/thing", { :p => nil }
    echo("foo") | wc({:c => nil})
  end

  __chdir "/tmp" do
    touch "rawr"
  end

  rm "foo",  { :r => nil, :f => nil }
  mongod({ :config => "/usr/local/etc/mongod.conf" })
end
```

outputs:

```bash
cd 'Somedir'
(
  (
    mkdir 'borp'
    cd 'borp'
    touch 'thing'
  )
  touch 'somefile'
  mkdir '-p' 'foo/bar/thing'
    echo 'foo' | wc '-c'
)
(
  cd '/tmp'
  touch 'rawr'
)
rm '-r' '-f' 'foo'
mongod '--config' '/usr/local/etc/mongod.conf'
```
