Shell proxy.
============

Totes leeb.

Inputs:

```ruby
require './lib/shell-proxy'

class ShellProxy
  case ARGV[0]
  when "PosixProxy"
    include PosixProxy
  when "VimProxy"
    include VimProxy
  else
    raise "usage #{$0}: <PosixProxy|VimProxy>"
  end
end

ShellProxy.new.__main__ do
  cd "Somedir"

  __function("Butts_function") do
    touch "butts"
  end

  __call("Butts_function", raw("rawr"))

  __function("ArgumentTakingFunction", 3) do
    echo args[1]
    echo args[2]
    echo args[3]
  end

  __call("ArgumentTakingFunction", raw("rawr"), raw("butts"), raw("lol"))

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

  __set("foo", bare("$RANDOM"))

  __case(raw("$foo")) do |c|
    c.when(10000) do
      echo "holy shit, did not expect that"
    end
    c.else do
      echo "Welp, that was predictable"
    end
  end

  if ARGV[0] != "VimProxy"

  some | thing | some | other | thing

  __for(bare("foo bar baz"), "i") do
    echo raw("$i")
  end

  rm "foo",  { :r => nil, :f => nil }
  mongod({ :config => "/usr/local/etc/mongod.conf" })

  __if(cmp(raw("$foo"), String).eq('foo')) do |c|
    c.then do
      echo "it was true"
    end
    c.elseif(cmp(raw("bar"), String).eq('bar')) do
      echo "this is definitely true"
    end
    c.else do
      echo "This wont be reached"
    end
  end
  end
end
```

When invoked with `PosixProxy`, outputs:

```bash
cd 'Somedir'
Butts_function() {
  touch 'butts'
}
Butts_function "rawr"
ArgumentTakingFunction() {
  echo "$1"
  echo "$2"
  echo "$3"
}
ArgumentTakingFunction "rawr" "butts" "lol"
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
some | thing | some | other | thing
for i in foo bar baz; do
  echo "$i"
done
rm '-r' '-f' 'foo'
mongod '--config' '/usr/local/etc/mongod.conf'
if [ "$foo" = 'foo' ]
then
  echo 'it was true'
else if [ "bar" = 'bar' ]
  echo 'this is definitely true'
else
  echo 'This wont be reached'
fi
```

Or if invoked with VimProxy, outputs:

```VimL
cd Somedir
function! Butts_function()
  !touch butts
endfunction
call Butts_function(rawr)
function! ArgumentTakingFunction(arg1, arg2, arg3)
  echo a:arg1
  echo a:arg2
  echo a:arg3
endfunction
call ArgumentTakingFunction(rawr, butts, lol)
" subshell currently not implemented
let __here="cd " . getcwd()
cd /tmp
  !touch rawr
exec __here
let foo=$RANDOM
let l:__case = $foo
  if l:__case == 10000
    echo holy shit, did not expect that
  elseif l:__case == *
    echo Welp, that was predictable
endif
```
