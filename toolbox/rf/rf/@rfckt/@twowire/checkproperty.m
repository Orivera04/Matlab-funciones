function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:37:57 $

% Get the property values that need to be checked
radius = get(h, 'Radius');
separation = get(h, 'Separation');

% 2*Radius must be smaller than Separation
if (2*radius) >= separation
     id = sprintf('rf:%s:checkproperty:RadiusSeparation',strrep(class(h),'.',':'));
     error(id, ['Wire diameter must be smaller than wire separation.']); 
end