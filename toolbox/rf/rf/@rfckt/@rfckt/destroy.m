function h = destroy(h,destroyData)
%DESTROY Destroy this object

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:31 $

% Delete objects associated with this object
if isa(h.RFdata,'rfdata.data')
    delete(h.RFdata);
end
