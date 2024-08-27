#!/bin/bash
bundle exec jekyll build
git add .
git commit -m "upd"
git push origin master
cd _site/
git add .
git commit -m "up"
git push origin master
cd ../
