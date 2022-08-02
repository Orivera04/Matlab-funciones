function mbcdeleteprefs
%MBCDELETEPREFS  Remove user preference files
% 
%  MBCDELETEPREFS removes the users' preference files from disk.
%  They will be re-initialised to defaults during the next startup.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:52 $

resetprefs(mbcprefs);
delete(fullfile(prefdir,['MBC', mbcver], '*.mat'));