function newobj = copyobj(obj,fH)
% AXESTEXT/COPYOBJ  Copy an axestext object to another set of axes
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:17:51 $


% First ensure that new figure has a set of figure axes to attach to
fa = xregGui.figureaxes;
aH = getaxes(fa, fH);

% Copy the object
newobj = obj;

% Now copy the text to the new figure
newobj.wrappedobject = double(copyobj(handle(obj.wrappedobject), aH));
