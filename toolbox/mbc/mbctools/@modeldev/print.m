function OK=print(md,h)
%MODELDEV\PRINT Generic print function for modeldev objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:46 $

%

OK=1;
fH= double(h.Figure);
View = h.GetViewData;

% Will I have to delete the ModelView window I create
DELETE_MV = 0;
mvH = mvf('mvModelView');
if isempty(mvH)
    mvH = details(model(md),'view',fullname(md));
    set(mvH,'visible','off');
    DELETE_MV = 1;
end
tH = findobj(mvH,'type','axes');

switch md.ViewIndex,
case 'global'
    % Get handle to currently visible diagnostic plot
    aH = diagnosticPlots(md,'getcurrentaxes',fH);
    printlayout1(aH,tH,fullname(md));
    
    
case 'twostage'
    plyt = View.printLayout;
    printlayout1(plyt,tH,fullname(md));
    
end

if DELETE_MV
    close(mvH);
end
