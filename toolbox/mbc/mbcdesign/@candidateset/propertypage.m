function out=propertypage(obj,action,varargin);
% PROPERTYPAGE  Create a property gui for CandidateSet
%
%
%   This should be overloaded by child classes
%
%   Interface:  Lyt=propertypage(cs,'layout',fig,p_cs);
%               Lyt=propertypage(cs,'update',lyt,p_cs,model);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:56:44 $


switch lower(action)
case 'layout'
   out=i_createlyt(varargin{:});
case 'update'
   
case 'finalise'
   % finalise is called before the property page is shut down
case 'quickapply'
   % quickapply is called to get a rough preview of the candidateset
end





function lyt=i_createlyt(figh,p)

txt=uicontrol('parent',figh,'style','text','visible','off',...
   'string','No Property Page has been defined for this Candidate Set.');

lyt=xreglayerlayout(figh,'elements',{txt},'packstatus','off');
return