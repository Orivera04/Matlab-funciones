function ret=isfileopen(P,File)
%ISFILEOPEN  Indicate if file is already in use
%
%  ret=ISfILEOPEN(P,FILE)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:28:15 $

[Newpath,Newfile,Ext]= fileparts(File); 

tmpfile= fullfile(Newpath,['~',Newfile,'.tmp']);
ret=exist(tmpfile,'file');
