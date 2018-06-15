# SwiftFest18 Server

This is the server component for the watchOS Workshop. It is intended to simulate the basic CRUD necessary to mimic a reservation booking system. The server is built totally in Swift using the [Perfect Framework](http://perfect.org).

## Getting Started
If you are not running this on a mac, you'll need to make sure that you have your environment setup to run Swift (see: http://perfect.org/docs/gettingStarted.html). To setup the environment, you'll need to install PostgreSQL via [Homebrew](https://brew.sh/).

```
$ brew install libxml2
$ brew install postgres
$ brew services start postgresql
```
You'll then need to generate the project with Swift Package Manager.
```
$ swift package generate-xcodeproj
```
For the project to actually run, you'll need to setup up your database.
```
$ createuser -D -P perfect              // when prompted for a password, enter: perfect
$ createdb -O perfect swiftfest
```

## Notes
This server is based off of the tutorial provided by [Ray Wenderlich](https://videos.raywenderlich.com/courses/77-server-side-swift-with-perfect). With some help from the [Perfect Examples](https://github.com/PerfectExamples).

It is worth noting that this is not the most organized or thorough codebase. Copy these patterns at your own risk.


---


## Disaster Recovery

If the database breaks during the conference:
```
$ brew services start postgresql      // maybe just restarting it?
$ psql      // tell us what the issues are
$ brew services stop postgresql     // shut down the DB
```

Worst case scenario:
```
$ rm /usr/local/var/postgres/postmaster.pid       // remove the PostgreSQL process
$ rm -rf /usr/local/var/postgres && initdb /usr/local/var/postgres -E utf8       // scorched earth
```
