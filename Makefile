#
#	hiredis-ada
#

GPRBUILD=gprbuild
GPRCLEAN=gprclean
TESTRUNNER=textrunner


debug: pre
	$(GPRBUILD) -p redis.gpr -Xmode=debug

release: pre
	$(GPRBUILD) -p redis.gpr -Xmode=release

pre:
	mkdir -p build
	mkdir -p obj/tests

syntax: pre
	gnatmake -gnatc -gnat12 -P redis.gpr

test: pre debug
	sh tests/build.sh
	sh tests/run.sh

clean: pre
	$(GPRCLEAN) redis.gpr
	$(MAKE) -C hiredis clean
	rm -rf build obj
	rm -f *.so* *.ali*

