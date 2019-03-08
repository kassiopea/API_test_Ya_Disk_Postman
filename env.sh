#!/bin/sh

#install nodejs
sudo apt install nodejs

#install npm
sudo apt install npm

#install dependencies in pacage.json
npm init

#install newman reporter html
sudo npm install -g newman-reporter-html

#install snap
sudo install snap

#install Postman
sudo snap install postman
