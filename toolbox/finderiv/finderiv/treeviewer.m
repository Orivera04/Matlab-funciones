function treeviewer(Tree,Port)
%TREEVIEWER Display information of a Tree.
%
% Usage 1: Display rates of an HJMFwdTree,  BDTFwdTree or MMmktTree.
%   treeviewer(HJMTree)
%   treeviewer(BDTTree)
%   treeviewer(MMmktTree)
%
% Usage 2: Display prices of a HJMPriceTree, BDTPriceTree, CRRPriceTree or EQPPriceTree.
%   treeviewer(PriceTree, InstSet)
%   treeviewer(PriceTree)
%
% Usage 3: Display cash flows of a HJMCFTree or BDTCFTree.
%   treeviewer(CFTree, InstSet)
%   treeviewer(CFTree)
%
% Usage 4: Display stock values of a CRRTree or EQPTree.
%   treeviewer(CRRTree)
%   treeviewer(EQPTree)
%
%
% Inputs:
%   Tree -    Heath-Jarrow-Morton, Black-Derman-Toy, Cox-Ross-Rubinstein or 
%             Equal Probability tree structure containing 
%             either rates, stocks, prices, or cash-flows.
%
%   InstSet - Variable containing a collection of NINST instruments
%             whose prices or cash-flows are contained in Tree.
%             This collection of instruments can be a set created 
%             with the function 'instadd', or a cell array containing
%             the names of the instruments. To display the names of the 
%             instruments, the field Name should exist in the variable 
%             InstSet. If InstSet is not passed, default instruments names
%             will be used when displaying prices or cash-flows. 
%             
%
% Examples:
%	1) Display HJMFwdTree:
%	 load deriv
%    treeviewer(HJMTree)
%
%	2) Display HJMPriceTree including instrument set:
%	 load deriv.mat
%    [Price, PriceTree] = hjmprice(HJMTree, HJMInstSet);
%    treeviewer(PriceTree, HJMInstSet);
%
%	3) Display HJMPriceTree including instruments names:
%	 load deriv
%    names = {'Bond', 'Bond', 'Option', 'Fixed', ...
%             'Float', 'Cap', 'Floor', 'Swap' };
%    treeviewer(PriceTree, names);
%
%	4) Display HJMPriceTree. Use default instrument names(numbers):
%	 load deriv
%	 treeviewer(PriceTree);
%	  
% See also HJMTREE, BDTTREE, CRRTREE, EQPTREE, INSTADD

%   Author(s): C.F.Garvin, M. Reyes-Kattar 01-15-2000
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.11.2.1 $  $Date: 2003/08/29 04:46:53 $

%Define Colors for tree viewer actions (used by more than one switch case)
ColorOne = [1 .15 0];    %Path One
ColorTwo = [.6 0 .6];    %Path Two
ColorThree = [1 0 0];    %Node and Children

fnt = get(0,'Fixedwidthfont');  %Font to use for all listboxes

% ---------------------------------------------------
% Determine the type of tree, and obtain information 
% appropriately.
% ---------------------------------------------------
if isafin(Tree, 'HJMFwdTree')
   [NLevels, NChild] = bushshape(Tree.FwdTree);
elseif isafin(Tree, 'HJMPriceTree')
   [NLevels, NChild, NInstTree] = bushshape(Tree.PBush);
elseif isafin(Tree, 'HJMCFTree')
   [NLevels, NChild, NInstTree] = bushshape(Tree.CFBush);
elseif isafin(Tree, 'HJMMmktTree')
    [NLevels, NChild, NInstTree] = bushshape(Tree.MMktTree);
elseif iscell(Tree)
   [NLevels, NChild, NInstTree] = bushshape(Tree);
elseif isafin(Tree, 'BDTFwdTree')
	[NLevels, NInstTree] = treeshape(Tree.FwdTree);
	NChild = 2;
elseif isafin(Tree, 'BDTPriceTree')
	[NLevels, NInstTree] = treeshape(Tree.PTree);
	NChild = 2;	
elseif isafin(Tree, 'BDTCFTree')
	[NLevels, NInstTree] = treeshape(Tree.CFTree);
	NChild = 2;	
elseif isafin(Tree, 'BDTMmktTree')
	[NLevels, NInstTree] = treeshape(Tree.MMktTree);
	NChild = 2;		
elseif isafin(Tree, 'BinStockTree')
	[NLevels, NInstTree] = treeshape(Tree.STree);
	NChild = 2;
elseif isafin(Tree, 'BinPriceTree')
	[NLevels, NInstTree] = treeshape(Tree.PTree);
	NChild = 2;    
else
	error('finderiv:treeviewer:InvalidTree','Input argument ''Tree'' not recognized as a valid tree')      
end


% -----------------------------------------------
% Determine how portfolio was passed in. If a portfolio
% was passed in, pull out the names of the instruments.
% -----------------------------------------------
instnames = [];
if nargin == 2 
   if isafin(Port, 'Instruments')
		try
    		instnames = cellstr(instget(Port,'FieldName',{'Name'}));    		    		
  		catch
    		errordlg('finderiv:treeviewer:InvalidPortfolio','Portfolio must contain at least one instrument to open tree viewer.')
    		set(findobj('Type','figure'),'Pointer','arrow')
    		return
      end
   elseif iscell(Port)
      instnames = Port;
   end
   NInstSet = length(instnames);
   instval = 1;    %Default to first instrument
elseif(~isafin(Tree, 'HJMFwdTree') & ~isafin(Tree, 'HJMMmktTree') & ...
	   ~isafin(Tree, 'BDTFwdTree') & ~isafin(Tree, 'BDTMmktTree') & ...
       ~isafin(Tree, 'BinStockTree'))
   % ---------------------------------------------
   % If no PortFolio was passed in, and the tree is 
   % not an HJMFwdTree, default instrument names to 
   % instrument numbers as long as NInstTree is 
   % constant.
   % ---------------------------------------------
   if(all(NInstTree == NInstTree(1)))      
		instnames = cellstr(num2str((1:NInstTree(1))'));   
	   NInstSet = NInstTree(1);
      instval = 1;
   end   
end  


% ---------------------------------------------------
% Verify that the number of instruments in InstSet
% corresponds to the number of instruments represented
% in the tree.
% ---------------------------------------------------
if nargin == 2
   if isafin(Tree, 'HJMFwdTree')
      warning('finderiv:treeviewer:IgnoredInstSet','HJMFwdTree passed in. Ignoring input argument ''InstSet''')
      instnames = [];
   elseif isafin(Tree, 'HJMMmktTree')
	  warning('finderiv:treeviewer:IgnoredInstSet','HJMMmktTree passed in. Ignoring input argument ''InstSet''')
      instnames = []; 
   elseif isafin(Tree, 'BDTFwdTree')
	  warning('finderiv:treeviewer:IgnoredInstSet','BDTFwdTree passed in. Ignoring input argument ''InstSet''')
      instnames = [];
   elseif isafin(Tree, 'BDTMmktTree')
	  warning('finderiv:treeviewer:IgnoredInstSet','BDTMmktTree passed in. Ignoring input argument ''InstSet''')
      instnames = []; 
   elseif isafin(Tree, 'BinStockTree')
	  warning('finderiv:treeviewer:IgnoredInstSet','StockTree passed in. Ignoring input argument ''InstSet''')
      instnames = []; 
   else
      if(NInstTree(1) ~= NInstSet)
         error('finderiv:treeviewer:InvalidInstSet','Number of instruments in InstSet does not correspond to the number of instruments in the Tree')
      end
   end   
end


%View instrument price tree
h = figure('Name','Tree Viewer','Numbertitle','off','Userdata',Tree,'Tag','treeviewer');
setappdata(h,'HJMTREE',Tree)
set(h,'windowstyle','normal')

if isafin(Tree, 'BDTFwdTree')
	AxesHandle = treeguistate(Tree.FwdTree);
elseif isafin(Tree, 'BDTPriceTree')
	AxesHandle = treeguistate(Tree.PTree);
elseif isafin(Tree, 'BDTCFTree')
	AxesHandle = treeguistate(Tree.CFTree);
elseif isafin(Tree, 'BDTMmktTree')
	AxesHandle = treeguistate(Tree.MMktTree);
elseif isafin(Tree, 'BinStockTree')
	AxesHandle = treeguistate(Tree.STree);
elseif isafin(Tree, 'BinPriceTree')
	AxesHandle = treeguistate(Tree.PTree);    
else	
	AxesHandle = bushguistate(NChild);
end

%Store portfolio data in figure window for later use
if nargin == 2
  uicontrol('Visible','off','Tag','portfolio','Userdata',Port);
end

%start x-axis labels at zero
xlab = get(gca,'Xtick')-1;

%reposition axis
p = get(AxesHandle,'Position');
set(AxesHandle,'Position',[p(1)/8 p(2) p(3)/2+p(1)/2 p(4)],'Tag','Chooser',...
  'Xticklabel',xlab,'Color',[1 1 1])

%Set highlightmode to path to root
setappdata(AxesHandle,'HighlightMode','path')
    
%Build uicontrols

%Get figure position and set spacing parameters
p = get(gcf,'Position');
rgt = p(3);
top = p(4);
dfp = get(0,'DefaultFigurePosition');
mfp = [560 420];    %Reference width and height
bspc = mean([5/mfp(2)*dfp(4) 5/mfp(1)*dfp(3)]);
bhgt = 20/mfp(2) * dfp(4);
bwid = 85/mfp(1) * dfp(3);
fwid1 = rgt-2*bspc;
fhgt1 = 7*bspc+6*bhgt;
fhgt2 = top-fhgt1-4*bspc;

%Close Button
uicontrol('String','Close','Callback','close','Position',[rgt-(bspc+bwid) 2*bspc bwid bhgt]);
uicontrol('String','Help','Callback','derivtool(''help'',''treeviewer'')','Position',[rgt-(2*bspc+2*bwid) 2*bspc bwid bhgt]);
   
%Tree Visualization frame
uicontrol('Style','frame','Position',[rgt/2 top-5*bhgt rgt/2-bspc 2*bspc+4*bhgt]);
uicontrol('Style','text','String','Tree Visualization',...
  'Position',[rgt/2+bspc top-(bspc+bhgt) bwid bhgt]);
uicontrol('Style','text','String','Visualization',...
  'Position',[rgt-(bspc+1.25*bwid) top-(bspc+1.75*bhgt) bwid bhgt]);
uicontrol('Style','radiobutton','String','Table','Tag','treeradio',...
  'Callback','treeviewercallbacks(''radiobutton'')','Value',1,...
  'Position',[rgt-(bspc+1.25*bwid) top-(bspc+2.5*bhgt) bwid bhgt]);
uicontrol('Style','radiobutton','String','Diagram','Tag','treeradio',...
  'Callback','treeviewercallbacks(''radiobutton'')',...
  'Position',[rgt-(bspc+1.25*bwid) top-(bspc+3.5*bhgt) bwid bhgt]);
uicontrol('Style','radiobutton','String','Plot','Tag','treeradio',...
  'Callback','treeviewercallbacks(''radiobutton'')',...
  'Position',[rgt-(bspc+1.25*bwid) top-(bspc+4.5*bhgt) bwid bhgt]);
uicontrol('Style','text','String','Selection',...
  'Position',[rgt-(bspc+3*bwid) top-(bspc+1.75*bhgt) bwid bhgt]);
uicontrol('Style','radiobutton','String','Path','Tag','pathradio',...
  'Callback','treeviewercallbacks(''radiobutton'')','Value',1,'Userdata','path',...
  'Position',[rgt-(bspc+3*bwid) top-(bspc+2.5*bhgt) bwid bhgt]);
uicontrol('Style','radiobutton','String','Node and Children','Tag','pathradio',...
  'Callback','treeviewercallbacks(''radiobutton'')','Userdata','node',...
  'Position',[rgt-(bspc+3*bwid) top-(bspc+3.5*bhgt) bwid+5*bspc bhgt]);

%Selected instrument uicontrols, only if from View Tree in main window
if ~isempty(instnames)
  vflag = 1;
  uicontrol('Style','text','String','Instrument:',...
    'Position',[rgt-(bspc+3*bwid) top-(3*bspc+6*bhgt) bwid bhgt]);
  uicontrol('Style','popupmenu','String',instnames,'Tag','treeinstruments',...
    'Callback','treeviewercallbacks(''treeinstrument'')',...
    'Value',instval,'Position',[rgt-(bspc+2*bwid) top-(2*bspc+6*bhgt) 1.5*bwid bhgt]);
else
  vflag = 0;   %Do not display instrument uicontrols
end
  
%Data/plot frame
bgf = axes('Units','pixels','Position',[rgt/2 5*bspc+bhgt rgt/2-bspc 12*bhgt-bspc],...
  'Box','on','Xtick',[],'Ytick',[],...
  'Color',get(0,'Defaultuicontrolbackgroundcolor'));
set(bgf,'Units','normal')

%Data uicontrols
if vflag    %Instrument tree viewing
  uicontrol('Style','text','String','Time','Userdata','pathtoroot',...
    'Position',[rgt-(2*bspc+3*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
else     %Rates  tree viewing
  uicontrol('Style','text','String','Start Time','Userdata','pathtoroot',...
    'Position',[rgt-(2*bspc+3*bwid) top-(6*bspc+7*bhgt) bwid bhgt]); 
  uicontrol('Style','text','String','End Time','Userdata','pathtoroot',...
    'Position',[rgt-(2*bspc+2.25*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
end  
uicontrol('Style','text','String','Path 1','Userdata','pathtoroot',...
  'Foregroundcolor',ColorOne,...
  'Position',[rgt-(2*bspc+1.5*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
uicontrol('Style','text','String','Path 2','Userdata','pathtoroot',...
  'Foregroundcolor',ColorTwo,...
  'Position',[rgt-(2*bspc+.8*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
uicontrol('Style','listbox','Tag','treedata','Userdata','pathtoroot',...
  'Fontname',fnt,...
  'Position',[rgt/2+bspc 6*bspc+bhgt rgt/2-3*bspc 10*bhgt+bspc]);

%Plot axis
pta = axes('Units','pixels','Box','on','Xtick',[],'Ytick',[],'Tag','treeplot',...
  'Userdata','nodeandchildren','Visible','off','Color',[1 1 1],...
  'Position',[rgt/2+bspc 6*bspc+bhgt rgt/2-3*bspc bspc+11*bhgt]);
set(pta,'Units','normal')

%Define callbacks for tree elements
trobj = findobj(gcf,'Tag','StateMark');
set(trobj,'Buttondownfcn','treeviewercallbacks(''treeaction'')')

%Set colors for paths, (taken from bushguistate)
ColorOrder = get(gca,'ColorOrder');
ColorOrder(3:4,:) = [ColorOne;ColorTwo];
ColorOrder(5:end,:) = [];
ColorState = ColorOrder(1,:); % Color of state markers
ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
ColorSelectInd = 1; % Location of next color in ColorSelectOrder

ChooserH = findobj(gcf,'Tag','Chooser');
setappdata(ChooserH, 'ColorState', ColorState);
setappdata(ChooserH, 'ColorLine',  ColorLine);
setappdata(ChooserH, 'ColorSelectOrder', ColorSelectOrder);
setappdata(ChooserH, 'ColorSelectInd',   ColorSelectInd);

setappdata(ChooserH,'CurrentPathNumber',0)
    
%CLEANUPDIALOG Visual enhancement of dialog.

%Set colors and alignment
e = findobj(gcf,'Style','edit');
l = findobj(gcf,'Style','listbox');
p = findobj(gcf,'Style','popupmenu');
set([e;l;p],'Backgroundcolor','white','Horizontalalignment','left')
dbc = get(0,'Defaultuicontrolbackgroundcolor');
set(gcf,'Color',dbc)

%Make text boxes proper width
textuis = findobj(gcf,'Style','text');
notextui = findobj(gcf,'Tag','tabtext');  %Do not alter tab cover (which is a blank text ui)
if ~isempty(notextui);
  j = find(notextui == textuis);
  textuis(j) = [];
end
for i = 1:length(textuis)
  pos = get(textuis(i),'Position');
  ext = get(textuis(i),'Extent');
  set(textuis(i),'Position',[pos(1) pos(2) ext(3) pos(4)])
end
set(textuis,'Backgroundcolor',dbc)
set(findobj(gcf,'Value',-33),'Backgroundcolor',[1 1 1])

%Normalize units
set(findobj(gcf,'Type','uicontrol'),'Units','normal')
set(findobj(gcf,'Type','axes'),'Units','normal')
