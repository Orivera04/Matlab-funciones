function canceledit(tbl)
% CANCELEDIT  Cancel editing of uiemuedits on a table
%
%   CANCELEDIT(TBL) cancels the editing of a uiemuedit cell
%   in a table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:26 $

% Created 25/9/2000


% call into the callback function to destroy editing capabilities

cellcb(tbl,'tempeditoff');
return
