function obj=xregmanuallayout(varargin);
% XREGMANUALLAYOUT
%
%  A manuuallayout object allows it's contained elements
%  to be set in a user-defined position and left there.
%  Essentially it breaks the normal repack flow of layouts.
%  Other properties are passed on as normal, making this useful
%  for attaching legacy code to new tablayouts.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:31 $


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

obj.version=1;
c=xregcontainer(fig);

obj=class(obj,'xregmanuallayout',c);
set(obj,varargin{:});
return
