#!/bin/bash

RVM=`rvm list rubies | grep -c 1.9.3`

if [ "$RVM" != "1" ]; then
   \curl -L https://get.rvm.io | bash -s stable --ruby
 else
   echo "rvm 1.9.3 instaliran"
fi

source /etc/profile.d/rvm.sh

bundle install
bundle exec librarian-chef install
bundle exec librarian-chef update
