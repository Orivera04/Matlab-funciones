function str=status_str(des)
% STATUS_STR   Return description string for status bar
%
%   STR=STATUS_STR(D) creates a description string for the design
%   D which is placed in the status bar of the design editor.
%   The string is of the form:
%
%     "N points, P factor design"
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:50 $

% Created 15/3/2000



str=[sprintf('%d',des.npoints) ' points, ' sprintf('%d',des.nfactors) ' factors'];