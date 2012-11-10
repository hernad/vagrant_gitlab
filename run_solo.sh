#!/bin/bash

function gem_instaliran {

`gem list --local | grep -q $1`
ret=$?
if [[ $ret -eq 0 ]]; then
  echo "$1 instaliran"
else
  gem install $1 --no-ri --no-rdoc
fi

}


function set_rvm {

# provjeri da li ima rvm-a
`which rvm`
ret=$?
if [[ $ret -eq 0 ]]; then
  echo "rvm je u path-u"
else
  source /etc/profile.d/rvm.sh
fi

}

set_rvm

RVM=`rvm list rubies | grep -c 1.9.3`

if [ "$RVM" != "1" ]; then
   apt-get install -y ruby-rvm
   rvm install 1.9.3-p286
   #\curl -L https://get.rvm.io | bash -s stable --ruby
 else
   echo "rvm 1.9.3 instaliran"
fi

set_rvm

gem_instaliran bundler

bundle install
bundle exec librarian-chef install
bundle exec librarian-chef update

gem_instaliran chef

chef-solo -c solo.rb -j node.json
