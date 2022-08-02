function des = setdatapoint(des, idx, isdata)
%SETDATAPOINT Mark design points as taken data
%
%  DES = SETDATAPOINT(DES, IDX) marks the design points indicated by the
%  index IDX as being "data points".  This means that the data has been
%  taken and the points should not be edited or removed.  Data points
%  contribute to the list of fixed points returned by the methods FIXPOINTS
%  and FREEPOINTS, but cannot be unfixed using the user-fixed points
%  interface.
%  IDX can be either a vector of design point indices or a logical vector
%  the same length as the design.
%
%  OUT = SETDATAPOINT(DES, IDX, ISDATA) specifies whether the indicated
%  points should be marked (ISDATA=true) or unmarked (ISDATA=false). 


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:07:41 $ 

if nargin<3
    isdata = true;
end

flags = pGetFlags(des, 'DATA');
flags(idx) = isdata;
des = pSetFlags(des, 'DATA', flags);
