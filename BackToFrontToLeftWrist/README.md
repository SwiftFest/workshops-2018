# Back to Front to Left Wrist
In this workshop, we'll explore the power of full stack Swift. We'll build a
server using the Perfect framework to be able to download data into an iOS app
which we'll use to feed data to a watchOS app.

## Requirements
If you'd like to code a long with this workshop, you'll want to make sure that
your Mac has **High Sierra** installed on it and that you're also running **Xcode 9.4.***

You will also need to install a couple of dependencies (**Homebrew, PostgreSQL, and libxml2**). Instructions for installing the dependencies can be found in [Getting Started](#getting-started).

If you do not want to have these packages installed on your computer, or you don't want to upgrade your Mac, you're still more than welcome to the workshop. However, you will not be able to code along, because the above dependencies are required to run the server.

## Project Structure
This repository has 2 branches, **workshop** and **master**. The workshop branch will be used during the workshop in order to build the code in master. The master branch is the completed project. If you wish to code along, please either **clone or download the workshop** branch.

_**NOTE:** The different branches are available at https://github.com/mdiasdev/SwiftFestWorkshop_

Inside this repo, you should have App and Server directories. The App directory contains everything used for creating the iOS and watchOS apps. The Server directory includes the code for the server, but **requires you run the setup below** to generate the Xcode project file.

## Getting Started
Once you've either downloaded or cloned this repo, you'll need to navigate to the code in a terminal:
```
cd Path/To/Download
```
In that directory, you should find a file, `setup.sh`. If you execute this script, it will install Homebrew (if not already installed), install libxml2, install Postgres, start the database connection, and use Swift Package Manager to install the Perfect framework. To run the script execute the following command from the project directory (where you just navigated to):
```
./setup.sh
```
If everything was installed correctly, you should see `SwiftFestServer.xcodeproj` in the **Server** directory and be able to build/run.

If you see errors during the setup script, and the project doesn't build, you can follow the setup steps individually. The individual steps can be found in [the server's readme](Server/README.md).
