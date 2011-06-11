#
#	hiredis-ada
#

GPRBUILD=gprbuild
GPRCLEAN=gprclean
TESTRUNNER=textrunner


debug: pre
	$(GPRBUILD) -p hiredis.gpr -Xmode=debug

release: pre
	$(GPRBUILD) -p hiredis.gpr -Xmode=release

pre:
	mkdir -p build
	mkdir -p obj

syntax: pre
	gnatmake -gnatc -gnat05 -P hiredis.gpr

test: debug
	sh tests/run.sh

clean: pre
	$(GPRCLEAN) hiredis.gpr
	$(MAKE) -C hiredis clean
	rm -rf build obj
	rm -f *.so*

