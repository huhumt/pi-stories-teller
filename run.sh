#!/usr/bin/bash

python ./src/main.py import http://www.ximalaya.com/album/257813.xml
python ./src/main.py update
python ./src/main.py download
