function setreference(h, refobj)
%SETREFERENCE Set the reference.
%   SETREFERENCE(H, REFOBJ) sets the property REFERENCE.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:27 $

% Set the property
if ~isempty(refobj) && (~isa(refobj, 'rfdata.reference')) 
    id = sprintf('rf:%s:setreference:WrongDataObject', strrep(class(h),'.',':'));
    error(id, 'This must be an RFDATA.REFERENCE object.');
end
set(h, 'Reference', refobj);
