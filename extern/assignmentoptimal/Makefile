# Makefile for building MEX files from C and CPP sources.

# Extract architecture, compiler, etc. from MEX configuration.
MEX         = $(shell { command -v mexsh || command -v mex ; } 2>/dev/null ) 
MEXENV      = $(MEX) -v 2> /dev/null
MEXOPTSFILE = $(strip $(shell $(MEXENV) | grep "^ *FILE *=" | cut -d = -f 2-))
MEXSUFFIX   = $(strip $(shell $(MEXENV) | \
		grep "^ *LDEXTENSION *=" | cut -d = -f 2- | cut -d . -f 2))
CXX         = $(strip $(shell $(MEXENV) | grep "\-> *CXX *=" | cut -d = -f 2-))
CC          = $(strip $(shell $(MEXENV) | grep "\-> *CC *=" | cut -d = -f 2-))
MATLABHOME  = $(strip $(shell $(MEXENV) | \
		grep "\-> *MATLAB *=" | cut -d = -f 2-))

CFLAGS     = -fPIC -ansi -pthread -DMX_COMPAT_32 -DMATLAB_MEX_FILE
#LIBS      = -lm
#INCLUDE   = -I$(MATLABHOME)/extern/include
MEXFLAGS  = -compatibleArrayDims  # For now build for arrays of size 2^32-1.

%.$(MEXSUFFIX): %.c
	$(MEX) $(MEXFLAGS) $(LIBS) $^

%.$(MEXSUFFIX): %.cpp
	$(MEX) $(MEXFLAGS) $^

all: assignmentoptimal.$(MEXSUFFIX)

showvars:
	@echo "$(MEXSUFFIX)"
	@echo "$(MEXOPTSFILE)"
	@echo "$(CC)"
	@echo "$(CXX)"
	@echo "$(MATLABHOME)"

clean:
	rm -f *.$(MEXSUFFIX) *.o
