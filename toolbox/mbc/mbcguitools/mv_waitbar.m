function fout = waitbar(x,whichbar,fh,pos)
%WAITBAR Display wait bar.
%   H = WAITBAR(X,'title') creates and displays a wait bar of 
%   fractional length X.  The handle to the waitbar figure is
%   returned in H.  X should be between 0 and 1.
%
%   WAITBAR(X,H) will set the length of the bar in waitbar H
%   to the fractional length X.
%
%   WAITBAR(X) will set the length of the bar in the most recently
%   created waitbar window to the fractional length X.
%
%   WAITBAR is typically used inside a FOR loop that performs a 
%   lengthy computation.  A sample usage is shown below:
%
%       h = waitbar(0,'Please wait...');
%       for i=1:100,
%           % computation here %
%           waitbar(i/100,h)
%       end
%       close(h)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   Clay M. Thompson 11-9-92
%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:42 $


if nargin==4 & ischar(whichbar)
   type=2; %we are initializing
   name=whichbar;
elseif nargin==2 & isnumeric(whichbar)
   type=1; %we are updating, given a handle
   f=whichbar;
elseif nargin==1
   f = findobj(allchild(0),'flat','Tag','mv_Waitbar');
   
   if isempty(f)
      type=2;
      name='Waitbar';
   else
      type=1;
      f=f(1);
   end   
elseif nargin==2
   error('Two-argument syntax requires WAITBAR(X,''title'') or WAITBAR(X,H)')
else
   error('Input arguments not valid.');
end

x = max(0,min(100*x,100));

switch type
case 1,  % waitbar(x)    update
   p = findobj(f,'Type','patch');
   l = findobj(f,'Type','line');
   if isempty(f) | isempty(p) | isempty(l), 
      error('Couldn''t find waitbar handles.'); 
   end
   xpatch = get(p,'XData');
   %replace 0 with xpatch(2)
   xpatch = [0 x x 0];
   set(p,'XData',xpatch')
%   xline = get(l,'XData');
%   set(l,'XData',xline);

case 2,  % waitbar(x,name,pos)  initialize

   oldRootUnits = get(fh,'Units');

   set(fh, 'Units', 'points');
   screenSize = get(fh,'Position');
   
   pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
   
   if length(pos)<4
      width = 360;
      height = 50;
      pos = [pos , width , height];   
   end
   axPos = pos* pointsPerPixel;   
   
   colormap([]);
   
   h = axes('XLim',[-10 110],...
      'YLim',[0 1],...
      'Box','on', ...
      'Units','Points',...
      'Color',get(fh,'color'),...
      'Position',axPos,...
      'XTickMode','manual',...
      'YTickMode','manual',...
      'XTick',[],...
      'YTick',[],...
      'XTickLabelMode','manual',...
      'XTickLabel',[],...
      'YTickLabelMode','manual',...
      'YTickLabel',[]);
   
   xpatch = [0 x x 0];
   ypatch = [0.25 0.25 .55 .55];
   xline = [100 0 0 100 100];
   yline = [0.25 0.25 .55 .55 .25];
   th=text(50,.75,name,'horizontalalign','center');
   p = rectangle('pos',[0 0.25 100 0.3],'facecolor','w','EdgeColor','k','EraseMode','none');
   p = patch(xpatch,ypatch,'r','EdgeColor','r','EraseMode','xor');
   l = line(xline,yline,'EraseMode','none');
   set(l,'Color',get(gca,'XColor'));

   set(h, 'HandleVis','off');
   set(fh, 'Units', oldRootUnits);
end  % case
drawnow;

if nargout==1,
  fout = h;
end