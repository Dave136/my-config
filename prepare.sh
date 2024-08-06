#!/bin/bash

rm -rf config.zip fonts.zip backup

zip -e -r config.zip config
zip -r -q fonts.zip fonts

mkdir backup

mv config.zip fonts.zip backup

files=$(find . -type f -regex '.*\json$')

if [ -n "$files" ]; then
  cp $files backup
fi