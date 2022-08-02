function treeviewercallbacks(x)
%TREEVIEWERCALLBACKS Tree Viewer callback function.
%   TREEVIEWERCALLBACKS(X) Tree Viewer callback function for action X.

%   Author(s): C.F.Garvin, 01-15-2000
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.8.2.1 $  $Date: 2003/08/29 04:46:54 $
    
ColorOne = [1 .15 0];    %Path One
ColorTwo = [.6 0 .6];    %Path Two
ColorThree = [1 0 0];    %Node and Children
    
ChooserH = findobj(gcf,'Tag','Chooser');
        
HJMTree = getappdata(gcf,'HJMTREE');
            
% ---------------------------------------------------
% Determine the type of tree, and obtain information 
% appropriately.
% ---------------------------------------------------
if isafin(HJMTree, 'HJMFwdTree')
	treedata = HJMTree.FwdTree;   %HJM Forward Rates
	treeflag = 1;
elseif isafin(HJMTree, 'HJMPriceTree')
	treedata = HJMTree.PBush;     % HJM Prices
	treeflag = 2;
elseif isafin(HJMTree, 'HJMCFTree')
	treedata = HJMTree.CFBush;    %Cash Flows
	treeflag = 2;
elseif isafin(HJMTree, 'HJMMmktTree')
	treedata = HJMTree.MMktTree;  %Money Market
	treeflag = 3;
elseif isafin(HJMTree, 'BDTFwdTree')
	treedata = HJMTree.FwdTree;   %BDT Forward rates
	treeflag = 4;
elseif isafin(HJMTree, 'BDTPriceTree')
	treedata = HJMTree.PTree;     %BDT Prices
	treeflag = 5;	
elseif isafin(HJMTree, 'BDTCFTree')
	treedata = HJMTree.CFTree;     % BDT Cash Flows
	treeflag = 5;
elseif isafin(HJMTree, 'BDTMmktTree')
	treedata = HJMTree.MMktTree;   %BDT Money Market
	treeflag = 4;		
elseif isafin(HJMTree, 'BinStockTree')
	treedata = HJMTree.STree;   %CRR or EQP Stock Tree
	treeflag = 4;
elseif isafin(HJMTree, 'BinPriceTree')
	treedata = HJMTree.PTree;   %CRR or EQP Price Tree
	treeflag = 6;		
elseif iscell(HJMTree)
	treedata = HJMTree;           %Prices (cell array)
	treeflag = 2;
else
	error('finderiv:treeviewercallbacks:InvalidTree','Input argument ''Tree'' not recognized as a valid tree')      
end


switch(x)
	
case 'treeaction'
	
	buttontype = get(gcf,'SelectionType');
	if ~strcmp(buttontype,'normal')
		errordlg('Viewer supports primary mouse button clicks only.')
		set(findobj('Type','figure'),'Pointer','arrow')
		return
	end
	
	curpath = getappdata(ChooserH,'CurrentPathNumber');
	
	if(~curpath)
		OldColor = ColorOne;
	else
		OldColor = ColorTwo;
	end
	
	% Find objects forming old highlighted path
	% before processing the click on the chooser
	lobj = findobj(ChooserH,'Color',OldColor);
	mobj = findobj(ChooserH,'MarkerFaceColor',OldColor);
	
	%Remove old Path
	set(lobj,'Color',[0 .5 0]);
	set(mobj,'MarkerFaceColor','none','MarkerEdgeColor',[0 0 1]);
	
	
	% Process the click on the axis
	if treeflag==4 | treeflag ==5 | treeflag == 6
		if(-1 == treeguistate('stateclick'))
			% restore old colors
			set(lobj,'Color',OldColor);
			set(mobj,'MarkerFaceColor',OldColor,'MarkerEdgeColor',OldColor);
			return
		end
	else
		bushguistate('stateclick');
	end
	
	% Get current tree and portfolio data
	F = gcf;
	portobj = findobj(gcf,'Tag','portfolio');
	if ~isempty(portobj)
		Port = get(portobj,'Userdata');
	end
	
	% Unmark all selections
	thobj = findobj('Linewidth',2);
	set(thobj,'Linewidth',1)
	
	
	NewPath = getappdata(ChooserH, 'NewPath');
	if isempty(NewPath)
		NewPath = 1;
	end
	
	% Take back any previous changes if we're building a path
	if ~NewPath
		curpath = 1-curpath;
	end
	
	% Switch paths only if we're dealing with a new path
	if(NewPath)
		
		if ~curpath   %PathOne
			setappdata(ChooserH,'CurrentPathNumber',1)   %PathTwo is next  					
		else          %PathTwo
			setappdata(ChooserH,'CurrentPathNumber',0)  %PathOne is next    							
		end				
	end
	
	ptobj = sort(findobj('Userdata','PathTwo'));
	poobj = sort(findobj('Userdata','PathOne'));
	
	%Get selected data
	sdat = getappdata(ChooserH,'Selection');
	sdat = sdat{:};
	sdat = sdat(:)';
	Ls = length(sdat);
	
	%Get selected instrument index
	iobj = findobj(gcf,'Tag','treeinstruments');
	instval = get(iobj,'Value');
	
	switch lower(getappdata(ChooserH,'HighlightMode'))
		
	case 'path'
		
		%Get price path data
		pathlist = sdat(ones(Ls,1),:);     
		pathlist = tril(pathlist);
		
		if(treeflag==4 | treeflag ==5 | treeflag == 6)
			dataall = treepath(treedata,pathlist);
		else
			dataall = bushpath(treedata,pathlist);
		end
		
		switch treeflag
		case {1, 4} 
			adat = dataall(logical(eye(size(dataall))));
		case {2, 5} 
			adat = dataall(instval,:);
        case 6
            if size(treedata{1}, 1) == 1
                adat = dataall(logical(eye(size(dataall))));             
            else
                adat = dataall(instval,:);
            end
		case 3
			adat = dataall;
		end
		
	case 'node'
		
		if(treeflag==4 | treeflag ==5 | treeflag == 6)
			[NLevels, NumPos, IsPriceTree] = treeshape(treedata);
			if(IsPriceTree)
				NumChild = [2*ones(1,NLevels-2) 1 0];
			else
				NumChild = [2*ones(1,NLevels-1) 0];			
			end
		else
			[dummy,NumChild] = bushshape(treedata);
		end
		
		NumChild = NumChild(Ls);
		pathlist = sdat(ones(NumChild+1,1),:);   %copy the list
		pathlist = [pathlist (0:NumChild)'];
		
		if (treeflag==4 | treeflag ==5 | treeflag == 6)
			dataall = treepath(treedata,pathlist);
		else
			dataall = bushpath(treedata,pathlist);
		end
		
		if isempty(findobj(gcf,'Tag','treeinstruments'))
			if (treeflag == 3)
				adat = dataall;
			else
				Mask = zeros(size(dataall));
				Mask(Ls,1) = 1;   %Parent
				Mask(Ls+1,2:size(dataall,2)) = 1;  %Children
				dat = dataall(logical(Mask));
				adat = dat;
			end
		else
			adat = dataall(instval,:);
		end
		
	end
	
	if isempty(findobj(gcf,'String','Node and Children','Value',1))
		
		if ~curpath    %Displaying PathOne and restoring PathTwo
			set(findobj(gca,'Userdata','PathOne'),'Userdata',[])
			poobj = sort([findobj(gcf,'Color',ColorOne);findobj(gcf,'MarkerFaceColor',ColorOne)]);
			set(poobj,'Userdata','PathOne','Linewidth',2)
			for i = 1:length(ptobj)
				x = find(ptobj(i) == poobj);
				ptobj(x) = 0;  
			end
			i = find(ptobj == 0);
			ptobj(i) = [];
			if ~isempty(ptobj)
				set(ptobj,'Userdata','PathTwo','Linewidth',2,'Color',ColorTwo,...
					'MarkerFaceColor',ColorTwo,'MarkerEdgeColor',ColorTwo)
			end
			
			%Store pathone data
			setappdata(gcf,'PathOne',adat);      
			
			%For plotting path one, target color is ColorOne, delete color is ColorOne
			TargetColor = ColorOne;
			DeleteColor = ColorOne;
			TextTag = 'PathOne';
			
		else           %Displaying PathTwo and restoring PathOne
			
			set(findobj(gca,'Userdata','PathTwo'),'Userdata',[])
			ptobj = sort([findobj(gcf,'Color',ColorTwo);findobj(gcf,'MarkerFaceColor',ColorTwo)]);
			set(ptobj,'Userdata','PathTwo','Linewidth',2)
			for i = 1:length(poobj)
				x = find(poobj(i) == ptobj);
				poobj(x) = 0;
			end
			i = find(poobj == 0);
			poobj(i) = [];
			if ~isempty(poobj)
				set(poobj,'Userdata','PathOne','Linewidth',2,'Color',ColorOne,...
					'MarkerFaceColor',ColorOne,'MarkerEdgeColor',ColorOne)
			end
			
			%Store pathtwo data
			setappdata(gcf,'PathTwo',adat);      
			
			%For plotting path two, target color is ColorTwo, delete color is ColorTwo
			TargetColor = ColorTwo;
			DeleteColor = ColorTwo;
			TextTag = 'PathTwo';
			
		end  
		
	end
	
	set(findobj(gca,'Color',ColorThree),'Userdata','NodeChildren','Linewidth',2)
	
	%Show path or display plot
	
	pathonedat = getappdata(gcf,'PathOne');
	pathtwodat = getappdata(gcf,'PathTwo');
	L1 = length(pathonedat);
	L2 = length(pathtwodat);
	L = max(L1,L2);
	tmp = NaN;
	tmppathone = tmp(ones(L,1),:);
	tmppathtwo = tmppathone;
	tmppathone(1:L1) = pathonedat;
	tmppathtwo(1:L2) = pathtwodat;
	thval = 1e-6;
	i = find(abs(tmppathone) < thval);
	tmppathone(i) = 0;
	i = find(abs(tmppathtwo) < thval);
	tmppathtwo(i) = 0;
	
	fstr = 4;    %num2str formating value
	tmp = '        ';
	pad = tmp(ones(L,1),:);
	obstime = (0:L-1)';
	timobj = findobj(gcf,'String','End Time');
	if isempty(timobj)  %Not a rate tree
		treedatastring = [pad(:,1:2) num2str(obstime,fstr) pad pad(:,1:5) num2str(tmppathone,fstr) pad(:,1:3) num2str(tmppathtwo,fstr)];
	else
		endtime = obstime+1;
		treedatastring = [pad(:,1:2) num2str(obstime,fstr) pad num2str(endtime,fstr) pad num2str(tmppathone,fstr) pad(:,1:3) num2str(tmppathtwo,fstr)];
	end
	
	%Display string
	set(findobj(gcf,'Tag','treedata'),'String',treedatastring,'Max',2,'Value',[])
	
	%Plot Data
	
	%Reset color if viewing node and children
	if ~isempty(findobj(gcf,'String','Node and Children','Value',1))
		TargetColor = ColorThree;
		DeleteColor = ColorThree;
		TextTag = 'NodeChildren';
	end
	
	%Get tree plotting axis and viewing axis
	aobj = findobj(gcf,'Tag','treeplot');
	hobj = findobj(gcf,'Tag','Chooser');
	
	%Get objects that represent current display (in TargetColor)
	lobj = findobj(hobj,'Color',TargetColor);
	nobj = findobj(hobj,'Markerfacecolor',TargetColor);
	cobj = findobj(hobj,'Markeredgecolor',TargetColor,'Markerfacecolor','none');
	lncobj = [lobj;nobj;cobj];
	
	dobj = get(aobj,'Children');
	delete([findobj(aobj,'Color',DeleteColor);...
			findobj(aobj,'Markerfacecolor',DeleteColor);...
			findobj(aobj,'Markeredgecolor',DeleteColor);...
			findobj(aobj,'Tag',TextTag)])    %Clear any existing display
	set(aobj,'Xlimmode','auto','Ylimmode','auto')
	
	%Make copy of objects in tree plot axis
	copyobj(lncobj,aobj);
	set(get(aobj,'Children'),'Buttondownfcn','')
	
	%Get line objects and node object
	lineobj = findobj(aobj,'Linestyle','-','Color',TargetColor);
	markerobj = findobj(aobj,'Markerfacecolor',TargetColor); 
	
	%Round price data for display
	adat = round(adat*100)/100;
	
	%If using plot option, display data at actual plot
	if ~isempty(findobj(gcf,'String','Plot','Value',1)) & ...
			isempty(findobj(gcf,'String','Node and Children','Value',1))
		for i = 1:length(lineobj)
			set(lineobj(i),'Ydat',[adat(i) adat(i+1)])
		end
		set(markerobj,'Ydat',[adat(length(adat))])
	end
	
	pobj = [lineobj;markerobj];
	
	%Adjust axis limits for better viewing
	xlim = get(aobj,'Xlim');
	ylim = get(aobj,'Ylim');
	set(aobj,'Xlim',[xlim(1) - 0.5 xlim(2) + 1],'Ylim',[ylim(1) - 0.05 ylim(2)+ 0.05])
	
	%Get data for plotting price/rate text
	xdat = get(pobj,'Xdata');
	try   %Multiple objects found
		tmpdat = [xdat{:}];
		L = length(tmpdat)-1;
		xdat = [tmpdat(1) tmpdat(2:2:L-2) tmpdat(L)];
	catch 
		%Single object found
	end
	ydat = get(pobj,'Ydata');
	try
		tmpdat = [ydat{:}];
		ydat = [tmpdat(1) tmpdat(2:2:L-2) tmpdat(L)];
	catch
		%Single object found
	end
	
	%Get pricing/rate information
	texdat = cellstr(num2str(adat(:),4));
	
	for i = 1:length(xdat)
		j = find(texdat{i} == ' ');
		texdat{i}(j) = [];    %Strip blank spaces for properly visualization
		text(xdat(i)+.2,ydat(i),texdat{i},'Parent',aobj,'Fontweight','bold','Tag',TextTag);
	end
	
	if ~isempty(findobj(gcf,'Style','radiobutton','String','Table','Value',1))  %Show data
		set(findobj(gcf,'Tag','treedata'),'Visible','on')
		set(aobj,'Visible','off')
	else     %Display plot
		set(findobj(gcf,'Tag','treedata'),'Visible','off')
		set(aobj,'Visible','on')
	end
	
case 'treeinstrument'
	
	%New instrument selected in tree viewer
	setappdata(gcf,'PathOne',[]),setappdata(gcf,'PathTwo',[])
	
	%Clear any previous plots in Plot display window and previous paths
	aobj = findobj(gcf,'Tag','treeplot');
	delete(get(aobj,'Children'))
	pathobjs = [findobj(gcf,'Userdata','PathOne');...
			findobj(gcf,'Userdata','PathTwo');...
			findobj(gcf,'Userdata','NodeChildren')];
	set(pathobjs,'Userdata',[],'Color',[0 .5 0],'Markerfacecolor','none',...
		'Markeredgecolor',[0 0 1],'Linewidth',1)
	
	% clear all selections
	if(treeflag==4 | treeflag ==5 | treeflag == 6)
		treeguistate('clear',findobj('Tag','Chooser')); 
	else
		bushguistate('clear',findobj('Tag','Chooser'));
	end	    
	
	set(findobj(gcf,'Style','listbox'),'String','')    
	
	
case 'radiobutton'
	
	t = get(gcbo,'Tag');
	r = findobj(gcf,'Tag',t);
	set(r,'Value',0);
	set(gcbo,'Value',1)
	rstr = get(gcbo,'String');
	
	%Continue for more complex actions in Initial Curve Window and Tree Viewer
	HJMTree = get(gcf,'Userdata');
	wstr = warning;
	warning off
	warning(wstr)
	%Rates = intenvget(HJMTree.RateSpec, 'Rates');    
	
	switch rstr
		
	case {'Path','Table'}
		
		%Enable Data/Plot choice
		set(findobj(gcf,'Tag','treeradio'),'Enable','on')
		
		%Get axes handle
		ChooserH = findobj(gcf,'Tag','Chooser');
		
		%Display data uicontrols if Data button chosen, otherwise do leave display alone
		if findobj(gcf,'String','Table','Value',1)
			set(findobj(gcf,'Userdata','pathtoroot'),'Visible','on')
			set(findobj(gcf,'Userdata','nodeandchildren'),'Visible','off')
			set(get(findobj(gcf,'Tag','treeplot'),'Children'),'Visible','off')
		end
		
		if strcmp(rstr,'Path')
			
			setappdata(ChooserH,'CurrentPathNumber',0)    %Reset path to PathOne
			
			%Set selection mode of nodes
			%Clear any previous plots in Plot display window and previous paths
			aobj = findobj(gcf,'Tag','treeplot');
			delete(get(aobj,'Children'))
			pathobjs = [findobj(gcf,'Userdata','PathOne');...
					findobj(gcf,'Userdata','PathTwo');...
					findobj(gcf,'Userdata','NodeChildren')];
			set(pathobjs,'Userdata',[],'Color',[0 .5 0],'Markerfacecolor','none',...
				'Markeredgecolor',[0 0 1],'Linewidth',1)
			if(treeflag==4 | treeflag ==5  | treeflag == 6)
				treeguistate('clear',ChooserH); % clear all selections
			else
				bushguistate('clear',ChooserH); % clear all selections
			end
			
			if get(findobj(gcf,'String','Path'),'Value')
				setappdata(ChooserH, 'HighlightMode', 'path' );
			else
				setappdata(ChooserH,'HighlightMode','node');
			end
			
			%Set colors for paths, (taken from bushguistate)
			ColorOrder = get(gca,'ColorOrder');
			ColorOrder(3:4,:) = [ColorOne;ColorTwo];
			ColorOrder(5:end,:) = [];
			
			ColorState = ColorOrder(1,:); % Color of state markers
			ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
			ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
			ColorSelectInd = 1; % Location of next color in ColorSelectOrder
			
			setappdata(ChooserH, 'ColorState', ColorState);
			setappdata(ChooserH, 'ColorLine',  ColorLine);
			setappdata(ChooserH, 'ColorSelectOrder', ColorSelectOrder);
			setappdata(ChooserH, 'ColorSelectInd',   ColorSelectInd);
			
		end
		
	case {'Node and Children','Diagram','Plot'}  
		
		ChooserH = findobj(gcf,'Tag','Chooser');
		
		%Disable display option for node and children
		if strcmp(rstr,'Node and Children')
            % first, clear data used in data table
            setappdata(gcf,'PathOne', []);
            setappdata(gcf,'PathTwo', []);
            
			set(findobj(gcf,'Tag','treeradio'),'Enable','off')
			set(findobj(gcf,'String','Table'),'Value',0)
			set(findobj(gcf,'String','Diagram'),'Enable','off','Value',1)
			set(findobj(gcf,'String','Plot'),'Enable','off','Value',0)
			
			%Clear any previous plots in Plot display window and previous paths
			aobj = findobj(gcf,'Tag','treeplot');
			delete(get(aobj,'Children'))
			pathobjs = [findobj(gcf,'Userdata','PathOne');...
					findobj(gcf,'Userdata','PathTwo');...
					findobj(gcf,'Userdata','NodeChildren')];
			set(pathobjs,'Userdata',[],'Color',[0 .5 0],'Markerfacecolor','none',...
				'Markeredgecolor',[0 0 1],'Linewidth',1)
			
			if (treeflag==4 | treeflag ==5 | treeflag == 6)
				treeguistate('clear',ChooserH); % clear all selections
			else
				bushguistate('clear',ChooserH); % clear all selections
			end
			
		end  
		
		set(findobj(gcf,'Userdata','pathtoroot'),'Visible','off')
		set(findobj(gcf,'Userdata','nodeandchildren'),'Visible','on')
        set(get(findobj(gcf,'Tag','treeplot'),'Children'),'Visible','on')
		
		if ~any(strcmp(rstr,{'Diagram','Plot'}))
			setappdata(ChooserH,'CurrentPathNumber',0)    %Reset path to PathOne
		end  
		
		%Set selection mode of nodes
		if get(findobj(gcf,'String','Path'),'Value')
			setappdata(ChooserH, 'HighlightMode', 'path' );
		else
			setappdata(ChooserH,'HighlightMode','node');
		end
		
		%Path colors, Node and children uses one color only
		if isempty(findobj(gcf,'String','Path','Value',1))  
			ColorOrder = get(gca,'ColorOrder');
			ColorOrder(3,:) = ColorThree;
			ColorOrder(4:end,:) = [];
			ColorState = ColorOrder(1,:); % Color of state markers
			ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
			ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
			ColorSelectInd = 1; % Location of next color in ColorSelectOrde
			setappdata(ChooserH, 'ColorState', ColorState);
			setappdata(ChooserH, 'ColorLine',  ColorLine);
			setappdata(ChooserH, 'ColorSelectOrder', ColorSelectOrder);
			setappdata(ChooserH, 'ColorSelectInd',   ColorSelectInd);    
			
			%Turn off PathOne and PathTwo
			pobj = [findobj(gca,'Userdata','PathOne');findobj(gca,'Userdata','PathTwo')];
			set(pobj,'Linewidth',1,'Color',ColorOrder(2,:),'Markerfacecolor','none',...
				'Markeredgecolor',ColorOrder(1,:))
			set(findobj(gca,'Linewidth',2),'Linewidth',1)
			
		end
		
		if any(strcmp(rstr,{'Diagram','Plot'}))
			
			if isempty(findobj(gcf,'String','Node and Children','Value',1))
				
				%Get price and tree data
				P = getappdata(gcf,'PriceData');
				Tree = getappdata(gcf,'TreeData');
				
				rflag = isempty(findobj(gcf,'Tag','treeinstruments'));

% 				if isempty(P) & ~rflag
% 					%No paths to move
% 					set(findobj('Type','figure'),'Pointer','arrow')
% 					return
% 				end
				
				%Get existing price text 
				aobj = findobj(gcf,'Tag','treeplot');
				tobj = findobj(aobj,'Type','text');
				pstr = get(tobj,'String');
				
				%Get paths
				poobj = findobj(ChooserH,'UserData','PathOne');
				ptobj = findobj(ChooserH,'UserData','PathTwo');
				
				% It may occur that the last node on both paths are
				% the same. In that case, the last path wins and the 
				% other path will conatain the marker handle. In that
				% case the, on of the handle lists returned above will
				% not conatin a marker - BTW, this only happend with
				% recombining trees
				if(treeflag == 4 | treeflag == 5 | treeflag == 6)
					if isempty(strmatch('o', get(poobj, 'Marker'), 'exact'))
						% path one contains no market. Must add path two's 
						% marker
						poobj = [ptobj(strmatch('o', get(ptobj, 'Marker'), 'exact')); poobj];
					elseif isempty(strmatch('o', get(ptobj, 'Marker'), 'exact'))
						% path two contains no market. Must add path one's 
						% marker
						ptobj = [poobj(strmatch('o', get(poobj, 'Marker'), 'exact')); ptobj];
					end
				end
				
				
				%Get ydata
				poydat = get(poobj,'Ydata');
				ptydat = get(ptobj,'Ydata');
				
				%Get number of path one and path two objects
				numpo = length(poobj);
				numpt = length(ptobj);
				
				%Get new path one and path objects
				newpoobj = findobj(aobj,'Userdata','PathOne','Linewidth',2);
				newptobj = findobj(aobj,'Userdata','PathTwo','Linewidth',2);
				
				%Build ydata and text positions
				switch rstr
					
				case 'Diagram'
					
					lyo = length(poydat);
					if lyo > 1
						poydat = [poydat(1);flipud(poydat(2:end))];
					end
					lyt = length(ptydat);
					if lyt > 1
						ptydat = [ptydat(1);flipud(ptydat(2:end))];
					end
					
					try
						todat(1) = poydat{2}(1);
						for i = 2:length(poydat)
							todat(i) = poydat{i}(2);
						end
					catch
						todat = poydat;
					end
					
					try
						ttdat(1) = ptydat{2}(1);
						for i = 2:length(ptydat)
							ttdat(i) = ptydat{i}(2);
						end
					catch
						ttdat = ptydat;
					end
					
					alldat = [todat(:);ttdat(:)];
					
					ylim = [min(alldat)-0.05 max(alldat)+0.05];
					
				case 'Plot'
					
					%Get current path to determine how price data is order
					curpath = getappdata(ChooserH,'CurrentPathNumber');
					
					%Convert price strings to numbers
					pdat = str2num(char(pstr));
					
					lpo = length(newpoobj);
					lpt = length(newptobj);
					
					poydat = [];
					ptydat = [];
					if curpath   %PathOne
						pdat(1:lpo) = pdat(lpo:-1:1);
						for i = 1:lpo
							if strcmp(get(newpoobj(i),'Marker'),'o')    %Set PathOne ydata
								try, poydat{i} = pdat(lpo); catch, poydat(i) = pdat(lpo); end
							else
								poydat{i} = [pdat(i-1) pdat(i)];
							end
						end
						pdat(lpo+1:lpo+lpt) = pdat(lpo+lpt:-1:lpo+1);
						for i = lpt:-1:1
							if strcmp(get(newptobj(i),'Marker'),'o')    %Set PathTwo ydata
								try, ptydat{i} = pdat(lpo+lpt); catch, ptydat(i) = pdat(lpo+lpt); end
							else
								ptydat{i} = [pdat(i-1+lpo) pdat(i+lpo)];
							end
						end
						
						todat = pdat(1:lpo);
						ttdat = pdat(1+lpo:lpt+lpo);
						
					else    %PathTwo
						pdat(1:lpt) = pdat(lpt:-1:1);
						for i = lpt:-1:1
							if strcmp(get(newptobj(i),'Marker'),'o')    %Set PathTwo ydata
								try, ptydat{i} = pdat(lpt); catch, ptydat(i) = pdat(lpt); end
							else
								ptydat{i} = [pdat(i-1) pdat(i)];
							end
						end
						pdat(lpt+1:lpt+lpo) = pdat(lpt+lpo:-1:lpt+1);
						for i = lpo:-1:1
							if strcmp(get(newpoobj(i),'Marker'),'o')    %Set PathOne ydata
								try, poydat{i} = pdat(lpt+lpo); catch, poydat(i) = pdat(lpt+lpo); end
							else
								poydat{i} = [pdat(i-1+lpt) pdat(i+lpt)];
							end
						end
						
						ttdat = pdat(1:lpt);
						todat = pdat(1+lpt:lpo+lpt);
						
					end
					
					ylim = [min(pdat)-5 max(pdat)+5];
					
					if rflag   %Adjust ylimit settings for interest rate values
						ylim = [min(pdat)-0.05 max(pdat)+0.05]; 
					end
					
				end
				
				if isempty(ylim)   %No paths to display
					set(findobj('Type','figure'),'Pointer','arrow')
					return
				end
				
				%Check length mismatches between visible objects and ydata
				lpo = length(newpoobj);
				lyo = length(poydat);
				lpt = length(newptobj);
				lyt = length(ptydat);
				if lyo == 0   %Node of PathOne is hidden
					poydat = ptydat;
					todat = ttdat;
				end
				if lyt == 0   %Node of PathTwo is hidden
					ptydat = poydat;
					ttdat = todat;
				end
				if lpo ~= lyo & lyo ~= 0  %Fill missing pieces of PathOne
					try
						poydat = [poydat(1);ptydat(2:2+(lpo-lyo-1));poydat(2:end)];
					catch
						poydat = [{poydat(1)};ptydat(2:2+(lpo-lyo-1))];
					end
					todat = [ttdat(1:lpo-lyo)';todat(:)];
				end
				if lpt ~= lyt & lyt ~= 0    %Fill missing pieces of PathTwo
					try
						ptydat = [ptydat(1);poydat(2:2+(lpt-lyt-1));ptydat(2:end)];
					catch
						ptydat = [{ptydat(1)};poydat(2:2+(lpt-lyt-1))];
					end
					ttdat = [todat(1:lpt-lyt)';ttdat(:)];
				end
				
				try, set(newpoobj,{'Ydata'},poydat(:)), catch, set(newpoobj,'Ydata',poydat), end
				try, set(newptobj,{'Ydata'},ptydat(:)), catch, set(newptobj,'Ydata',ptydat), end
				
				%Reset y position of text objects
				toobj = sort(findobj(aobj,'Type','text','Tag','PathOne'));
				ttobj = sort(findobj(aobj,'Type','text','Tag','PathTwo'));
				for i = 1:length(toobj)
					p = get(toobj(i),'Position');
					set(toobj(i),'Position',[p(1) todat(i) p(3)])
				end
				for i = 1:length(ttobj)
					p = get(ttobj(i),'Position');
					set(ttobj(i),'Position',[p(1) ttdat(i) p(3)])
				end
				
			end
			
			set([newpoobj;newptobj;toobj;ttobj],'Visible','on')
			set(aobj,'Ylim',ylim)
			
		end
	end
	
end
