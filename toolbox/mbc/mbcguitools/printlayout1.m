function bH = printlayout1(axes2copyH, text2copyH, titlestring, fH)
%PRINTLAYOUT1

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:33:44 $

% Test print for local models
% axes2copyH could be an axis handle or a gridlayout
% text2copyH could be am axis handle or a layout

if nargin == 0
   i_resize(gcbf);
   return;
end

% Make sure that the figure starts off invisible
if nargin < 4
   fH = figure('visible','off');
end

set(fH,'visible','off','units','pixels','color','w');
% Ensure that h contains only handles otherwise concatenation will fail
h = [];
if ishandle(axes2copyH)
   %% only print visible axes
   axes2copyH = findobj(axes2copyH,'flat','visible','on');
   h = [h;axes2copyH(:)];
end
if ishandle(text2copyH)
   h = [h;text2copyH(:)];
end

% Get axes units before converting to pixels
% Note need to convert to pixels in case one axes has
% normalised units, in which case it's size will not be correct
U = get(h,{'units'});
set(h,'units','pixels');
% Copy the objects
aH = copyobj(axes2copyH, fH);
% Have we been passed an array of handles
if (length(aH) > 1) & ishandle(aH)
   %% puts all axes into wrappers and then into a grid
   aH = i_CreateGrid(aH, fH);
elseif (length(aH) == 1) & ishandle(aH)
   aH = axiswrapper(aH);
end
tH = copyobj(text2copyH, fH);
% Ensure no callbacks remain attached
RemoveCallbacks(aH);
% Reset original handles units
set(h,{'units'},U);
% Ensure that tH actually contains something
if isempty(tH)
   tH = xregcontainer;
end
% Get the width and height of the two copied elements
aHwh = i_Pos2WH(get(aH, 'position'));
tHwh = i_Pos2WH(get(tH, 'position'));
% Put a border around the copied axes
west = 80;
if ~ishandle(aH)
   west = 50;
end

% Add the title to the Layout
titleH = axestext(fH,'string',titlestring,'fontsize',11,'fontweight','bold',......
   'HorizontalAlignment','center','VerticalAlignment','middle','units','pixels',...
   'interpreter','none');

% ----old "put it all together" thing-----
% bH = xregborderlayout(fH, 'north', titleH, 'center', baH, 'south', btH,...
%    'container',fH,'packstatus','on');
% set(bH, 'innerborder', [0 tHwh(2) 0 50]);

%% find height of title - may be multiline
titleExt = get(titleH,'extent');
titleHeight = titleExt(end)+10;
% Layout the final printed page
bH = xreggridbaglayout(fH,...
   'dimension',[6,4],...
   'colsizes',[20,west-20,-1,50],...
   'rowsizes',[titleHeight,20,-1,30,tHwh(2),20],...
   'mergeblock',{[1 1],[1 4]},...%%title all one row
   'mergeblock',{[2 2],[1 4]},...%% gap between title and axes
   'mergeblock',{[4 4],[1 4]},...%% gap under axes
   'mergeblock',{[5 5],[2 3]},...
   'elements',{...
      titleH,[],[],[],[],[],...
      [],[],[],[],tH,[],...
      [],[],aH,[],[],[],...
      [],[],[],[],[],[]});
set(bH,'container',fH,'packstatus','on');

% Add the final layout to the userdata for resize purposes
ud.bH = bH;   
% Set the figure 
set(fH,'userdata',ud,...
   'resizefcn',mfilename,...
   'paperpositionmode','auto',...
   'position',[100 50 max(aHwh(1),tHwh(1)) aHwh(2)+tHwh(2)+titleHeight+70]);

%% for development - if you want to check what the lyt looks like
% set(fH,'visible','on');

i_resize(fH)
printdlg(fH)

if ishandle(fH); delete(fH); end;

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Pos2TL
%-------------------------------------------------------------------
function TL = i_Pos2TL(TLWH)
TL = TLWH(1:2);

%-------------------------------------------------------------------
% SUBFUNCTION i_Pos2WH
%-------------------------------------------------------------------
function WH = i_Pos2WH(TLWH)
WH = TLWH(3:4);

%-------------------------------------------------------------------
% SUBFUNCTION i_resize
%-------------------------------------------------------------------
function i_resize(fH)
% Is the new size bigger than the papersize?
u = get(fH,'units');
% Set the units to be the paper units for comparison
set(fH,'units','centimeter');
set(fH,'PaperUnits','centimeter');
s = get(fH,'papersize')-2;
p = get(fH,'position');
% Compare the sizes
if any(i_Pos2WH(p) > s)
   set(fH,'position',[i_Pos2TL(p) min(i_Pos2WH(p),s)]);
else
   set(fH,'position',[i_Pos2TL(p) s]);
end
   
% Reset the figure units
set(fH,'units',u);
% Repack the container
ud = get(fH,'userdata');
repack(ud.bH);

%-------------------------------------------------------------------
% SUBFUNCTION i_CreateGrid
%-------------------------------------------------------------------
function grid = i_CreateGrid(aH, fH)

num = length(aH);
nrows = ceil(sqrt(num));
ncols = round(sqrt(num));
aWH = i_Pos2WH(get(aH(1),'position'));

for i = 1:num
   %	NewAx{i}=xreglayerlayout(fH,'border',[40 40 10 20],'elements',{aH(i)});
   NewAx{i}= axiswrapper(aH(i));
   %NewAx{i} = uicontrol;
end

height = nrows*(aWH(2));
width = ncols*(aWH(1));
grid = xreggridlayout(fH,...
   'dimension',[nrows ncols],...
   'elements',NewAx,...
   'gapx', 50,...
   'gapy', 50,...
   'rowsizes', -1*ones(nrows,1),...
   'colsizes', -1*ones(ncols,1),...
   'position',[0 0 width height]);
