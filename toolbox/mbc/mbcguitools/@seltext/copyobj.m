function newobj = copyobj(obj,fH)
% SELTEXT/COPYOBJ  Copy an seltext object to another figure
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:30 $


newobj=obj;
newobj.axestext=copyobj(obj.axestext,fH);

% First ensure that new figure has a set of figure axes to attach to
fa = xregGui.figureaxes;
aH = getaxes(fa, fH);
newobj.back=double(copyobj(handle(obj.back),aH));
return