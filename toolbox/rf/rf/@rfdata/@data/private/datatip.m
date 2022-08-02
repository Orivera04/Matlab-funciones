function datatip(h, fig, hLines)

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/03/30 13:11:41 $

if fig == -1; fig = gcf; end;
for k=1:length(hLines)
    % Customize datatip string for this line using behavior object
    hBehavior = hggetbehavior(hLines(k),'DataCursor');
    set(hBehavior,'UpdateFcn',{@localStringFcn, h, hLines(k)});
end

% Force datatips to interpolate based on the mouse position
% This is global to the figure
hDataCursorTool = datacursormode(fig);
set(hDataCursorTool,'SnapToDataVertex','off'); 
hBehavior = hggetbehavior(gca,'Rotate3d');
set(hBehavior,'Enable',false);

function [str] = localStringFcn(hHost, hDataCursor, rfdata, hLine)
% Format the datatip string to our liking
pos = get(hDataCursor,'Position');
dindex = get(hDataCursor,'DataIndex');
dfactor = get(hDataCursor,'InterpolationFactor');
% Get the RFDATA object and the current plotted data
linesinfo = rfdata.LinesInformation;
for k=1:length(linesinfo)
    lineinfo = linesinfo{k};
    hline = lineinfo.LineHandle;
    if hLine == hline
        break;
    end
end
ptype = lineinfo.PType;
name = lineinfo.Name;
data = lineinfo.Data;
xname = lineinfo.Xname;
format = lineinfo.Format;
type = lineinfo.Type;
% Get information for datatip
[xname, xdata, xunit] = xaxis(rfdata, ptype, format, []);
xd = 0.0;
if abs(dfactor) <= eps 
    xd = xdata(dindex);
elseif dfactor > 0.0 && dindex > 1
    xd = xdata(dindex) - dfactor * (xdata(dindex)-xdata(dindex-1));
elseif dfactor < 0.0 && dindex < length(xdata)
    xd = xdata(dindex) - dfactor * (xdata(dindex+1)-xdata(dindex));
else
    xd = xdata(dindex);
end
% Updated datatip
str{1} = sprintf(sprintf('%s = %s%s', xname, num2str(xd), xunit));
if pos(2) > 0.0
    str{2} = sprintf(sprintf('%s = %s+j%s', name, num2str(pos(1)), num2str(pos(2))));
else
    str{2} = sprintf(sprintf('%s = %s-j%s', name, num2str(pos(1)), num2str(-pos(2))));
end
return;
switch type
case {'Z Smith chart' 'ZY Smith chart'}
    z = complex(1+pos(1), pos(2))/complex(1-pos(1), -pos(2));
    if imag(z) > 0.0
        str{3} = sprintf(sprintf('Z = %s+j%s', num2str(real(z)), num2str(imag(z))));
    else
        str{3} = sprintf(sprintf('Z = %s-j%s', num2str(real(z)), num2str(-imag(z))));
    end
case {'Y Smith chart' 'YZ Smith chart'}
    y = complex(1-pos(1), -pos(2))/complex(1+pos(1), pos(2));
    if imag(y) > 0.0
        str{3} = sprintf(sprintf('Y = %s+j%s', num2str(real(y)), num2str(imag(y))));
    else
        str{3} = sprintf(sprintf('Y = %s-j%s', num2str(real(y)), num2str(-imag(y))));
    end
otherwise
end