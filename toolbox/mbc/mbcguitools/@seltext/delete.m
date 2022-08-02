function delete(obj)
% DELETE   Delete Seltext object
%
%   Delete(obj) deletes the graphical resources associated with obj.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:20:31 $

% Created 6/10/2000


delete(obj.back);
delete(obj.axestext);

return