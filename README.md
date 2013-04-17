Shell proxy.
============

Totes leeb.

Inputs:

```ruby
require './lib/shell-proxy'

ShellProxy.new.__main__ do
  cd "Somedir"

  __function("butts_function") do
    touch "butts"
  end

  __subshell do
    __subshell do
      mkdir "borp"
      cd "borp"
      touch "thing"
    end
    %w[foo bar baz].each do |dir|
      mkdir dir
      touch "#{dir}/#{dir}"
    end
    touch("somefile")
    mkdir "foo/bar/thing", { :p => nil }
    echo("foo") | wc({:c => nil})
  end

  __chdir "/tmp" do
    touch "rawr"
  end

  __eval("foo=$RANDOM")

  __case(raw("$foo")) do |c|
    c.when(10000) do
      echo "holy shit, did not expect that"
    end
    c.when("*") do
      echo "Welp, that was predictable"
    end
  end

  rm "foo",  { :r => nil, :f => nil }
  mongod({ :config => "/usr/local/etc/mongod.conf" })
end
```

outputs:

```bash
cd 'Somedir'
function butts_function() {
  touch 'butts'
}
(
  (
    mkdir 'borp'
    cd 'borp'
    touch 'thing'
  )
  mkdir 'foo'
  touch 'foo/foo'
  mkdir 'bar'
  touch 'bar/bar'
  mkdir 'baz'
  touch 'baz/baz'
  touch 'somefile'
  mkdir '-p' 'foo/bar/thing'
    echo 'foo' | wc '-c'
)
(
  cd '/tmp'
  touch 'rawr'
)
foo=$RANDOM
case "$foo" in
  10000)
    echo 'holy shit, did not expect that'
  ;;
  *)
    echo 'Welp, that was predictable'
  ;;
esac
rm '-r' '-f' 'foo'
mongod '--config' '/usr/local/etc/mongod.conf'
```
