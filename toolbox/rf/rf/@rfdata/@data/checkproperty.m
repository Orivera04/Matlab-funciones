function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:10 $

% Check the properties
refobj = get(h, 'Reference');
if isa(refobj, 'rfdata.reference')
    checkproperty(refobj);
end
restore(h);
