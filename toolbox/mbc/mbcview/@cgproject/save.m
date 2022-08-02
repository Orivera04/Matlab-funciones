function [PROJ,msg]= save(PROJ,SaveAs);
% CGPREJECT/SAVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:28:25 $

if nargin==1
	SaveAs=0;
end
	
[pathname,filename,ext]= fileparts(PROJ.filename);
if ~isempty(strmatch(filename,'Untitled')) | SaveAs
	% get file name
	AP= mbcprefs('mbc');
	FileDefaults = getpref(AP,'PathDefaults');
	[Newfile,Newpath] = uiputfile([FileDefaults.cagfiles,'\*.cag'],'Save As');
	if Newfile ~= 0
		if ~isempty(pathname) & exist([pathname,filesep,'~',filename,'.tmp']);
			delete([pathname,filesep,'~',filename,'.tmp']);
		end 
      % add ".cag" if appropriate
      doti=findstr('.',Newfile);
      if isempty(doti)
         Newfile=[Newfile '.cag'];   
      end
	else
		msg= 'Cancel';
		return
	end
		
	[PROJ,msg]= registerfile(PROJ,[Newpath,Newfile]);
	if ~isempty(msg)
		return
	end
end

try
	save(PROJ.filename,'PROJ','-mat');
	pointer(PROJ);
	msg= '';
catch
	msg= 'The file you are trying to save is read-only. Please change the file properties before attempting to save again.';
end