# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOGET=$(GOCMD) get

all: build-linux build-windows
	
clean: 
		$(GOCLEAN)
		rm ./bin/*
run:
		$(GOBUILD) -o $(BINARY_NAME) -v ./...
		./$(BINARY_NAME)
deps:
		$(GOGET) github.com/username/<xx>
init:
	mkdir bin

# Cross compilation
build-linux: init
		CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o asn1 a1.go
		mv asn1 ./bin/
build-windows: init
		GOOS=windows GOARCH=386 $(GOBUILD) -o asn1.exe a1.go
		mv asn1.exe ./bin/
