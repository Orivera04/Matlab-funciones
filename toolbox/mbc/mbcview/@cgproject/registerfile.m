function [PROJ,msg]= registerfile(PROJ,File);
%REGISTERFILE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:28:24 $

[Newpath,Newfile,Ext]= fileparts(File); 

PROJ.filename= File;
% save temp file
msg='';
tmpfile= fullfile(Newpath,['~',Newfile,'.tmp']);
if exist(tmpfile)
   msg= 'File is currently in use';
else
	try
      tmpvar='FileOpened';
		save(tmpfile,'tmpvar','-mat');
	catch
		msg= 'Error creating temporary file: file may be on a read-only drive';
		return
	end
end

pointer(PROJ);

