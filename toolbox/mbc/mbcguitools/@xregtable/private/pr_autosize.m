function sz=pr_autosize(dim,tp,val)
% PR_AUTOSIZE  Private auto sizing function
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:02 $

% Created 5/4/2000

% we expect a global copy of fud
global fud

if strcmp(lower(dim),'rows')
   inds=[2 4];
   w = fud.position(4) - sum(fud.frame.vborder) - ...
      strcmp(fud.hslider.visible,'on').*fud.hslider.width;
   sp=fud.rows.spacing;
elseif strcmp(lower(dim),'cols')
   inds=[1 3];
   w = fud.position(3) - sum(fud.frame.hborder) - ...
      strcmp(fud.vslider.visible,'on').*fud.vslider.width;
   sp=fud.cols.spacing;
else
   rs=1;cs=1;
   return
end
   
if strcmp(lower(tp),'minsize')
   % minimum size rows/cols - work out number of rows/cols
   val=floor((w+sp)./(val+sp));
end

% divide w up into val bits...
sz = (w - (val - 1).*sp)./val;
return