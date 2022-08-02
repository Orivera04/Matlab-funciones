function [MP,msg]= close(MP,force)
%CLOSE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:03:20 $


if nargin<2
	force= 0;
end

msg='';
if force
	[MP,msg]= save(MP,0);
elseif MP.Modified & ~isBlank(MP) % needs saving
   [nul,filenm]=fileparts(MP.Filename);
   answer =questdlg(['Do you want to save the changes you made to "',filenm,'"?'],'Save Project','Yes');
   switch answer
   case 'Yes'
		[MP,msg]= save(MP,0);
		MP.Modified= 0;
		pointer(MP);
   case 'Cancel'
		msg= 'File not saved';
      return
   end
end

% delete temp file
[P,F,E]= fileparts(MP.Filename);
if ~isempty(P) & exist([P,filesep,'~',F,'.tmp']) 
    recycle_state = recycle('off');
	delete([P,filesep,'~',F,'.tmp']);
    recycle( recycle_state );
end
