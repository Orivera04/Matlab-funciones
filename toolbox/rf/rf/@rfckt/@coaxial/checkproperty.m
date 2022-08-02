function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:36:21 $

% Get the property values that need to be checked
a = get(h, 'InnerRadius');
b = get(h, 'OuterRadius');
 
% OuterRadius must be greater than the InnerRadius
if a >= b
    id = sprintf('rf:%s:checkproperty:OuterInner',strrep(class(h),'.',':'));
    error(id,['Outer radius must be greater than inner radius.']);
end
