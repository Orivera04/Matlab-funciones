Name:   kdtree
Author: Steven Michael (smichael@ll.mit.edu)
Date:   3/1/2005

############################################################

The following code implements a KDTree search algorithm
in MATLAB

There are 4 main functions:

1. kdtree              -- tree class creation
2. kdtree_range        -- return all points within a range
3. kdtree_closestpoint -- return array of closest points to a 
                          corresponding array of input points


A single reference was used in writing the code:

M. deBerg, M. vanKreveld, M. Overmars, and O. Schwarzkopf.
"Computational Geometry: Algorithms and Applications"
Springer, 2000.

############################################################

Compilation:

The base distribution includes binary MATLAB functions for Linux and
Windows.  The functions were compiled with Matlab R14.  I have not
tried them with other versions, but they should work.  The Windows
compiler used is MS Visual Studio.NET 2003 (v7.1).  The linux compiler
is gcc version 2.96 (RedHat Linux 7.3).

The directory structure is as follows:

$(KDTREE)/src:
  The source code

$(KDTREE)/kdtree_create
  Visual Studio project for the kdtree function

$(KDTREE)/kdtree_range
  Visual Studio project for the kdtree_range function

$(KDTREE)/kdtree_closespoint
  Visual Studio project for the kdtree_closestpoint function

The windows projects are all included in the Visual Studio "Solution"
file "kdtree.sln" in the main directory.


To compile in Linux, simply type "make" in the base directory.
Some variables may need to be changed in the Makefile depending
upon MATLAB version and C++ compiler.

############################################################
 
Example Usage:

The following matlab code creates a 3-D tree.
It does a search for the point nearest to [1,1,1],
then a range search for all the points within the cube bounded
by the interval: .45<x<.55,.45<y<.55,.45<z<.55

>> r = rand(1000,3);
>> tree = kdtree(r)

tree =

        kdtree object: 1-by-1

>> kdtree_closestpoint(tree,[1 1 1])

ans =

    68

>> r(68,:)

ans =

    0.9112    0.9920    0.8940

>> kdtree_range(tree,[[.45 .55];[.45 .55];[.45 .55]])

ans =

   594   508

>> r(594,:)

ans =

    0.4678    0.5230    0.5023

>> r(508,:)

ans =

    0.4917    0.5341    0.5060

>>         

########################################################

Changes:

11/8/05
Switch from quicksort to heapsort in the tree creation 
and allow for searches of multiple range volumes with
a single "kdtree_range" call
6/15/05
Make the tree serealizable and store the result in a 
MATLAB variable.  This allows the tree to be saved 
in a MATLAB file and recalled quickly. It also gets
rid of having the tree be stored as a pointer, which 
was certainly not ideal.
4/5/05
Make the checking of boundary points work with distance
  squared (much faster)
Compiled Linux versions are done with the Intel 
  compiler (also much faster)
