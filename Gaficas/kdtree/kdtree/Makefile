# This will have to be changed according to your MATLAB 
# directory
MATDIR = /usr/local/matlab14

# These may have to be changed depeing on the MATLAB version
# Older versions of matlab may have:
# LIBDIR = -L$(MATDIR)/extern/glnx86
INCDIR = -Isrc -I$(MATDIR)/extern/include
LIBDIR = -L$(MATDIR)/bin/glnx86
LIBS = -lmat -lmex -lmx -lm

# The c++ compiler and flags to use
CXX = /usr/local/gcc-3.2.3/bin/g++
CXXFLAGS = -Wall -O3 -fomit-frame-pointer -march=pentium4 -msse -msse2 -ffast-math 
#CXX = icpc
#CXXFLAGS = -gcc-version=320 -cxxlib-gcc=/usr/local/gcc-3.2.3 -O3 -xN

################################################################
# No changes should need to be made below this line

TARGETS = kdtree kdtree_closestpoint kdtree_range
COMMON = kdtree.cpp


all : $(patsubst %,kdtree/%.mexglx,$(TARGETS))

kdtree/kdtree.mexglx : kdtree_create.o $(patsubst %.cpp,%.o,$(COMMON))
	ln -s @kdtree kdtree
	$(CXX) $(CXXFLAGS) $(LIBDIR) $(LIBS) -shared $^ -o $@
	rm kdtree

kdtree/%.mexglx : %.o $(patsubst %.cpp,%.o,$(COMMON))
	ln -s @kdtree kdtree
	$(CXX) $(CXXFLAGS) $(LIBDIR) $(LIBS) -shared $^ -o $@
	rm kdtree

%.o : src/%.cpp src/%.h
	$(CXX) $(CXXFLAGS) $(INCDIR) -c $< -o $@

%.o : src/%.cpp 
	$(CXX) $(CXXFLAGS) $(INCDIR) -c $< -o $@

clean : 
	rm -rf $(patsubst %,@kdtree/%.mexglx,$(TARGETS)) \
	$(patsubst %.cpp,%.o,$(COMMON)) $(patsubst %,%.o,$(TARGETS))
