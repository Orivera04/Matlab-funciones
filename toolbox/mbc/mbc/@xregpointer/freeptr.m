function varargout = freeptr(p)
%FREEPTR Frees heap which p points to
%
%  FREEPTR(P) releases the memory that P is pointint to.  Note that freeptr
%  is called on P.info as a destructor.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:47:10 $

if all(p.ptr~=0)
    % call free for pointer info
    % there is a blank free classless function
    HeapManager(5,p.ptr);
    if nargout
        p.ptr=0;
        varargout{1}=p;
    end
end