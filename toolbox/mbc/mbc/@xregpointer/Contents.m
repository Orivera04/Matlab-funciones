% xregPointer Class
% 
% Allocating Memory on the Heap
%    p= xregpointer;   returns a null pointer
%    p= xregpointer(newinfo)  allocates a new location on the heap and places newinfo in
%                  that place.
%    p= new(xregpointer,info) will allocate a new location on the heap
%
% Pointer Array
%   horzcat,vertcat,indexing,end,size,length    all work in the same way as 
%             double arrays in MATLAB
%   ==,~=     pointers can be compared to other pointers and also to 0 (null pointer)
%   unique    returns a list of unique elements of the pointer array
%   display   to distinguish a pointer array at the command line the variable name is 
%              preceded by an & 
%
%
% Accessing and Operating on Heap Data
%   p.info          gets the information from the location of that point
%   p.info= newinfo places the variable newinfo on the heap at the 
%                   location of p. If p is a pointer array you can index 
%                   into this array before dereferencing (e.g. p(ind).info
%
%   info(p)         returns the information contained in the pointer array as 
%                   a cell array of the same size if the array is larger than one.
%
%   Res= p.funcname(varargin) runs the MATLAB function 'funcname' on p.info with out the 
%                   need to explicitly dereference the pointer. This is shorthand for
%                   Res= funcname(p.info,varagin);  Due to the way sub-referencing works 
%                   in MATLAB this form can only work with one output.
%   [varargout]= peval(funcname, p,varargin) is a more general command which allows 
%                   more than one output.
%
% Manipulating the Heap
%    free(p)      frees the location specified by p
%    assign(p,d)  assign a pointer to point to location d
%    d=double(p)  return a double array of pointer indices
%    release(p)   frees the entire heap
%    s= SaveHeap(p) returns the entire heap as a structure for saving
%                     s.MVHEAP contains the heap cell array.
%                     s.USED_HEAP contains the used locations on the heap
%    LoadHeap(p,s)  loads the structure s, as returned by SaveHeap onto the heap
%                   The old heap is overwritten with this command.
%    p=mapptr(p,{OldRefs,NewRefs})  maps pointers from OldRefs list to NewRefs list. 
%                   This functions is a more general way of loading pointers from a MAT file
%                   to the heap than SaveHeap/LoadHeap
%    isvalid(p)     checks p points to an allocated location on the heap
%    q= copy(p {,info}); copies info to new location on heap 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:46:53 $





