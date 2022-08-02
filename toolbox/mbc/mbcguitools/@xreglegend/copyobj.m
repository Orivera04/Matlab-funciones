function new=copyobj(gr,p)
%  XREGLEGEND/COPYOBJ   copyobj for xreglegend object
%   new = copyobj(gr,parent)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:40 $

% Bail if we've not been given a legend object
if ~isa(gr,'xreglegend')
   error('Cannot set properties: not an xreglegend object!')
end

new = xreglegend(p);
% Copy properties
gr = get(gr.axes,'userdata');
d = gr.d;
new.d = d;
% clear callbacks
builtin('set',new.axes,'userdata',new);

% set position
newpos = get(gr,'position'); 
newpos([1 2]) = [10 10];
set(new,'visible','on','position',newpos,...
    'backgroundcolor',get(p,'color'),...
    'items',gr.items);
