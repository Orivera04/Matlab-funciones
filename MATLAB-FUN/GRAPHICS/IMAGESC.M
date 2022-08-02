function h = imagesc(x,y,a,clim)
%IMAGESC Scale data and display as image.
%	IMAGESC(...) is the same as IMAGE(...) except the data is scaled
%	to use the full colormap.
%	An optional final argument CLIMS = [CLOW CHIGH] can specify the
%	scaling.
%
%	NOTE:  IMAGESC places scaling information in the displayed image's
%	       UserData property so the COLORBAR command can annotate
%	       meaningful labels .
%
%	See also IMAGE, COLORBAR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

cm = colormap;
m = size(cm,1);
if nargin <= 2
	a = x;
end
if rem(nargin,2)
   amin = min(min(a));
   amax = max(max(a));
elseif nargin == 4
   amin = clim(1);
   amax = clim(2);
elseif nargin == 2
   amin = y(1);
   amax = y(2);
end
idx = min(m,round((m-1)*(a-amin)/(amax-amin))+1);
if nargin <= 2
	hh = image(idx);
else
	hh = image(x,y,idx);
end
colormap(cm);
set(hh,'UserData',[amin amax]);
if nargout > 0
	h = hh;
end
