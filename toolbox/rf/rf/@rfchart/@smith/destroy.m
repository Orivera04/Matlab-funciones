function h = destroy(h,destroyData)
%DESTROY  Destroy Smith object & clean up HG

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:36:00 $

% When method is called directly, delete object
if nargin<2 | ~strcmp(class(destroyData),'handle.EventData')
    h.delete;
    return
% When called from listener on axes deletion, delete object
elseif strcmp(class(destroyData.Source),'axes')
    h.delete;
    return
end

% Delete HG objects associated with Smith chart
delete(h.StaticGrid(ishandle(h.StaticGrid)));
delete(h.AdmittanceGrid(ishandle(h.AdmittanceGrid)));
delete(h.ImpedanceGrid(ishandle(h.ImpedanceGrid)));
