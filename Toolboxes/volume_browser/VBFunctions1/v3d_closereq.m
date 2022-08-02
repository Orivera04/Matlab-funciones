function v3d_closereq(varargin)
% Substitute for the default figure-close request function
%
% Written by: E. Rietsch: October 21, 2006
% Last updated:
%
%          v3d_closereq(varargin)
% INPUT
% varargin cell vector with default input arguments probided by Matlab for 
%          callback functions
%          the first is the handle of the object 


hObject=varargin{1};

answ=questdlg('Do you realy want to quit?','Volume Browser','YES','NO','YES');

if strcmp(answ,'YES')
   delete_handles2delete1(hObject)
   set(hObject,'CloseRequestFcn','closereq')
   delete(hObject)
end
