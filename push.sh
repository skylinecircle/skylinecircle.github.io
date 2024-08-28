#!/bin/bash
bundle exec jekyll build
git add . --all
git commit -m "upd"
git push origin master
cd _site/
git add . --all
git commit -m "up"
git push origin master
cd ../
