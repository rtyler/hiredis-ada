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
	mkdir -p obj/tests
	@echo
	@echo "===> Building redis-shim.ads"
	cpp src/redis-shim.ads.in | tail -n +10 > src/redis-shim.ads
	@echo


syntax: pre
	gnatmake -gnatc -gnat05 -P hiredis.gpr

test: pre debug
	sh tests/build.sh
	sh tests/run.sh

clean: pre
	$(GPRCLEAN) hiredis.gpr
	$(MAKE) -C hiredis clean
	rm -rf build obj
	rm -f *.so* *.ali*

