#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
jekyll build

# cleanup
rm -rf ../sikoried.github.io.gh-pages

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/sikoried/sikoried.github.io.git \
	--branch gh-pages --single-branch \
	../sikoried.github.io.gh-pages

# copy generated HTML site to `master' branch
rm -r ../sikoried.github.io.gh-pages/_site
cp -R _site/* ../sikoried.github.io.gh-pages

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../sikoried.github.io.gh-pages
git config user.email "korbinianr@gmail.com"
git config user.name "Korbinian Riedhammer"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1