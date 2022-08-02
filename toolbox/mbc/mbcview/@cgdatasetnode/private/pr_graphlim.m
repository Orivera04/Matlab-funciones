function lim = pr_Graphlim(lim,ax,X,Y,Z)
% pr_Graphlim(lim,ax,X,Y,D)
% lim empty - create new limits
% lim structure - update limits
% ax non-empty - update axes limits

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:34 $

if nargin<5
    Z = [];
end

% do sanity check on min,max
if ~isempty(X) & ~isempty(lim) & ~isempty(lim.Xlim)
    xmn = min([X(:) ; lim.Xlim(1)]);
    xmx = max([X(:) ; lim.Xlim(2)]);
elseif ~isempty(X)
    xmn = min(X(:));
    xmx = max(X(:));
elseif ~isempty(lim) & ~isempty(lim.Xlim)
    xmn = lim.Xlim(1);
    xmx = lim.Xlim(2);
else
    xmn = []; xmx = [];
end
if ~isempty(Y) & ~isempty(lim) & ~isempty(lim.Ylim)
    ymn = min([Y(:) ; lim.Ylim(1)]);
    ymx = max([Y(:) ; lim.Ylim(2)]);
elseif ~isempty(Y)
    ymn = min(Y(:));
    ymx = max(Y(:));
elseif ~isempty(lim) & ~isempty(lim.Ylim)
    ymn = lim.Ylim(1);
    ymx = lim.Ylim(2);
else
    ymn = []; ymx = [];
end
if ~isempty(Z) & ~isempty(lim) & ~isempty(lim.Zlim)
    zmn = min([Z(:) ; lim.Zlim(1)]);
    zmx = max([Z(:) ; lim.Zlim(2)]);
elseif ~isempty(Z)
    zmn = min(Z(:));
    zmx = max(Z(:));
elseif ~isempty(lim) & ~isempty(lim.Zlim)
    zmn = lim.Zlim(1);
    zmx = lim.Zlim(2);
else
    zmn = []; zmx = [];
end

if ~isempty(xmn) & xmn>=xmx
   if xmn==0
      xmn=-0.01;
      xmx=0.01;
   else
      xmn=(1-sign(xmn).*0.01)*xmx;
      xmx=(1+sign(xmx).*0.01)*xmx;
   end
end
if ~isempty(ymn) & ymn>=ymx
   if ymn==0
      ymn=-0.01;
      ymx=0.01;
   else
      ymn=(1-sign(ymn).*0.01)*ymx;
      ymx=(1+sign(ymx).*0.01)*ymx;
   end
end
if ~isempty(zmn) & zmn>=zmx
   if zmn==0
      zmn=-0.01;
      zmx=0.01;
   else
      zmn=(1-sign(zmn).*0.01)*zmx;
      zmx=(1+sign(zmx).*0.01)*zmx;
   end
end

% check for NaN's
if ~any(isnan([xmn,xmx]))
   if ~isempty(xmn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(xmx-xmn).*1e-10;
      xmn=xmn-delt;
      xmx=xmx+delt;
      if ~isempty(ax), set(ax,'xlim',real([xmn xmx])); end
   else
      if ~isempty(ax), set(ax,'xlimmode','auto'); end
   end
end
if ~any(isnan([ymn,ymx]))
   if ~isempty(ymn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(ymx-ymn).*1e-10;
      ymn=ymn-delt;
      ymx=ymx+delt;
      if ~isempty(ax), set(ax,'ylim',real([ymn ymx])); end
   else
      if ~isempty(ax), set(ax,'ylimmode','auto'); end
   end
end
if ~any(isnan([zmn,zmx]))
   if ~isempty(zmn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(zmx-zmn).*1e-10;
      zmn=zmn-delt;
      zmx=zmx+delt;
      if ~isempty(ax), set(ax,'zlim',real([zmn zmx])); end
   else
      if ~isempty(ax), set(ax,'zlimmode','auto'); end
   end
end

lim.Xlim = [xmn xmx];
lim.Ylim = [ymn ymx];
lim.Zlim = [zmn zmx];
