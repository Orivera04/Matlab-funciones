function View = cgexprview(node,action,fH,View)
%CGEXPRVIEW  Draw a representation of the model connections
%
%  VIEW = CGEXPRVIEW(NODE,ACTION,FIG,VIEW)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.8.4.3 $  $Date: 2004/02/09 08:24:16 $


switch lower(action)
case 'create'
   View = i_create(node,fH,View);
case 'view'
   View = i_view(node,View);
end


function View = i_create(node,fH,View)

View.exprview.Axes = xregGui.scrollaxes('units' , 'pixels' , ...
   'parent' , fH , ...
   'color' , [1 1 1] , ...
   'Xzeromode','left',...
   'Yzeromode','top',...
   'visible','off');
set(double(View.exprview.Axes),'defaultTextClipping','on');

m = uicontextmenu('callback',@i_CheckContextMenu, 'parent', fH);
View.exprview.Viewmenu = uimenu(m,'label','View this model', 'callback' ,@i_ContextViewThis);
View.exprview.Propmenu = uimenu(m,'label','Properties...', 'callback' ,@i_EditInputs);
View.exprview.Contextmenu = m;


%---------------------------------------------
function i_EditInputs(ignore1, ignore2)

CGBH = cgbrowser;
nodeptr = CGBH.currentnode;

diagram_obj = gco;
if ~isempty(gco)
    tag = sscanf(get(diagram_obj,'tag'),'%d',1);
    this = assign(xregpointer,tag);
    if this.isa('cgmodexpr')
        % Find the primary node associated with this model
        [newnode, OK] = editinputs(nodeptr.info, this);
        if OK
            % update this node in list
            mdlnodes = findprimarynode(nodeptr.project, this);
            if ~isempty(mdlnodes)
                CGBH.doDrawList('update',mdlnodes);
                % update this view
                node = nodeptr.info;
                View=CGBH.getViewData;
                View = show(node,CGBH,View);
                View = view(node,CGBH,View);
                CGBH.setViewData(View);
            end
        end        
    end
end



%---------------------------------------------
function View = i_view(node,View)

ptr = getdata(node);
axH = double(View.exprview.Axes);

c = get(axH , 'children');
delete(c);

% for each input, get the pointer, level and parent
[plist,level,parent] = layerinfo(ptr.info,2,ptr);
plist = [ptr plist];
level = [1 level];
parent = [xregpointer parent];

nlevels = max(level);

% find the number of unique items on each level 
for i = 1:nlevels
   levelind = find(level==i); % indices in plist of the items in level i
   level_ptrs = plist(levelind);
   uniqlevel_ptrs = unique(level_ptrs);   
   % number of items on each level
   nlevelitems(i) = length(uniqlevel_ptrs);
end

% what is the maximum number of items on any level
maxlevelitems = max(nlevelitems);

% determine the total space for the connections 
% The additional 30 adds space at the left and the bottom
axiswidth = 130*nlevels +30;
axisheight = 80*maxlevelitems + 30;

set(View.exprview.Axes,'xlim',[0 axiswidth],'ylim',[0 axisheight]);

sortplist = [];
parentind = [];
line_coords = [];
for i = 1:nlevels
   levelind = find(level==i); % indices in plist of the items in level i
   level_ptrs = plist(levelind);
   level_parents = parent(levelind);
   
   [uniqlevel_ptrs, ind, jind] = unique(level_ptrs);   
   
   for j = 1:length(uniqlevel_ptrs)
      ind = find(uniqlevel_ptrs(j) == level_ptrs);
      parentsj = level_parents(ind);
      
      % find the parents in the above level list
      [junk, parind] = intersect(double(sortplist(sum(nlevelitems(1:i-2))+1:sum(nlevelitems(1:i-1)))),double(parentsj));
      % index of the parents in sortplist 
      parentind = [parentind {sum(nlevelitems(1:i-2)) + parind}];
   end
   
   sortplist = [sortplist uniqlevel_ptrs];
   for j = 1:nlevelitems(i)
      level_line_coords(j,:) = [axiswidth+50-(i*130),axisheight+15-(j*80)];
      line_coords = [line_coords; level_line_coords(j,:)]; % middle of the block
   end   
end

%connect each item in the level to its parent
i_DrawLines(sortplist,parentind,line_coords,axH);

for k = 1:length(sortplist)
   % call an object method to get the shape & color of blocks
   rh = block(sortplist(k).info, axH);
   % add a context menu to models
   if sortplist(k).isddvariable
      ContextMenu = [];
   else
      ContextMenu = View.exprview.Contextmenu;
   end
   set(rh, 'position',[line_coords(k,1)-50, line_coords(k,2)-15,100,30],...
      'uicontextmenu',ContextMenu,...
      'tag',sprintf('%d',double(sortplist(k))));		
   name = sortplist(k).getname;
   if length(name) > 18
      name = [name(1:16),'...'];
   end
   text('parent', axH,...
      'position',[line_coords(k,1)-45, line_coords(k,2)],...
      'interpreter','none',...
      'string',name,...
      'uicontextmenu',ContextMenu,...
      'tag',sprintf('%d',(double(sortplist(k)))),...
      'fontname','monospaced',...
      'fontsize',7,...
      'visible','off');            
end

c = get(axH , 'children');
set(c,'visible',get(axH,'visible'));


%---------------------------------------------
function i_DrawLines(ptr,parentind,line_coords, axH)


for i = 1:length(ptr)
   parent_coords = line_coords(parentind{i},:);
   if ~isempty(parent_coords)
      node_coords = line_coords(i,:);
      
      % draw the line connecting the nodes
      for j =1:size(parent_coords,1) % can have more than one parent
         line('XData',[node_coords(1),parent_coords(j,1)],...
            'YData',[node_coords(2),parent_coords(j,2)],...
            'parent', axH,...
            'color','k',...
            'linewidth',1,...
            'visible','off');
         
         x(1)= node_coords(1);
         x(2)= parent_coords(j,1);
         y(1)= node_coords(2);
         y(2)= parent_coords(j,2);
         
         k= 9;    %scale factor for arrow  size
         k2 = 4;   %scale factor for arrow width
         delx = x(2)-x(1);
         dely = y(2)-y(1);
         
         len =(delx^2 +dely^2)^.5;
         
         %normalised gradient
         dx = delx/len;
         dy = dely/len;
         
         %find midpoint
         x(3) = 0.5*(x(1)+x(2));
         y(3) = 0.5*(y(1)+y(2));
         
         %step back a distance k from midpoint along line
         x(4) = x(3)-k*dx;
         y(4) = y(3)-k*dy;
         
         %step out to the sides 
         x(5) = x(4) + k2*dy;
         y(5) = y(4) - k2*dx;
         
         x(6) = x(4) - k2*dy;
         y(6) = y(4) + k2*dx;
         
         % add the arrow
         arrx = [x(3) x(5) x(6) x(3)];
         arry = [y(3) y(5) y(6) y(3)];
         
         % create a polygonal patch (arrow)
         patch('xdata',arrx,'ydata', arry,'facecolor','k','edgecolor','k','parent',axH, 'visible','off');
      end
      
   end
end 


%---------------------------------------------
% obj is the top level menu
function i_CheckContextMenu(obj,unused)
CGBH = cgbrowser;
CurrNode = CGBH.currentnode;
CurrModel = CurrNode.getdata;


submenus = get(obj,'children');
diagram_obj = gco;
if ~isempty(gco)
   tag = sscanf(get(diagram_obj,'tag'),'%d',1);
   this = assign(xregpointer,tag);
   if this.isa('cgmodexpr')
      set(submenus(1),'enable','on');
      if this == CurrModel
         set(submenus(2),'enable','off');
      else
         set(submenus(2),'enable','on');
      end
   else
      set(submenus,'enable','off');
   end
else
   set(submenus,'enable','off');
end



%---------------------------------------------
% Callback from the "View this model" item on the popup menu
function i_ContextViewThis(unused1,unused2)

CGBH = cgbrowser;
cn = CGBH.currentnode;

diagram_obj = gco;
if ~isempty(gco)
   tag = sscanf(get(diagram_obj,'tag'),'%d',1);
   this = assign(xregpointer,tag);
   proj=cn.project;
   modnodes = filterbytype(proj,cn.typeobject);
   for k = 1:length(modnodes)
      M = getdata(modnodes{k});
      if M == this
         CGBH.CurrentNode = address(modnodes{k});
         break
      end
   end   
end
