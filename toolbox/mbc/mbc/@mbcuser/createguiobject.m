function hGUI = createguiobject(obj,opt,prnt,varargin)
%CREATEGUIOBJECT  Create a GUI object for viewing/editing user information
%
%  H = CREATEGUIOBJECT(OBJ,OPT,PRNT,PARAM1,OPT1,...)  where OPT is 'view' or 
%  'edit' creates a GUI object for viewing or editing the information in OBJ.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:45:34 $

if strcmp(opt,'view')
   edt = false;
else
   edt = true;
end

S = struct('nm',obj.username,...
   'company',obj.company,...
   'dept',obj.department,...
   'contact',obj.contact);

hGUI = mbcfoundation.userinfoeditor('parent',prnt,...
   'editable',edt,...
   'labels',{'Name:','Company:','Department:','Contact information:'},...
   'userinfo',S,...
   varargin{:});