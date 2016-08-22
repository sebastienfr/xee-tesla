#Xee-Tesla
[![Build Status](https://travis-ci.org/sebastienfr/xee-tesla.svg?branch=master)](https://travis-ci.org/sebastienfr/xee-tesla)
[![GoDoc](https://godoc.org/github.com/sebastienfr/xee-tesla?status.svg)](https://godoc.org/github.com/sebastienfr/xee-tesla)
[![Software License](http://img.shields.io/badge/license-APACHE2-blue.svg)](https://github.com/sebastienfr/xee-tesla/blob/master/LICENSE)

This project is a bridge from the Tesla API to Xee. It retrieves a Tesla car signals to push them to the Xee backend.
Once done, your Tesla data will be available on your Xee app and all it's services.

## Technical stack

* [Docker](https://www.docker.com)
* [MongoDB NoSQL database](https://www.mongodb.com)
* [Go is the language](https://golang.org)
* [Gorilla Mux the URL router](https://github.com/gorilla/mux)
* [Gorilla Mux the request context manager](https://github.com/gorilla/context)
* [Urfave negroni Web HTTP middleware](https://github.com/urfave/negroni)
* [Urfave cli the command line client parser](https://github.com/urfave/cli)
* [Sirupsen the logger](https://github.com/Sirupsen/logrus)
* [The database driver](https://gopkg.in/mgo.v2)
* [Godep the dependency manager](https://github.com/tools/godep)
* [Golint the source linter](https://github.com/golang/lint/golint)

## Build

```shell
make help
```
