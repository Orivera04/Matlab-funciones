function dddrag
%dddrag     Implement the dragging functionality of dragndrop interface

source = gcbo;
hFig = get(source,'Parent');    %This restricts the application to uicontrols and axes
%Check the parent.  If it's an axes, not a figure, we do a little
%manipulation.  This allows you to drag an axes by grabbing one of it's
%lines.
if strcmp(get(hFig,'Type'),'axes')
    source = hFig;              %Assign the parent axes to source
    hFig = get(hFig,'Parent');
end;



%dragrect works with rect specified in pixels.  Odd, since it returns
%values in the host figure's units.
un = get(source ,'Units');
set(source,'Units','pixels');
rect = [get(source,'Position')];
finalrect = dragrect(rect);
set(source,'Units',un);

%For testing only - move the block to the drop location
%set(gcbo,'Position',finalrect(1,:));        %Main button

%Test for presence of drop target
%We look at mouse position, see if it is inside any drop targets
cpos = get(hFig,'CurrentPoint');

%Target Positions
dd = getappdata(hFig,'dragndrop');   %Get object
dl = get(dd,'DropLocations');   % Targets * (x,y) * 5 point polygon
ndrops = length(dl(:,1,1));     %Number of drop targets
Drops = get(dd,'DropHandles');  %Handles to drop targets
DropCallbacks = get(dd,'DropCallbacks');
DropValidDrag = get(dd,'DropValidDrag');

%Check each drop
for ii=1:ndrops
    xv = squeeze(dl(ii,1,:));   %X Values of drop target
    yv = squeeze(dl(ii,2,:));   %Y Values of drop target
    if inpolygon(cpos(1),cpos(2),xv,yv)
        %Now, check if this is a valid drop target for this drag source
        target = ii;
        validdrag = DropValidDrag{ii};
        if ismember(source,validdrag)
            
            %Evaluate callback
            %disp(['Hit!  Target: ' num2str(Drops(ii))]);   %Testing
            feval(DropCallbacks{target},source,Drops(target));
            
            continue  %Break out of loop
        else % Not a valid target
            % disp('Nice try, but that isn''t a valid target!')
            ptr = get(gcf,'Pointer');
            P = no_icon;
            set(gcf,'Pointer','custom');
            set(gcf,'PointerShapeCData',P,'PointerShapeHotSpot',[9 9]);
            pause(.2)
            set(gcf,'Pointer',ptr);
        end;
        
        
    end;
end;


function P = no_icon;
% Create icon for mouse pointer indicating target isn't valid
P=[  2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
     2     2     2     2     2     2     2     1     1     2     2     2     1     2     2     2
     2     2     2     2     2     1     1     2     2     1     1     1     2     2     2     2
     2     2     2     2     1     2     2     2     2     2     1     1     2     2     2     2
     2     2     2     2     1     2     2     2     2     1     2     1     2     2     2     2
     2     2     2     1     2     2     2     2     1     2     2     2     1     2     2     2
     2     2     2     1     2     2     2     1     2     2     2     2     1     2     2     2
     2     2     2     2     1     2     1     2     2     2     2     1     2     2     2     2
     2     2     2     2     1     1     2     2     2     2     2     1     2     2     2     2
     2     2     2     2     1     1     1     2     2     1     1     2     2     2     2     2
     2     2     2     1     2     2     2     1     1     2     2     2     2     2     2     2
     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2];