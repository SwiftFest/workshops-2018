#!/bin/bash

echo "Starting Workshop Setup"
echo
echo "*****************************"

which -s brew
if [[ $? != 0 ]] ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew is already installed, checking for updates"
  brew update
fi

echo
echo "*****************************"

which -s libxml2
if [[ $? != 0 ]] ; then
  echo "Installing libxml2"
  brew install libxml2
else
  echo "libxml2 is already installed, checking for updates"
  brew upgrade libxml2
fi

echo
echo "*****************************"
which -s postgres
if [[ $? != 0 ]] ; then
  echo "Installing postgres"
  brew install postgres
else
  echo "postgres is already installed, checking for updates"
  brew upgrade postgres
fi

echo
echo "*****************************"
echo "Starting Postgres"
brew services start postgresql

echo
echo "*****************************"
echo "Generating SwiftFestServer"
command cd Server
swift package generate-xcodeproj
