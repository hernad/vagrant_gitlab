#!/bin/bash

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

RVM=`rvm list rubies | grep -c 1.9.3`

if [ "$RVM" != "1" ]; then
   apt-get install -y ruby-rvm
   rvm install 1.9.3-p286
   #\curl -L https://get.rvm.io | bash -s stable --ruby
 else
   echo "rvm 1.9.3 instaliran"
fi

# provjeri da li ima rvm-a
`which rvm`
ret=$?

set_rvm

bundle install
bundle exec librarian-chef install
bundle exec librarian-chef update


chef-solo -c solo.rb -j node.json
