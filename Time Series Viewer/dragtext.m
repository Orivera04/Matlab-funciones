function dragtext(hObject);
% Enable text to be dragged
% Set dragtext(gco) as the text's buttondownfcn

un = get(hObject ,'Units');
set(hObject,'Units','pixels');
rect = [get(hObject,'Extent')];
set(hObject,'Units',un);

%Add axes offset to rect.  pixels are measured relative to lower left
%corner of axes.
ax = get(hObject,'Parent');
un = get(ax ,'Units');
set(ax,'Units','pixels');
pos = get(ax,'Position');
rect(1:2) = rect(1:2) + pos(1:2);   %Relative to figure window, not axes


%Get initial mouse position.  This will help us drop the text nicely
cpi = get(gca,'CurrentPoint');
ext_data = get(hObject,'Extent');   %Get extent in data units


offset = cpi(1,1:2) - ext_data(1:2);


finalrect = dragrect(rect);
cp = get(gca,'CurrentPoint');       %This is a little sloppy, but easy
pt = cp(1,1:2)-offset;
if ishandle(hObject)
    set(hObject,'Position',pt);
end;

set(ax,'Units',un);     %Return axes to original units

%Testing code
if 0
    figure;plot(1:10);h = text(5,3,'test','BackgroundColor','y');
    set(h,'ButtonDownFcn','dragtext(gco)','VerticalAlignment','bottom');
end;

