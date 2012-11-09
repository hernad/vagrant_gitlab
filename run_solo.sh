#!/bin/bash

RVM=`rvm list rubies | grep -c 1.9.3`

if [ "$RVM" != "1" ]; then
   \curl -L https://get.rvm.io | bash -s stable --ruby
 else
   echo "rvm 1.9.3 instaliran"
fi

# provjeri da li ima rvm-a
`which rvm | wc -l | xargs test 1 -eq`
# ako je exit code 0, onda je wc -l vratio jedan element
ret=$?

if [[ $ret -eq 0 ]]; then
  echo "rvm je u path-u"
else
  source /etc/profile.d/rvm.sh
fi

bundle install
bundle exec librarian-chef install
bundle exec librarian-chef update


chef-solo -c solo.rb -j node.json
