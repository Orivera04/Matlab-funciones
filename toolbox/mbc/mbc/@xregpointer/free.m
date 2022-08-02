function varargout = free(p)
%FREE Frees heap which p points to
%
%  FREE(P) releases the memory that P is pointint to.  Note that freeptr
%  is called on P.info as a destructor.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:47:09 $

s = dbstack;
if length(s)>1
	fprintf('FREE: %s (%d) \n',s(2).name,s(2).line)
else
    disp('FREE: Base Workspace')
end

if p.ptr~=0
    % call free for pointer info
    % there is a blank free classless function
    HeapManager(5,p.ptr);
    if nargout
        p.ptr = 0;
        varargout{1} = p;
    end
end
