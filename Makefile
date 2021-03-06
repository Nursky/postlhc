CXXFLAGS += -std=c++11 -g -Wall -Wextra
GSL_LDFLAGS =

-include features.mk

MAKEFILES = \
    Makefile \
    features.mk \

SOURCES = \
    storage.cpp \
    chainrunner.cpp \
    ipl.cpp \
    lj.cpp \
    harddisk.cpp \
    io.cpp \
    paircorrel.cpp \
    tools.cpp \
    jellium3.cpp \
    jellium4.cpp \

MAIN_SOURCES = \
    main.cpp \

OBJECTS = $(SOURCES:%.cpp=%.o)
MAIN_OBJECTS = $(MAIN_SOURCES:%.cpp=%.o)

BINARIES = \
    postlhc \

# default target
all: ts.mk.hpp dep $(BINARIES)
	if [ -x ./push ]; then ./push; else true; fi

# depend on Makefiles
ts.mk.hpp: $(MAKEFILES)
	@touch $@

# create features.mk if absent
features.mk:
	@touch $@

# automagic dependencies
dep: $(OBJECTS) $(MAKEFILES)
	$(CXX) $(CXXFLAGS) -MM $(SOURCES) >.depend
-include .depend

postlhc: main.o $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $< $(OBJECTS) $(GSL_LDFLAGS)

clean:
	rm -f $(BINARIES) $(OBJECTS) $(MAIN_OBJECTS) .depend

.PHONY: all clean dep
