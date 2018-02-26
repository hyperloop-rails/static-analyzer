#!/bin/bash

path=$PWD
analyzer_path=$1


g++ extract_ruby.cpp -o extract_ruby

#generate all action entrance calls
bundle exec rake routes | tail -n +2 | awk '{ for (i=1;i<=NF;i++) if (match($i, /.#./)) print $i}' | sed -e 's/#/,/g' | sort | uniq &> calls.txt

#replace view code
ruby main.rb -p $path

cp db/schema.rb  $analyzer_path
#copy to analyzer folder
cp -r app/merged_controllers/ $analyzer_path
cp -r app/merged_helpers/ $analyzer_path
cp -r app/models $analyzer_path
