# Makefile for xee-tesla :
# -----------------------------------------------------------------
#
#        ENV VARIABLE
#
# -----------------------------------------------------------------

# go env vars
GO=$(firstword $(subst :, ,$(GOPATH)))
# list of pkgs for the project without vendor
PKGS=$(shell go list ./... | grep -v /vendor/)
DOCKER_IP=$(shell if [ -z "$(DOCKER_MACHINE_NAME)" ]; then echo 'localhost'; else docker-machine ip $(DOCKER_MACHINE_NAME); fi)
export GO15VENDOREXPERIMENT=1


# -----------------------------------------------------------------
#        Version
# -----------------------------------------------------------------

# version
VERSION=0.0.1
BUILDDATE=$(shell date -u '+%s')
BUILDHASH=$(shell git rev-parse --short HEAD)
VERSION_FLAG=-ldflags "-X main.Version=$(VERSION) -X main.GitHash=$(BUILDHASH) -X main.BuildStmp=$(BUILDDATE)"

# -----------------------------------------------------------------
#        Main targets
# -----------------------------------------------------------------

help:
	@echo
	@echo "----- BUILD ------------------------------------------------------------------------------"
	@echo "all                  clean and build the project"
	@echo "clean                clean the project"
	@echo "dependencies         download the dependencies"
	@echo "build                build all libraries and binaries"
	@echo "----- TESTS && LINT ----------------------------------------------------------------------"
	@echo "test                 test all packages"
	@echo "format               format all packages"
	@echo "lint                 lint all packages"
	@echo "----- SERVERS AND DEPLOYMENTS ------------------------------------------------------------"
	@echo "start                start process on localhost"
	@echo "stop                 stop all process on localhost"
	@echo "dockerBuild          build the docker image"
	@echo "dockerClean          remove latest image"
	@echo "dockerUp             start microservice infrastructure on docker"
	@echo "dockerStop           stop microservice infrastructure on docker"
	@echo "dockerBuildUp        stop, build and start microservice infrastructure on docker"
	@echo "dockerWatch          starts a watch of docker ps command"
	@echo "dockerLogs           show logs of microservice infrastructure on docker"
	@echo "----- OTHERS -----------------------------------------------------------------------------"
	@echo "help                 print this message"

all: clean build

clean:
	@go clean
	@rm -Rf .tmp
	@rm -Rf .DS_Store
	@rm -Rf *.log
	@rm -Rf *.out
	@rm -Rf *.lock
	@rm -Rf *.mem
	@rm -Rf *.test
	@rm -Rf build

build: format
	@go build -v $(VERSION_FLAG) -o $(GO)/bin/xee-tesla xee-tesla.go

format:
	@go fmt $(PKGS)

test:
	@go test -v $(PKGS)

lint:
	@golint dao/...
	@golint model/...
	@golint web/...
	@golint utils/...
	@golint ./.
	@go vet $(PKGS)

start:
	@xee-tesla -port 8020 -logl debug -logf text

stop:
	@killall xee-tesla

# -----------------------------------------------------------------
#        Docker targets
# -----------------------------------------------------------------

dockerBuild:
	docker build -t sebastienfr/xee-tesla:latest .

dockerClean:
	docker rmi -f sebastienfr/xee-tesla:latest

dockerUp:
	docker-compose up -d

dockerStop:
	docker-compose stop
	docker-compose kill
	docker-compose rm

dockerBuildUp: dockerStop dockerBuild dockerUp

dockerWatch:
	@watch -n1 'docker ps | grep xee-tesla'

dockerLogs:
	docker-compose logs -f

.PHONY: all test clean
