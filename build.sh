#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
bundle exec jekyll build

# cleanup
rm -rf ../master

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/sikoried/sikoried.github.io.git \
	--branch master --single-branch \
	../master

# copy generated HTML site to `master' branch
echo "Updating static _site content..."
rm -r ../master/*
cp -R _site/* ../master/

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../master

echo "Committing changes to master..."
git config --global user.email "korbinianr@gmail.com"
git config --global user.name "Korbinian Riedhammer"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push origin master # > /dev/null 2>&1
