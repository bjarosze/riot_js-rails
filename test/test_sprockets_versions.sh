#!/bin/bash

echo -n "
This script test 'riot_js-rails' gem in various environments, especially
with various versions of 'sprockets'. To do that, it requires 'rvm' and
'phantomjs'. It automatically installs several versions of 'ruby's using
'rvm', installs required gems into a temporary gemset named as
'TestSprocketsVersions', builds a sample rails application in
'riot_js-rails/test/Test/TestSprocketsVersions' and checks the
test result with 'phantomjs'. Since it works more or less violently,
you are warned to check what it indeed does before proceed.

Do you want to start the test? (yes/no) : "

read ANSWER

case $ANSWER in
  yes)
      ;;
  *)
      echo "Canceled."
      return 2>/dev/null
      exit 1
      ;;
 esac

##########################################################

source ~/.rvm/scripts/rvm

##########################################################

TESTNAME=TestSprocketsVersions

cleanup() {
  cd $WORKING_DIR
  rm -r $TESTNAME
  rvm --force gemset delete $TESTNAME
}

prepare4ruby() {
  rvm install $1
  rvm use $1
  rvm gemset create $TESTNAME
  rvm use $1@$TESTNAME
  gem uninstall --all --force --executables
}

prepare4rails() {
  gem install rails -N -v $1
  # to avoid "Could not find proper version of railties" error
  ruby `which rails` _${1}_ new $TESTNAME $2
  cd $TESTNAME
  echo "\
${TESTNAME}::Application.routes.draw do
  root :to => 'main#index'
end
" >config/routes.rb
  rails g controller main index
}

prepare4testapp() {
  bundle install
  mkdir app/assets/javascripts/riot-tags
  echo "\
<test>
  <div>&lt;test&gt; tag is working.</div>
</test>
" >app/assets/javascripts/riot-tags/test.js.tag
  echo '
%haml-test
  %div
    &="<haml-test> tag is working."
' >app/assets/javascripts/riot-tags/haml-test.js.tag.haml
  echo '
slim-test
  div
    | &lt;slim-test&gt; tag is working.
' >app/assets/javascripts/riot-tags/slim-test.js.tag.slim
  echo '
<test data-riot></test>
<haml-test data-riot></haml-test>
<slim-test data-riot></slim-test>
' >app/views/main/index.html.erb
  echo "\
//= require jquery
//= require jquery_ujs
//= require riot
//= require riot_rails
//= require_tree .
" >app/assets/javascripts/application.js
}

runtest() {
  rails s &
  sleep 10
  echo '
  (function(){

    var page = require("webpage").create();
    page.viewportSize = {width: 1024, height: 768};

    page.onConsoleMessage = function(msg) {
      console.log(msg);
    };

    page.open("http://localhost:3000/", function(status) {
      if (status === "success") {
        var error = null;
        page.evaluate(function() {
          var expected = "<test> tag is working.\n" +
                         "<haml-test> tag is working.\n" +
                         "<slim-test> tag is working.";
          var result = document.body.innerText.trim();
  	      if(result != expected){
  	        error = "Failed!\nresult:\n" + result + "\n";
  	      }
        });
        if(error) {
          console.log(error);
          phantom.exit(1);
        }else {
          console.log("Success!");
          phantom.exit(0);
        }
      } else {
        phantom.exit(1);
      }
    });

  })();
' > phantom-test.js

  phantomjs phantom-test.js
  RESULT=$?

  rm phantom-test.js

  if [ $RESULT -eq 0 ]; then
    RESULT_S="SUCCESS"
  else
    RESULT_S="FAIL"
  fi

  echo $RESULT_S "|" \
       `rails -v | sed -e 's/.* //' -e 's/$//'` "|" \
       `gem query sprockets|sed -n 's/^sprockets .\(.*\).$/\1/p'` "|" \
       `ruby -v | sed -e "s/ruby //g" -e "s/ .*//"` >> ../result.log

  kill -kill `cat tmp/pids/server.pid`

  return $RESULT
}

############################################

test_rails3.1() {
  prepare4ruby $1
  prepare4rails 3.1.12

  rm public/index.html
  # rails s # to confirm rails app works fine without riot_js-rails

  echo "
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >>Gemfile

  prepare4testapp
  runtest
  cleanup
}

test_rails3.2() {
  prepare4ruby $1
  prepare4rails 3.2.11

  rm public/index.html
  # rails s # to confirm rails app works fine without riot_js-rails

  echo "
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >>Gemfile

  prepare4testapp
  runtest
  cleanup
}

test_rails4.0.4() {
  prepare4ruby $1
  prepare4rails 4.0.4
  echo "
source 'https://rubygems.org'
gem 'rails', '4.0.4'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0'
gem 'coffee-rails', '~> 4.0'
gem 'jquery-rails'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >Gemfile

  prepare4testapp
  runtest
  cleanup
}

test_rails4.0.13() {
  prepare4ruby $1
  prepare4rails 4.0.13
  echo "
source 'https://rubygems.org'
gem 'rails', '4.0.13'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.2'
gem 'coffee-rails', '~> 4.0'
gem 'jquery-rails'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >Gemfile

  prepare4testapp
  runtest
  cleanup
}

test_rails4.1() {
  prepare4ruby $1
  prepare4rails 4.1.16
  echo "
source 'https://rubygems.org'
gem 'rails', '4.1.16'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.3'
gem 'coffee-rails', '~> 4.0'
gem 'jquery-rails'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >Gemfile

  prepare4testapp
  runtest
  cleanup
}

test_rails4.2() {
  prepare4ruby $1
  prepare4rails 4.2.7.1
  echo "
source 'https://rubygems.org'
gem 'rails', '4.2.7.1'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1'
gem 'jquery-rails'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >Gemfile

  prepare4testapp
  runtest
  cleanup
}

test_rails5.0() {
  prepare4ruby $1
  prepare4rails 5.0.0.1 --skip-spring
  echo "
source 'https://rubygems.org'
gem 'rails', '5.0.0.1'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'listen', '~> 3.0.5'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'slim'
gem 'riot_js-rails', :path => '../..'
" >Gemfile

  prepare4testapp
  runtest
  cleanup
}

pushd $(dirname ${BASH_SOURCE:-$0})
WORKING_DIR=`pwd`
echo "Working dir: " $WORKING_DIR

# i18n requires Ruby version >= 1.9.3.

echo "

result|rails|sprockets|ruby" >> result.log
echo "----|----|----|----" >> result.log

test_rails3.1 1.9.3-p551
test_rails3.1 2.0.0-p648
test_rails3.1 2.1.10
test_rails3.1 2.2.5
test_rails3.1 2.3.1

test_rails3.2 1.9.3-p551
test_rails3.2 2.0.0-p648
test_rails3.2 2.1.10
test_rails3.2 2.2.5
test_rails3.2 2.3.1

test_rails4.0.4 1.9.3-p551
test_rails4.0.4 2.0.0-p648
test_rails4.0.4 2.1.10
test_rails4.0.4 2.2.5
test_rails4.0.4 2.3.1

test_rails4.0.13 2.0.0-p648
test_rails4.0.13 2.1.10
test_rails4.0.13 2.2.5
test_rails4.0.13 2.3.1

test_rails4.1 1.9.3-p551
test_rails4.1 2.0.0-p648
test_rails4.1 2.1.10
test_rails4.1 2.2.5
test_rails4.1 2.3.1

test_rails4.2 1.9.3-p551
test_rails4.2 2.0.0-p648
test_rails4.2 2.1.10
test_rails4.2 2.2.5
test_rails4.2 2.3.1

test_rails5.0 2.3.1

echo "

"
cat result.log
# rm result.log

popd
