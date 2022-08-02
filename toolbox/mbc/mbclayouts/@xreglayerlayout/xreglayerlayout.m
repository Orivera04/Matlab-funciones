function obj  = xreglayerlayout(varargin)
%  Synopsis
%     function obj = xreglayerlayout(parameter,value,parameter,....)
%     function obj = xreglayerlayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xreglayerlayout container in the (optional) figure fig.
%
%  See also
%     xreglayerlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:27 $


fig=[];
if nargin
   if ishandle(varargin{1}) & strcmp(get(varargin{1},'type'),'figure')
      fig=varargin{1};
      varargin(1)=[];
   end
end
if isempty(fig)
   fig=gcf;
end

c = xregcontainer(fig);
obj.version=1.0;
obj = class(obj,'xreglayerlayout',c);
set(obj,varargin{:});
