#
#	hiredis-ada
#

GPRBUILD=gprbuild
GPRCLEAN=gprclean
TESTRUNNER=textrunner


debug: pre hiredis_lib
	$(GPRBUILD) -p hiredis.gpr -Xmode=debug

release: pre hiredis_lib
	$(GPRBUILD) -p hiredis.gpr -Xmode=release

pre:
	mkdir -p build
	mkdir -p obj

hiredis_lib:
	$(MAKE) -C hiredis

syntax: pre
	gnatmake -gnatc -gnat05 -P hiredis.gpr

test: lib
	$(GPRBUILD) -p test/unit.gpr
	./$(TESTRUNNER)

clean: pre
	$(GPRCLEAN) hiredis.gpr
	$(MAKE) -C hiredis clean
	rm -rf build obj
	rm -f *.so*

