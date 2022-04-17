.PHONY=all test clean
BIN=/usr/local/bin
UNAME=$(shell uname -s)
all: trailx

trailx: trailx.zig
	zig build-exe -O ReleaseSafe trailx.zig

test: trailx.zig trailx_test.zig
	zig test trailx_test.zig

install: trailx
	cp trailx $(BIN)

clean:
	rm -fr zig-cache
	rm trailx	
