function h = destroy(h,destroyData)
%DESTROY Destroy this object

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:12 $

% Delete objects associated with this object
if isa(h.Reference,'rfdata.reference')
    delete(h.Reference);
end
