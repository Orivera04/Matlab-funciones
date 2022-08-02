function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:44 $

% Check the properties
ckts = get(h, 'CKTS');
nckts = length(ckts);

if isempty(ckts)
    id = sprintf('rf:%s:checkproperty:EmptyCKTS', strrep(class(h),'.',':'));
    error(id, 'Series network needs the property ''CKTS'' in order to do analysis.'); 
end

for i=1:nckts
    ckt = ckts{i};
    checkproperty(ckt);
    if isnonlinear(ckt)
        id = sprintf('rf:%s:checkproperty:LinearOnly', strrep(class(h),'.',':'));
        error(id, 'All the circuits in a Series network must be linear.');
    end
    if get(ckt, 'nPort') ~= 2
        id = sprintf('rf:%s:checkproperty:TwoPortOnly', strrep(class(h),'.',':'));
        error(id, 'All the circuits in a Series network must be 2-port.');
    end
end

