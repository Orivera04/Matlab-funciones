function [MP,msg]= save(MP,SaveAs);
% MDEVPREJECT/SAVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:06:47 $



if nargin==1
	SaveAs=0;
end

DefExt= '.mat';
	
[pathname,filename,ext]= fileparts(MP.Filename);
if ~isempty(strmatch(filename,'Untitled')) | SaveAs
	OldName= filename;
	
	% get file name
    ProjectDir = xregGetDefaultDir('Projects');
	if ~isempty(strmatch(filename,'Untitled'))
		filename= name(MP);
	end
	[Newfile,Newpath] = uiputfile(fullfile(ProjectDir, [filename, DefExt]), 'Save As');
	if ischar(Newfile)
		if ~isempty(pathname) & exist([pathname, filesep, '~',filename,'.tmp']);
			delete([pathname,filesep,'~',filename,'.tmp']);
		end 
		
		[p,f,e]= fileparts([Newpath,Newfile]);
		if isempty(e)
			Newfile= [f,DefExt];
		end
		
		if strcmp(OldName,name(MP))
			% rename 
			MP= name(MP,f);
			mbH= MBrowser;
			mbH.doDrawTree(address(MP));
		end
	else
		msg= '';
		return
	end
		
	[MP,msg]= RegisterFile(MP,[Newpath,Newfile]);
	if ~isempty(msg)
		return
	end
end

try
	save(MP.Filename,'MP','-mat');
	MP.Modified= 0;
	pointer(MP);
	
	msg= '';
	% check whether the file has been save correctly
	if ~isProjectFile(MP);
		msg= 'File corrupted during write. Please save this file in a different directory.';
	end
catch
	msg= 'File write error. The file you are trying to save may be read-only.';
end