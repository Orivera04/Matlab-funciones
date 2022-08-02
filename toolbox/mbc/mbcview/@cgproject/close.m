function [PROJ,msg]= close(PROJ,force)
%CLOSE  Close a project
%
%  [PROJ,MSG]=CLOSE(PROJ,FORCEFLG)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:28:05 $

if nargin<2
	force= 0;
end

msg='';
if force
	[PROJ,msg]= save(PROJ,0);
elseif PROJ.modified % needs saving
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%  Leaky hack to check for a brand new empty  %%
   %%  project                                    %%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if ~isnewproject(PROJ)
      [nul,filenm]=fileparts(PROJ.filename);
      answer =questdlg(['Do you want to save the changes you made to "',filenm,'"?'],'Save Project','Yes');
      switch answer
      case 'Yes'
         [PROJ,msg]= save(PROJ,0);
         pointer(PROJ);
      case 'Cancel'
         msg= 'File not saved';
         return
      end
   end
end

% delete temp file
[P,F,E]= fileparts(PROJ.filename);
tmpfile=fullfile(P,['~', F, '.tmp']);
if exist(tmpfile)
    recycle_state = recycle('off');
    delete(tmpfile);
    recycle( recycle_state );
end