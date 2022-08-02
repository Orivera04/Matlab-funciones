function ok= isBlank(MP)
% MDEVPROJECT/ISBLANK 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:33 $

[p,f,e]= fileparts(MP.Filename);
ok= strcmp(f,'Untitled');
ok= ok & isempty(MP.Datalist) & numChildren(MP)==0;

