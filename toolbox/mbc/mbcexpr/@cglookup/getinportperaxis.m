function pInp = getinportperaxis(obj)
%GETINPORTPERAXIS Return the inport for each axis of the table
%
%  PINP = GETINPORTPERAXIS(OBJ) returns a pointer vector containing the
%  input for each axis of the table, in the same order as the table
%  dimensions are specified.  If the table does not have a single inport
%  per axis, an empty vector is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:20 $

pInp = getinputs(obj);

if any(isnull(pInp))
    pInp = null(xregpointer,0);
    return
end

hNorms = infoarray(pInp);
for n = 1:length(pInp)
    pSrc = getinports(hNorms{n});
    if length(pSrc)~=1 || isnull(pSrc)
        pInp = null(xregpointer,0);
        break
    else
        pInp(n) = pSrc;
    end
end
