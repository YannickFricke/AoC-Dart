.PHONY: clear
clear:
	@cls || clear

.PHONY: run
run:
	dart run ./bin/advent_of_code.dart

.PHONY: watch
watch:
	bunx nodemon -w ./bin/ -w ./lib/ -w ./inputs/ -e dart,txt -x "make clear run || exit 1"

.PHONY: test
test:
	dart test

.PHONY: watch
watch-tests:
	bunx nodemon -w ./bin/ -w ./lib/ -w ./test/ -w ./inputs/ -e dart,txt -x "make clear test || exit 1"
