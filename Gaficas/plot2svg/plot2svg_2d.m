function varargout=plot2svg(param1,id,pixelfiletype)
%  Matlab to SVG converter
%  Only 2D plots are currently supported
%
%  Usage: plot2svg(filename,graphic handle,pixelfiletype)
%                  optional     optional     optional
%         or
%
%         plot2svg(figuresize,graphic handle,pixelfiletype)
%                   optional     optional      optional
%
%         pixelfiletype = 'png' (default), 'jpg'
%
%  Juerg Schwizer 23-Oct-2005
%
%  07.06.2005 - Bugfix axxindex (Index exceeds matrix dimensions)
%  19.09.2005 - Added possibility to select output format of pixel graphics
%  23.10.2005 - Bugfix cell array strings (added by Bill)
%               Handling of 'hggroups' and improved grouping of objects
%               Improved handling of pixel images (indexed and true color pictures)
%  23.10.2005 - Switched default pixelfromat to 'png'
%  07.11.2005 - Added handling of hidden axes for annotations (added by Bill)
%  03.12.2005 - Bugfix of viewBox to make Firefox 1.5 working
%  04.12.2005 - Improved handling of exponent values for log-plots
%               Improved markers
%  09.12.2005 - Bugfix '<' '>' '?' '"'
%
global PLOT2SVG_globals
global colorname
global fixcolorptr
progversion='09-Dec-2005';
if nargout==1
    varargout={0};
end
disp(['   Matlab to SVG converter version ' progversion ', Juerg Schwizer (converter@juergschwizer.de).'])
matversion=version;
if str2num(matversion(1))<6 % Check for matlab version and print warning if matlab version lower than version 6.0 (R.12)
    disp('   Warning: Future versions may no more support older versions than MATLAB R12.')
end
if nargout > 1
    error('Function returns only one return value.')
end
if nargin<2 % Check if handle was included into function call, otherwise take current figure
    id=gcf;
end
if nargin==0
    [filename, pathname] = uiputfile( {'*.svg', 'SVG File (*.svg)'},'Save Figure as SVG File');
    if ~( isequal( filename, 0) | isequal( pathname, 0))    
        % yes. add backslash to path (if not already there)
        pathname = addBackSlash( pathname); 
        % check, if extension is allrigth
        if ( ~strcmpi( getFileExtension( filename), '.svg'))
            filename = [ filename, '.svg'];
        end
        finalname=[pathname filename];
    else
        disp('   Cancel button was pressed.')
        return
    end
else
    if isnumeric(param1)
        [filename, pathname] = uiputfile( {'*.svg', 'SVG File (*.svg)'},'Save Figure as SVG File');  
        if ~( isequal( filename, 0) | isequal( pathname, 0))    
            % yes. add backslash to path (if not already there)
            pathname = addBackSlash( pathname); 
            % check, if ectension is allrigth
            if ( ~strcmpi( getFileExtension( filename), '.svg'))
                filename = [ filename, '.svg'];
            end
            finalname=[pathname filename];
        else
            disp('   Cancel button was pressed.')
            return
        end     
    else
        finalname=param1;   
    end
end
% needed to see annotation axes
originalShowHiddenHandles = get(0, 'ShowHiddenHandles');
set(0, 'ShowHiddenHandles', 'on');
originalFigureUnits=get(id,'Units');
set(id,'Units','pixels');   % All data in the mif-file is saved in pixels
paperpos=get(id,'Position');
if ( nargin > 0)
    if isnumeric(param1)
        paperpos(3)=param1(1);
        paperpos(4)=param1(2);
    end
end
if (nargin < 3)
    PLOT2SVG_globals.pixelfiletype = 'png';
else
    PLOT2SVG_globals.pixelfiletype = pixelfiletype;
end
cmap=get(id,'Colormap');
colorname='';
for i=1:size(cmap,1)
    colorname(i,:)=sprintf('%02x%02x%02x',fix(cmap(i,1)*255),fix(cmap(i,2)*255),fix(cmap(i,3)*255));
end

% Open SVG-file
[pathstr,name,ext,versn] = fileparts(finalname);
%PLOT2SVG_globals.basefilename = fullfile(pathstr,name);
PLOT2SVG_globals.basefilepath = pathstr;
PLOT2SVG_globals.basefilename = name;
PLOT2SVG_globals.figurenumber = 1;
fid=fopen(finalname,'wt');   % Create a new text file
fprintf(fid,'<?xml version="1.0" standalone="no"?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n');    % Insert file header
%fprintf(fid,'<svg width="%0.3fpx" height="%0.3fpx" viewBox="0px 0px %0.3fpx %0.3fpx" ',paperpos(3),paperpos(4),paperpos(3),paperpos(4));
%fprintf(fid,'<svg preserveAspectRatio="xMinYMin meet" width="%0.3fpx" height="%0.3fpx" viewBox="0px 0px %0.3fpx %0.3fpx" ',paperpos(3),paperpos(4),paperpos(3),paperpos(4));
fprintf(fid,'<svg preserveAspectRatio="xMinYMin meet" width="100%%" height="100%%" viewBox="0 0 %0.3f %0.3f" ',paperpos(3),paperpos(4));
fprintf(fid,'  version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">\n');
fprintf(fid,'  <desc>Matlab Figure Converted by PLOT2SVG written by Juerg Schwizer</desc>\n');
group=1;
groups=[];
axfound=0;
% Frame of figure
figcolor = searchcolor(id,get(id, 'Color'));
if (~ strcmp(figcolor, 'none'))
    % Draw rectangle in the background of the graphic frame to cover all
    % other graphic elements
    if strcmp(get(id,'InvertHardcopy'),'on')
        fprintf(fid,'  <rect x="0" y="0" width="%0.3f" height="%0.3f" fill="#ffffff" stroke="none" />\n',paperpos(3),paperpos(4));
    else
        fprintf(fid,'  <rect x="0" y="0" width="%0.3f" height="%0.3f" fill="%s" stroke="none" />\n',paperpos(3),paperpos(4),figcolor);
    end
end
% Search all axes
ax=get(id,'Children');
for j=length(ax):-1:1
    currenttype = get(ax(j),'Type');
    if strcmp(currenttype,'axes')
        group=group+1;
        groups=[groups group];
        group=axes2mif(fid,id,ax(j),group,paperpos);
        axfound=1;
    elseif strcmp(currenttype,'uicontrol')
        if strcmp(get(ax(j),'Visible'),'on')
            control2mif(fid,id,ax(j),group,paperpos);
            axfound=1;
        end
    elseif strcmp(currenttype, 'uicontextmenu') || ...
            strcmp(currenttype, 'uimenu') || ...
            strcmp(currenttype, 'hgjavacomponent') || ...
            strcmp(currenttype, 'uitoolbar')
        % ignore these types
    else
        disp(['   Warning: Unhandled main figure child type: ' currenttype]);
    end
end
fprintf(fid,'</svg>\n');
fclose(fid);    % close text file
if nargout==1
    varargout={0};
end
set(id,'Units',originalFigureUnits);
set(0, 'ShowHiddenHandles', originalShowHiddenHandles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUBFUNCTIONS %%%%%
% Create axis frame and insert all children of this axis frame
function group=axes2mif(fid,id,ax,group,paperpos)
global fixcolorptr
global colorname
global PLOT2SVG_globals
originalAxesUnits=get(ax,'Units');
set(ax,'Units','normalized');
groupax=group;
axlimx=get(ax,'XLim');
axlimy=get(ax,'YLim');
axlimxori=axlimx;
axlimyori=axlimy;
if strcmp(get(ax,'XScale'),'log')
    axlimx=log10(axlimx);
    axlimx(find(isinf(axlimx)))=0;
end
if strcmp(get(ax,'YScale'),'log')
    axlimy=log10(axlimy);
    axlimy(find(isinf(axlimy)))=0;
end
axlimori=[axlimxori(1) axlimyori(1) axlimxori(2)-axlimxori(1) axlimyori(2)-axlimyori(1)];
axlim=[axlimx(1) axlimy(1) axlimx(2)-axlimx(1) axlimy(2)-axlimy(1)];
axpos=get(ax,'Position');
if (strcmp(get(ax,'PlotBoxAspectRatioMode'),'manual') || strcmp(get(ax,'DataAspectRatioMode'),'manual'))
    aspect_ratio = get(ax,'PlotBoxAspectRatio');
    %%%%%%%%%%%%%%%%% Start of changes by Bill
    % size the box correctly and center it in the axis that is smaller than
    % the position width or height
    if axpos(3)*aspect_ratio(2)*paperpos(3) < axpos(4)*aspect_ratio(1)*paperpos(4)
        newaxpos = axpos(3)*aspect_ratio(2)/aspect_ratio(1);
        axpos(2) = axpos(2) + (axpos(4) - newaxpos*paperpos(3)/paperpos(4))/2;
        axpos(4) = newaxpos*paperpos(3)/paperpos(4);
    else
        newaxpos = axpos(4)*aspect_ratio(1)/aspect_ratio(2);
        axpos(1) = axpos(1) + (axpos(3) - newaxpos*paperpos(4)/paperpos(3))/2;
        axpos(3) = newaxpos*paperpos(4)/paperpos(3);
    end
    %%%%%%%%%%%%%%%%% End of changes by Bill
end
fprintf(fid,'  <g>\n');
    axIdString = createId;
    fprintf(fid,'  <clipPath id="%s">\n',axIdString);
    fprintf(fid,'    <rect x="%0.3f" y="%0.3f" width="%0.3f" height="%0.3f"/>\n',...
        axpos(1)*paperpos(3), (1-(axpos(2)+axpos(4)))*paperpos(4), ...
        axpos(3)*paperpos(3), axpos(4)*paperpos(4));
    fprintf(fid,'  </clipPath>\n');
if strcmp(get(ax,'Visible'),'on')
    group=group+1;
    grouplabel=group;
    linewidth=get(ax,'LineWidth');
    if ~strcmp(get(ax,'Color'),'none')
        background_color = searchcolor(id,get(ax,'Color'));
        background_opacity = 1;
    else
        background_color = '#000000';
        background_opacity = 0;
    end
    fprintf(fid,'    <rect x="%0.3f" y="%0.3f" width="%0.3f" height="%0.3f" fill="%s" fill-opacity="%0.2f" stroke="%s" stroke-width="0.0pt" stroke-opacity="0"/>\n',...
        axpos(1)*paperpos(3), (1-(axpos(2)+axpos(4)))*paperpos(4), ...
        axpos(3)*paperpos(3), axpos(4)*paperpos(4), background_color, ...
        background_opacity, background_color);
end
fprintf(fid,'    <g>\n');
axchild=get(ax,'Child');
group = axchild2mif(fid,id,axIdString,ax,group,paperpos,axchild,axpos,axlim,groupax);
fprintf(fid,'    </g>\n');
if strcmp(get(ax,'Visible'),'on')
    fprintf(fid,'    <g>\n');
    axxtick=get(ax,'XTick');
    axytick=get(ax,'YTick');
    axxindex=find((axxtick >= axlimori(1)) & (axxtick <= (axlimori(1)+axlimori(3))));
    axyindex=find((axytick >= axlimori(2)) & (axytick <= (axlimori(2)+axlimori(4))));
    % remove sticks outside of the axes (-1 of legends)
    axxtick=axxtick(axxindex); 
    axytick=axytick(axyindex);
    axxindex_inner = find((axxtick > axlimori(1)) & (axxtick < (axlimori(1)+axlimori(3))));
    axyindex_inner = find((axytick > axlimori(2)) & (axytick < (axlimori(2)+axlimori(4))));
    if ~strcmp(get(ax,'XDir'),'reverse')
        axxtick=((axxtick-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
    else
        axxtick=((axlim(3)-(axxtick-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
    end
    if ~strcmp(get(ax,'YDir'),'reverse')
        axytick=(1-((axytick-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
    else    
        axytick=(1-((axlim(4)-(axytick-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);    
    end
    if strcmp(get(ax,'XScale'),'log')
        axxtick=((log10(get(ax,'XTick'))-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
    end
    if strcmp(get(ax,'YScale'),'log')
        axytick=(1-(((log10(get(ax,'YTick'))-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
    end
    axlabelx=get(ax,'XTickLabel');
    axlabely=get(ax,'YTickLabel');
    ticklength=get(ax,'TickLength');
    linewidth = get(ax,'LineWidth');
    if strcmp(get(ax,'TickDir'),'out')
        ticklength=-ticklength;
        valid_xsticks = 1:length(axxtick);
        valid_ysticks = 1:length(axytick);
    else
        valid_xsticks = axxindex_inner;
        valid_ysticks = axyindex_inner;
    end
    scolorname=searchcolor(id,get(ax,'XColor'));
    % Draw 'box' of x-axis
    if strcmp(get(ax,'Box'),'on')
        line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-(axpos(2)+axpos(4)))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-axpos(2))*paperpos(4)],scolorname,'-',linewidth)
    else
        if strcmp(get(ax,'XAxisLocation'),'top')
            line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-(axpos(2)+axpos(4)))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        else
            line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-axpos(2))*paperpos(4)],scolorname,'-',linewidth)
        end
    end
    % Draw x-grid
    if strcmp(get(ax,'XGrid'),'on')
        gridlinestyle=get(ax,'GridLineStyle');
        for i = axxindex_inner
            line2mif(fid,grouplabel,axpos,[axxtick(i) axxtick(i)],[(1-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) (1-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4)],scolorname,gridlinestyle,linewidth)
        end
    end
    % Draw x-tick marks
    if (ticklength(1) ~= 0)
        for i = valid_xsticks
            % top ticks
            line2mif(fid,grouplabel,axpos,[axxtick(i) axxtick(i)],[(1-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) paperpos(4)-ticklength(1)*paperpos(3)-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2))*paperpos(4)],scolorname,'-',linewidth)
            if strcmp(get(ax,'Box'),'on')
                % bottom ticks
                line2mif(fid,grouplabel,axpos,[axxtick(i) axxtick(i)],[(1-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) paperpos(4)+ticklength(1)*paperpos(3)-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2))*paperpos(4)],scolorname,'-',linewidth)
            end
        end
    end
    % Draw x-tick labels
    if (strcmp(get(ax,'XTickLabelMode'),'auto') && strcmp(get(ax,'XScale'),'log'))
        exponent = 1;
    else
        exponent = 0;
    end
    for i=1:length(axxtick)
        if ~isempty(axlabelx)
            if strcmp(get(ax,'XAxisLocation'),'top')
                label2mif(fid,grouplabel,axpos,ax,axxtick(i),(1-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) - 5,convertString(axlabelx(i,:)),'Center',0,'bottom',1,paperpos,scolorname,exponent);
            else
                label2mif(fid,grouplabel,axpos,ax,axxtick(i),(1-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) + 5,convertString(axlabelx(i,:)),'Center',0,'top',1,paperpos,scolorname,exponent);
            end
        end
    end
    scolorname=searchcolor(id,get(ax,'YColor'));
    % Draw 'box' of y-axis
    if strcmp(get(ax,'Box'),'on')
        line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) axpos(1)*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        line2mif(fid,grouplabel,axpos,[(axpos(1)+axpos(3))*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
    else
        if strcmp(get(ax,'XAxisLocation'),'top')
            line2mif(fid,grouplabel,axpos,[(axpos(1)+axpos(3))*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        else
            line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) axpos(1)*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        end
    end
    % Draw y-grid
    if strcmp(get(ax,'YGrid'),'on')
        gridlinestyle=get(ax,'GridLineStyle');
        for i=axyindex_inner
            line2mif(fid,grouplabel,axpos,[((axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) ((axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)],[axytick(i) axytick(i)],scolorname,gridlinestyle,linewidth)
        end
    end
    % Draw y-tick marks
    if (ticklength(2) ~= 0)
        for i = valid_ysticks
            % right side ticks
            line2mif(fid,grouplabel,axpos,[((axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) (ticklength(1)+(axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)],[axytick(i) axytick(i)],scolorname,'-',linewidth)
            if strcmp(get(ax,'Box'),'on')
                % left side ticks
                line2mif(fid,grouplabel,axpos,[((axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) (-ticklength(1)+(axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)],[axytick(i) axytick(i)],scolorname,'-',linewidth)
            end
        end
    end
    % Draw y-tick labels
    if (strcmp(get(ax,'YTickLabelMode'),'auto') && strcmp(get(ax,'YScale'),'log'))
        exponent = 1;
    else
        exponent = 0;
    end
    for i=1:length(axytick)
        if ~isempty(axlabely)
            if strcmp(get(ax,'YAxisLocation'),'right')
                label2mif(fid,grouplabel,axpos,ax,((axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) + 5,axytick(i),convertString(axlabely(i,:)),'Left',0,'middle',1,paperpos,scolorname,exponent);
            else
                label2mif(fid,grouplabel,axpos,ax,((axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) - 5,axytick(i),convertString(axlabely(i,:)),'Right',0,'middle',1,paperpos,scolorname,exponent);
            end
        end
    end
    exponent2mif(fid,groupax,axpos,paperpos,ax)
    % these are just hidden handles.  Uncommenting while leaving
    % ShowHiddenHandles on will duplicate them in the SVG.
    %titleID=get(ax,'Title');
    %text2mif(fid,groupax,axpos,axlim,paperpos,titleID,ax)
    %xlabelID=get(ax,'XLabel');
    %text2mif(fid,groupax,axpos,axlim,paperpos,xlabelID,ax)
    %ylabelID=get(ax,'YLabel');
    %text2mif(fid,groupax,axpos,axlim,paperpos,ylabelID,ax)
    fprintf(fid,'    </g>\n');
end
fprintf(fid,'  </g>\n');
set(ax,'Units',originalAxesUnits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% take any axis children and create objects for them
function group=axchild2mif(fid,id,axIdString,ax,group,paperpos,axchild,axpos,axlim,groupax)
global fixcolorptr
global colorname
global PLOT2SVG_globals
for i=length(axchild):-1:1
    if strcmp(get(axchild(i), 'Visible'), 'off')
        % do nothing
    elseif strcmp(get(axchild(i),'Type'),'line')
        scolorname=searchcolor(id,get(axchild(i),'Color'));
        linestyle=get(axchild(i),'LineStyle');
        linewidth=get(axchild(i),'LineWidth');
        marker=get(axchild(i),'Marker');
        markeredgecolor=get(axchild(i),'MarkerEdgeColor');
        if ischar(markeredgecolor)
            switch markeredgecolor
                case 'none',markeredgecolorname='none';
                otherwise,markeredgecolorname=scolorname;  % if markeredgecolorname is 'auto' or something else set the markeredgecolorname to the line color
            end    
        else    
            markeredgecolorname=searchcolor(id,markeredgecolor);
        end
        markerfacecolor=get(axchild(i),'MarkerFaceColor');
        if ischar(markerfacecolor)
            switch markerfacecolor
                case 'none',markerfacecolorname='none';
                otherwise,markerfacecolorname=scolorname;  % if markerfacecolorname is 'auto' or something else set the markerfacecolorname to the line color
            end
        else
            markerfacecolorname=searchcolor(id,markerfacecolor);
        end
        markersize=get(axchild(i),'MarkerSize')/1.5;
        linex=get(axchild(i),'XData');
        if strcmp(get(ax,'XScale'),'log')
            linex(find(linex<=0)) = NaN;
            linex=log10(linex);
        end
        liney=get(axchild(i),'YData');
        if strcmp(get(ax,'YScale'),'log')
            liney(find(liney<=0)) = NaN;
            liney=log10(liney);
        end
        if ~strcmp(get(ax,'XDir'),'reverse')
            x=((linex-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        else
            x=((axlim(3)-(linex-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        end
        if ~strcmp(get(ax,'YDir'),'reverse')
            y=(1-((liney-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        else
            y=(1-((axlim(4)-(liney-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        end
        % put a line into a group with its markers
        if strcmp(get(axchild(i),'Clipping'),'on')
            fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
        else
            fprintf(fid,'<g>\n');
        end
        line2mif(fid,groupax,axpos,x,y,scolorname,linestyle,linewidth)
        % put the markers into a subgroup of the lines
        fprintf(fid,'<g>\n');
        switch marker
            case 'none';
            case '.',group=group+1;,circle2mif(fid,group,axpos,x,y,markersize*0.25,'none',markeredgecolorname,linewidth);
            case 'o',group=group+1;,circle2mif(fid,group,axpos,x,y,markersize*0.75,markeredgecolorname,markerfacecolorname,linewidth);
            case '+',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-1 1 NaN 0 0]*markersize,y'*ones(1,5)+ones(length(liney),1)*[0 0 NaN -1 1]*markersize,markeredgecolorname,'-',linewidth,markeredgecolorname, 1, 1);   
            case '*',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,11)+ones(length(linex),1)*[-1 1 NaN 0 0 NaN -0.7 0.7 NaN -0.7 0.7]*markersize,y'*ones(1,11)+ones(length(liney),1)*[0 0 NaN -1 1 NaN 0.7 -0.7 NaN -0.7 0.7]*markersize,markeredgecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case 'x',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-0.7 0.7 NaN -0.7 0.7]*markersize,y'*ones(1,5)+ones(length(liney),1)*[0.7 -0.7 NaN -0.7 0.7]*markersize,markeredgecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case 'square',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-1 -1 1 1 -1]*markersize,y'*ones(1,5)+ones(length(liney),1)*[-1 1 1 -1 -1]*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case 'diamond',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-0.7071 0 0.7071 0 -0.7071]*markersize,y'*ones(1,5)+ones(length(liney),1)*[0 1 0 -1 0]*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case 'pentagram',group=group+1;,patch2mif(fid,group,axpos,...
                    x'*ones(1,11)+ones(length(linex),1)*[0 0.1180 0.5 0.1910 0.3090 0 -0.3090 -0.1910 -0.5 -0.1180 0]*1.3*markersize,...
                    y'*ones(1,11)+ones(length(liney),1)*[-0.5257 -0.1625 -0.1625 0.0621 0.4253 0.2008 0.4253 0.0621 -0.1625 -0.1625 -0.5257]*1.3*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case 'hexagram',group=group+1;,patch2mif(fid,group,axpos,...
                    x'*ones(1,13)+ones(length(linex),1)*[0 0.2309 0.6928 0.4619 0.6928 0.2309 0 -0.2309 -0.6928 -0.4619 -0.6928 -0.2309 0]*1*markersize,...
                    y'*ones(1,13)+ones(length(liney),1)*[0.8 0.4 0.4 0 -0.4 -0.4 -0.8 -0.4 -0.4 0 0.4 0.4 0.8]*1*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);    
            case '^',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[-1 1 0 -1]*markersize,y'*ones(1,4)+ones(length(liney),1)*[0.577 0.577 -0.837 0.577]*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case 'v',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[-1 1 0 -1]*markersize,y'*ones(1,4)+ones(length(liney),1)*[-0.577 -0.577 0.837 -0.577]*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case '<',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[0.577 0.577 -0.837 0.577]*markersize,y'*ones(1,4)+ones(length(liney),1)*[-1 1 0 -1]*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
            case '>',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[-0.577 -0.577 0.837 -0.577]*markersize,y'*ones(1,4)+ones(length(liney),1)*[-1 1 0 -1]*markersize,markerfacecolorname,'-',linewidth,markeredgecolorname, 1, 1);
        end
        % close the marker group
        fprintf(fid,'</g>\n');
        % close the line group
        fprintf(fid,'</g>\n');
    elseif strcmp(get(axchild(i),'Type'),'patch')
        cmap=get(id,'Colormap');
        pointc=get(axchild(i),'FaceVertexCData');
        %pointc=get(axchild(i),'CData');
        % Scale color if scaled color mapping is turned on
        if strcmp(get(axchild(i),'CDataMapping'),'scaled')
            clim=get(ax,'CLim');
            pointc=(pointc-clim(1))/(clim(2)-clim(1))*(size(cmap,1)-1)+1;
        end
        % Limit index to smallest or biggest color index
        pointc=max(pointc,1);
        pointc=min(pointc,size(cmap,1));
        if ~ischar(get(axchild(i),'FaceAlpha'))
            face_opacity = get(axchild(i),'FaceAlpha');
        else
            face_opacity = 1.0;
        end
        if ~ischar(get(axchild(i),'EdgeAlpha'))
            edge_opacity = get(axchild(i),'EdgeAlpha');
        else
            edge_opacity = 1.0;
        end
        linestyle=get(axchild(i),'LineStyle');
        linewidth=get(axchild(i),'LineWidth');
        points=get(axchild(i),'Vertices')';
        if strcmp(get(ax,'XScale'),'log')
            points(1,:)=log10(points(1,:));
        end
        liney=get(axchild(i),'YData');
        if strcmp(get(ax,'YScale'),'log')
            points(2,:)=log10(points(2,:));
        end
        if ~strcmp(get(ax,'XDir'),'reverse')
            x=((points(1,:)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        else
            x=((axlim(3)-(points(1,:)-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        end
        if ~strcmp(get(ax,'YDir'),'reverse')
            y=(1-((points(2,:)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        else
            y=(1-((axlim(4)-(points(2,:)-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        end
        faces = get(axchild(i),'Faces');
        if size(points,1)==3;
            [z,index]=sort(points(3,faces(:,1)));
            faces=faces(index,:);
        end
        if strcmp(get(axchild(i),'Clipping'),'on')
            fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
        else
            fprintf(fid,'<g>\n');
        end
        for p=1:size(faces,1)
            if ischar(get(axchild(i),'FaceColor'))
                if strcmp(get(axchild(i),'FaceColor'),'texturemap')
                    facecolorname='none';   % TO DO: texture map
                elseif strcmp(get(axchild(i),'FaceColor'),'none')
                    facecolorname='none';
                else
                if size(pointc,1)==1
                    facecolor = pointc;    
                elseif size(pointc,1)==size(faces,1)
                    facecolor = pointc(p,:);
                elseif size(pointc,1)==size(points,2)
                    if strcmp(get(axchild(i),'FaceColor'),'flat')
                        facecolor = pointc(faces(p,1));
                    else
                        facecolor = pointc(faces(p,1));     % TO DO: color interpolation
                    end
                else
                    error('Unsupported color handling for patches.');    
                end
                if ~isnan(facecolor)
                    if size(facecolor,2)==1
                        facecolorname = ['#' colorname(ceil(facecolor),:)];
                    else
                        facecolorname = searchcolor(id,facecolor);    
                    end
                else
                    facecolorname='none';
                end
                end
            else
                facecolorname = searchcolor(id,get(axchild(i),'FaceColor'));       
            end
            if ischar(get(axchild(i),'EdgeColor'))
                if strcmp(get(axchild(i),'EdgeColor'),'none')
                    edgecolorname = 'none';
                else
                if size(pointc,1)==1
                    edgecolor = pointc;    
                elseif size(pointc,1)==size(faces,1)
                    edgecolor = pointc(p,:);
                elseif size(pointc,1)==size(points,2)
                    if strcmp(get(axchild(i),'EdgeColor'),'flat')
                        edgecolor = pointc(faces(p,1));
                    else
                        edgecolor = pointc(faces(p,1));     % TO DO: color interpolation
                    end
                else
                    error('Unsupported color handling for patches.');    
                end
                if ~isnan(edgecolor)
                    if size(edgecolor,2)==1
                        edgecolorname = ['#' colorname(ceil(edgecolor),:)];
                    else
                        edgecolorname = searchcolor(id,edgecolor);    
                    end
                else
                    edgecolorname = 'none';
                end
                end
            else
                edgecolorname = searchcolor(id,get(axchild(i),'EdgeColor'));       
            end
            patch2mif(fid, group, axpos, x(faces(p,:)), y(faces(p,:)), facecolorname, linestyle, linewidth, edgecolorname, face_opacity, edge_opacity)
        end
        fprintf(fid,'</g>\n');
    elseif strcmp(get(axchild(i),'Type'),'surface')
        cmap=get(id,'Colormap');
        [faces,points,pointc]=surf2patch(axchild(i));
        points=points';
        % Scale color if scaled color mapping is turned on
        if strcmp(get(axchild(i),'CDataMapping'),'scaled')
            clim=get(ax,'CLim');
            pointc=(pointc-clim(1))/(clim(2)-clim(1))*(size(cmap,1)-1)+1;
        end
        % Limit index to smallest or biggest color index
        pointc=max(pointc,1);
                if ~ischar(get(axchild(i),'FaceAlpha'))
            face_opacity = get(axchild(i),'FaceAlpha');
        else
            face_opacity = 1.0;
        end
        if ~ischar(get(axchild(i),'EdgeAlpha'))
            edge_opacity = get(axchild(i),'EdgeAlpha');
        else
            edge_opacity = 1.0;
        end
        pointc=min(pointc,size(cmap,1));
        linestyle=get(axchild(i),'LineStyle');
        linewidth=get(axchild(i),'LineWidth');
        if strcmp(get(ax,'XScale'),'log')
            points(1,:)=log10(points(1,:));
        end
        liney=get(axchild(i),'YData');
        if strcmp(get(ax,'YScale'),'log')
            points(2,:)=log10(points(2,:));
        end
        if ~strcmp(get(ax,'XDir'),'reverse')
            x=((points(1,:)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        else
            x=((axlim(3)-(points(1,:)-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        end
        if ~strcmp(get(ax,'YDir'),'reverse')
            y=(1-((points(2,:)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        else
            y=(1-((axlim(4)-(points(2,:)-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        end
        if size(points,1)==3;
            [z,index]=sort(points(3,faces(:,1)));
            faces=faces(index,:);
        end
        if strcmp(get(axchild(i),'Clipping'),'on')
            fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
        else
            fprintf(fid,'<g>\n');
        end
        for p=1:size(faces,1)
            if ischar(get(axchild(i),'FaceColor'))
                if strcmp(get(axchild(i),'FaceColor'),'texturemap')
                    facecolorname='none';   % TO DO: texture map
                elseif strcmp(get(axchild(i),'FaceColor'),'none')
                    facecolorname='none';
                else
                    if size(pointc,1)==1
                        facecolor = pointc;    
                    elseif size(pointc,1)==size(faces,1)
                        facecolor = pointc(p,:);
                    elseif size(pointc,1)==size(points,2)
                        if strcmp(get(axchild(i),'FaceColor'),'flat')
                            facecolor = pointc(faces(p,1));
                        else
                            facecolor = pointc(faces(p,1));     % TO DO: color interpolation
                        end
                    else
                        error('Unsupported color handling for patches.');    
                    end
                    if ~isnan(facecolor)
                        if size(facecolor,2)==1
                            facecolorname = ['#' colorname(ceil(facecolor),:)];
                        else
                            facecolorname = searchcolor(id,facecolor);    
                        end
                    else
                        facecolorname='none';
                    end
                end
            else
                facecolorname = searchcolor(id,get(axchild(i),'FaceColor'));       
            end
            if ischar(get(axchild(i),'EdgeColor'))
                if strcmp(get(axchild(i),'EdgeColor'),'none')
                    edgecolorname = 'none';
                else
                if size(pointc,1)==1
                    edgecolor = pointc;    
                elseif size(pointc,1)==size(faces,1)
                    edgecolor = pointc(p,:);
                elseif size(pointc,1)==size(points,2)
                    if strcmp(get(axchild(i),'EdgeColor'),'flat')
                        edgecolor = pointc(faces(p,1));
                    else
                        edgecolor = pointc(faces(p,1));     % TO DO: color interpolation
                    end
                else
                    error('Unsupported color handling for patches.');    
                end
                if ~isnan(edgecolor)
                    if size(edgecolor,2)==1
                        edgecolorname = ['#' colorname(ceil(edgecolor),:)];
                    else
                        edgecolorname = searchcolor(id,edgecolor);    
                    end
                else
                    edgecolorname = 'none';
                end
                end
            else
                edgecolorname = searchcolor(id,get(axchild(i),'EdgeColor'));       
            end
            patch2mif(fid, group, axpos, x(faces(p,:)), y(faces(p,:)), facecolorname, linestyle, linewidth, edgecolorname,  face_opacity, edge_opacity)
        end
        fprintf(fid,'</g>\n');
    elseif strcmp(get(axchild(i),'Type'),'text')
        if strcmp(get(axchild(i),'Clipping'),'on')
            fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
            text2mif(fid,1,axpos,axlim,paperpos,axchild(i),ax)
            fprintf(fid,'</g>\n');
        else
            text2mif(fid,1,axpos,axlim,paperpos,axchild(i),ax)
        end
    elseif strcmp(get(axchild(i),'Type'),'image')
        cmap=get(id,'Colormap');
        pointx=get(axchild(i),'XData');
        pointy=get(axchild(i),'YData');
        pointc=get(axchild(i),'CData');
        if strcmp(get(axchild(i),'CDataMapping'),'scaled')
            clim=get(ax,'CLim');
            pointc=(pointc-clim(1))/(clim(2)-clim(1))*size(cmap,1);
        end
        data_aspect_ratio = get(ax,'DataAspectRatio');
        if length(pointx)==2
            if size(pointc,2)==1
                halfwidthx = (pointx(2) - pointx(1)) * data_aspect_ratio(1);
            else
                halfwidthx = (pointx(2)-pointx(1))/(size(pointc,2)-1);   
            end
        else
            halfwidthx = data_aspect_ratio(1);
        end
        if length(pointy)==2
            if size(pointc,1)==1
                halfwidthy = (pointy(2)-pointy(1)) * data_aspect_ratio(2);
            else
                halfwidthy = (pointy(2)-pointy(1))/(size(pointc,1)-1);   
            end
        else
            halfwidthy = data_aspect_ratio(2);
        end
        if strcmp(get(ax,'XDir'),'reverse')
            if ndims(pointc) < 3
                pointc=fliplr(pointc);
            elseif ndims(pointc) == 3
                for j = size(pointc,3)
                    pointc(:,:,j)=fliplr(pointc(:,:,j));
                end
            else
                error('Invalid number of dimensions of data.');
            end
        end
        if strcmp(get(ax,'YDir'),'reverse')
            if ndims(pointc) < 3
                pointc=flipud(pointc);
            elseif ndims(pointc) == 3
                for j = size(pointc,3)
                    pointc(:,:,j)=flipud(pointc(:,:,j));
                end
            else
                error('Invalid number of dimensions of data.');
            end
        end
        if ndims(pointc) ~= 3
            pointc = max(min(round(double(pointc)),size(cmap,1)),1);
        end
        CameraUpVector=get(ax,'CameraUpVector');
        filename = [PLOT2SVG_globals.basefilename num2str(PLOT2SVG_globals.figurenumber,'%03u') '.' PLOT2SVG_globals.pixelfiletype];
        PLOT2SVG_globals.figurenumber = PLOT2SVG_globals.figurenumber + 1;
        if exist(filename,'file')
            lastwarn('');
            delete(filename);
            if strcmp(lastwarn,'File not found or permission denied.')
                error('Cannot write image file. Make sure that no image is opened in an other program.')    
            end
        end
        if ndims(pointc) < 3
            pointc = flipud(pointc);
        elseif ndims(pointc) == 3
            for j = size(pointc,3)
                pointc(:,:,j)=flipud(pointc(:,:,j));
            end
        else
            error('Invalid number of dimensions of data.');
        end
        if ndims(pointc) == 3
            %pointc is not indexed
            imwrite(pointc,fullfile(PLOT2SVG_globals.basefilepath,filename),PLOT2SVG_globals.pixelfiletype);
        else
            %pointc is probably indexed
            imwrite(pointc,cmap,fullfile(PLOT2SVG_globals.basefilepath,filename),PLOT2SVG_globals.pixelfiletype);
        end
        lx=(size(pointc,2)*halfwidthx)/axlim(3)*axpos(3)*paperpos(3);
        ly=(size(pointc,1)*halfwidthy)/axlim(4)*axpos(4)*paperpos(4);
        pointsx=(axpos(1))*paperpos(3);
        pointsy=(1-(axpos(4)+axpos(2)))*paperpos(4);
        if strcmp(get(axchild(i),'Clipping'),'on')
            fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
            fprintf(fid,'<image x="%0.3f" y="%0.3f" width="%0.3f" height="%0.3f" image-rendering="optimizeSpeed" preserveAspectRatio="none" xlink:href="%s" />\n', pointsx, pointsy, lx, ly, filename);
            fprintf(fid,'</g>\n');
        else
            fprintf(fid,'<image x="%0.3f" y="%0.3f" width="%0.3f" height="%0.3f" image-rendering="optimizeSpeed" preserveAspectRatio="none" xlink:href="%s" />\n', pointsx, pointsy, lx, ly, filename);
        end
    elseif strcmp(get(axchild(i),'Type'), 'hggroup')
        % handle group types (like error bars)
        % FIXME: they are not yet perfectly handled, there are more options
        % that are not used
        if strcmp(get(axchild(i),'Clipping'),'on')
            fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
        else
            fprintf(fid, '<g>');
        end
        group=axchild2mif(fid,id,axIdString,ax,group,paperpos,get(axchild(i), 'Children'),axpos,axlim,groupax);
        fprintf(fid, '</g>');
    elseif strcmp(get(axchild(i),'Type'), 'hgtransform')
        if strcmpi(get(axchild(i), 'Visible'), 'on')
            if strcmp(get(axchild(i),'Clipping'),'on')
                fprintf(fid,'<g clip-path="url(#%s)">\n',axIdString);
            else
                fprintf(fid, '<g>');
            end
            group=axchild2mif(fid,id,axIdString,ax,group,paperpos,get(axchild(i), 'Children'),axpos,axlim,groupax);
            fprintf(fid, '</g>');
        end
    else
        disp(['   Warning: Unhandled child type: ' get(axchild(i),'Type')]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a patch (filled area)
function patch2mif(fid,group,axpos,xtot,ytot,scolorname,style,width, edgecolorname, face_opacity, edge_opacity)
for i=1:size(xtot,1)
    x=xtot(i,:);
    y=ytot(i,:);
    switch style
        case '--',pattern = 'stroke-dasharray="100pt,25pt"';
        case ':',pattern = 'stroke-dasharray="25pt,25pt"';
        case '-.',pattern = 'stroke-dasharray="100pt,25pt,25pt,25pt,"';
        case 'none',pattern = 'stroke-dasharray="none"'; edge_opacity = 0.0;
        otherwise,pattern='stroke-dasharray="none"';   
    end 
    if (isnan(x)==zeros(size(x))&isnan(y)==zeros(size(y)))
        for j=1:20000:length(x)
            xx=x(j:min(length(x),j+19999));
            yy=y(j:min(length(y),j+19999));
            if ~strcmp(edgecolorname,'none') || ~strcmp(scolorname,'none')
                fprintf(fid,'      <polyline fill="%s" fill-opacity="%0.2f" stroke="%s" stroke-width="%0.1fpt" stroke-opacity="%0.2f" %s points="',...
                    scolorname, face_opacity, edgecolorname, width, edge_opacity, pattern);
                fprintf(fid,'%0.3f,%0.3f ',[xx;yy]);
                fprintf(fid,'"/>\n');        
            end
        end
    else
        parts=find(isnan(x)+isnan(y));
        if parts(1)~=1
            parts=[0 parts];
        end
        if parts(length(parts))~=length(x)
            parts=[parts length(x)+1];
        end
        for j=1:(length(parts)-1)
            xx=x((parts(j)+1):(parts(j+1)-1));
            yy=y((parts(j)+1):(parts(j+1)-1));
            if ~strcmp(edgecolorname,'none') || ~strcmp(scolorname,'none')
                if length(xx)~=0
                    fprintf(fid,'      <polyline fill="%s" fill-opacity="%0.2f" stroke="%s" stroke-width="%0.1fpt" stroke-opacity="%0.2f" %s points="',...
                        scolorname, face_opacity, edgecolorname, width, edge_opacity, pattern);
                    fprintf(fid,'%0.3f,%0.3f ',[xx;yy]);
                    fprintf(fid,'"/>\n');        
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a line segment
% this algorthm was optimized for large segement counts
function line2mif(fid,group,axpos,x,y,scolorname,style,width)
if ~strcmp(style,'none')
    switch style
        case '--',pattern='stroke-dasharray="8pt,2pt"';
        case ':',pattern='stroke-dasharray="2pt,2pt"';
        case '-.',pattern='stroke-dasharray="8pt,2pt,2pt,2pt,"';
        otherwise,pattern='stroke-dasharray="none"';   
    end
    if (isnan(x)==zeros(size(x))&isnan(y)==zeros(size(y)))
        for j=1:20000:length(x)
            xx=x(j:min(length(x),j+19999));
            yy=y(j:min(length(y),j+19999));
            fprintf(fid,'      <polyline fill="none" stroke="%s" stroke-width="%0.1fpt" %s points="',scolorname, width, pattern);
            fprintf(fid,'%0.3f,%0.3f ',[xx;yy]);
            fprintf(fid,'"/>\n');
        end
    else
        parts=find(isnan(x)+isnan(y));
        if parts(1)~=1
            parts=[0 parts];
        end
        if parts(length(parts))~=length(x)
            parts=[parts length(x)+1];
        end
        for j=1:(length(parts)-1)
            xx=x((parts(j)+1):(parts(j+1)-1));
            yy=y((parts(j)+1):(parts(j+1)-1));
            if length(xx)~=0
                fprintf(fid,'      <polyline fill="none" stroke="%s" stroke-width="%0.1fpt" %s points="',scolorname, width, pattern);
                fprintf(fid,'%0.3f,%0.3f ',[xx;yy]);
                fprintf(fid,'"/>\n');
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a circle
function circle2mif(fid,group,axpos,x,y,radius,markeredgecolorname,markerfacecolorname,width)
for j=1:length(x)
    if ~(isnan(x(j)) | isnan(y(j)))
        if ~strcmp(markeredgecolorname,'none') || ~strcmp(markerfacecolorname,'none')
            fprintf(fid,'<circle cx="%0.3f" cy="%0.3f" r="%0.3f" fill="%s" stroke="%s" stroke-width="%0.1fpt" />\n',x(j),y(j),radius,markerfacecolorname,markeredgecolorname,width);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function control2mif(fid,id,ax,group,paperpos)
global PLOT2SVG_globals
set(ax,'Units','pixels');
pos=get(ax,'Position');
pict=getframe(id,pos);
if isempty(pict.colormap)
    pict.colormap=colormap;
end
filename = [PLOT2SVG_globals.basefilename num2str(PLOT2SVG_globals.figurenumber,'%03u') '.' PLOT2SVG_globals.pixelfiletype];
PLOT2SVG_globals.figurenumber = PLOT2SVG_globals.figurenumber + 1;
if exist(filename,'file')
    lastwarn('');
    delete(filename);
    if strcmp(lastwarn,'File not found or permission denied.')
        error('Cannot write image file. Make sure that no image is opened in an other program.')    
    end
end
imwrite(pict.cdata,fullfile(PLOT2SVG_globals.basefilepath,filename),PLOT2SVG_globals.pixelfiletype);
set(ax,'Units','normalized');
posNorm=get(ax,'Position');
posInches(1)=posNorm(1)*paperpos(3);
posInches(2)=posNorm(2)*paperpos(4);
posInches(3)=posNorm(3)*paperpos(3);
posInches(4)=posNorm(4)*paperpos(4);
lx = posInches(3);
ly = posInches(4);
pointsx = posInches(1);
pointsy = paperpos(4)-posInches(2)-posInches(4);
fprintf(fid,'<image x="%0.3f" y="%0.3f" width="%0.3f" height="%0.3f" image-rendering="optimizeSpeed" xlink:href="%s" />\n', pointsx, pointsy, lx, ly, filename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a text in the axis frame
% the position of the text has to be adapted to the axis scaling
function text2mif(fid,group,axpos,axlim,paperpos,id,ax)
originalTextUnits=get(id,'Units');
set(id,'Units','Data');
textpos=get(id,'Position');
set(id,'FontUnits','points');
textfontsize=get(id,'FontSize');
fontsize=convertunit(get(id,'FontSize'),get(id,'FontUnit'),'points');   % convert fontsize to inches
paperposOriginal=get(gcf,'Position');
fontsize=fontsize*paperpos(4)/paperposOriginal(4);
font_color=searchcolor(id,get(id,'Color'));
if strcmp(get(ax,'XScale'),'log')
    textpos(1)=log10(textpos(1));
end
if strcmp(get(ax,'YScale'),'log')
    textpos(2)=log10(textpos(2));
end
if ~strcmp(get(ax,'XDir'),'reverse')
    x=((textpos(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
else
    x=((axlim(3)-(textpos(1)-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
end
if ~strcmp(get(ax,'YDir'),'reverse')
    y=(1-((textpos(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
else
    y=(1-((axlim(4)-(textpos(2)-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
end
textvalign=get(id,'VerticalAlignment');
textalign=get(id,'HorizontalAlignment');
texttext=get(id,'String');
textrot=get(id,'Rotation');
lines=max(size(get(id,'String'),1),1);
if size(texttext,2)~=0
    j=1;
    for i=0:1:(lines-1)
        if iscell(texttext)
            label2mif(fid,group,axpos,id,x,y+i*(fontsize*1.11),convertString(texttext{j}),textalign,textrot,textvalign,lines,paperpos,font_color,0)
        else
            label2mif(fid,group,axpos,id,x,y+i*(fontsize*1.11),convertString(texttext(j,:)),textalign,textrot,textvalign,lines,paperpos,font_color,0)
        end
        j=j+1;   
    end
else
    label2mif(fid,group,axpos,id,x,y,'',textalign,textrot,textvalign,lines,paperpos,font_color,0)
end
set(id,'Units',originalTextUnits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adds the exponents to the axis thickmarks if needed
% MATLAB itself offers no information about this exponent scaling
% the exponent have therefore to be extracted from the thickmarks
function exponent2mif(fid,group,axpos,paperpos,ax)
if strcmp(get(ax,'XTickLabelMode'),'auto') & strcmp(get(ax,'XScale'),'linear')
    fontsize=convertunit(get(ax,'FontSize'),get(ax,'FontUnit'),'points');   % convert fontsize to inches
    font_color=searchcolor(ax,get(ax,'XColor'));
    numlabels=str2num(get(ax,'XTickLabel'));
    labelpos=get(ax,'XTick');
    numlabels=numlabels(:);
    labelpos=labelpos(:);
    indexnz=find(labelpos ~= 0);
    if (~isempty(indexnz) && ~isempty(numlabels))
        ratio=numlabels(indexnz)./labelpos(indexnz);
        if round(log10(ratio(1))) ~= 0
            exptext=sprintf('&#215; 10<tspan font-size="%0.1fpt" dy="%0.1fpt">%g</tspan>',0.6*fontsize,-0.6*fontsize,-log10(ratio(1)));
            label2mif(fid,group,axpos,ax,(axpos(1)+axpos(3))*paperpos(3),(1-axpos(2))*paperpos(4)+3*fontsize,exptext,'right',0,'top',1,paperpos,font_color,0)           
        end
    end
end
if strcmp(get(ax,'YTickLabelMode'),'auto') & strcmp(get(ax,'YScale'),'linear')
    fontsize=convertunit(get(ax,'FontSize'),get(ax,'FontUnit'),'points');
    font_color=searchcolor(ax,get(ax,'YColor'));
    numlabels=str2num(get(ax,'YTickLabel'));
    labelpos=get(ax,'YTick');
    numlabels=numlabels(:);
    labelpos=labelpos(:);
    indexnz=find(labelpos ~= 0);
    if (~isempty(indexnz) && ~isempty(numlabels))
        ratio=numlabels(indexnz)./labelpos(indexnz);
        if round(log10(ratio(1))) ~= 0
            exptext=sprintf('&#215; 10<tspan font-size="%0.1fpt" dy="%0.1fpt">%g</tspan>',0.6*fontsize,-0.6*fontsize,-log10(ratio(1)));
            label2mif(fid,group,axpos,ax,axpos(1)*paperpos(3),(1-(axpos(2)+axpos(4)))*paperpos(4)-0.5*fontsize,exptext,'left',0,'bottom',1,paperpos,font_color,0)           
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a label in the figure
% former versions of FrameMaker supported the commands FDY and FDX to shift the text
% this commands were replaced by a shift parameter that is normed by the font size
function label2mif(fid,group,axpos,id,x,y,tex,align,angle,valign,lines,paperpos,font_color,exponent)
if isempty(tex)
    return;
end
textfontname=get(id,'FontName');
set(id,'FontUnits','points');
textfontsize=get(id,'FontSize');
if isfield(get(id),'Interpreter')
    if strcmp(get(id,'Interpreter'),'tex')
        latex=1;
    else
        latex=0;
    end
else
    latex=1;
end
fontsize=convertunit(get(id,'FontSize'),get(id,'FontUnit'),'points');   % convert fontsize to inches
paperposOriginal=get(gcf,'Position');
fontsize=fontsize*paperpos(4)/paperposOriginal(4);
textfontsize=textfontsize*paperpos(4)/paperposOriginal(4);
switch lower(valign)
    case 'top',shift=fontsize*0.8;
    case 'cap',shift=fontsize*0.7;
    case 'middle',shift=-((lines-1)/2*fontsize*1.11)+fontsize*0.3;
    case 'bottom',shift=-((lines-1)*fontsize*1.11)+fontsize*-0.04;
    otherwise,shift=0;
end
switch lower(align)
    case 'right', anchor = 'end'; 
    case 'center',anchor = 'middle';
    otherwise,anchor = 'start';
end
if iscellstr(tex)
    tex = strvcat(tex);
elseif ~ ischar(tex)
    error('Invalid character type');
end    
if latex==1 
    tex=strrep(tex,'\alpha','&#945;');
    tex=strrep(tex,'\beta','&#946;');
    tex=strrep(tex,'\gamma','&#947;');
    tex=strrep(tex,'\delta','&#948;');
    tex=strrep(tex,'\epsilon','&#949;');
    tex=strrep(tex,'\zeta','&#950;');
    tex=strrep(tex,'\eta','&#951;');
    tex=strrep(tex,'\theta','&#952;');
    tex=strrep(tex,'\vartheta','&#977;');
    tex=strrep(tex,'\iota','&#953;');
    tex=strrep(tex,'\kappa','&#954;');
    tex=strrep(tex,'\lambda','&#955;');
    tex=strrep(tex,'\mu','&#181;');
    tex=strrep(tex,'\nu','&#957;');
    tex=strrep(tex,'\xi','&#958;');
    tex=strrep(tex,'\pi','&#960;');
    tex=strrep(tex,'\roh','&#961;');
    tex=strrep(tex,'\sigma','&#963;');
    tex=strrep(tex,'\varsigma','&#962;');
    tex=strrep(tex,'\tau','&#964;');
    tex=strrep(tex,'\upsilon','&#965;');
    tex=strrep(tex,'\phi','&#966;');
    tex=strrep(tex,'\chi','&#967;');
    tex=strrep(tex,'\psi','&#968;');
    tex=strrep(tex,'\omega','&#969;');
    tex=strrep(tex,'\Gamma','&#915;');
    tex=strrep(tex,'\Delta','&#916;');
    tex=strrep(tex,'\Theta','&#920;');
    tex=strrep(tex,'\Lambda','&#923;');
    tex=strrep(tex,'\Xi','&#926;');
    tex=strrep(tex,'\Pi','&#928;');
    tex=strrep(tex,'\Sigma','&#931;');
    tex=strrep(tex,'\Tau','&#932;');
    tex=strrep(tex,'\Upsilon','&#933;');
    tex=strrep(tex,'\Phi','&#934;');
    tex=strrep(tex,'\Psi','&#936;');
    tex=strrep(tex,'\Omega','&#937;');
    tex=strrep(tex,'\infty','&#8734;');
    tex=strrep(tex,'\pm','&#177;');
    tex=strrep(tex,'\Im','&#8465;');
    tex=strrep(tex,'\Re','&#8476;');
    tex=strrep(tex,'\approx','&#8773;');
    tex=strrep(tex,'\leq','&#8804;');
    tex=strrep(tex,'\geq','&#8805;');
    tex=strrep(tex,'\times','&#215;');
    tex=strrep(tex,'\leftrightarrow','&#8596;');
    tex=strrep(tex,'\leftarrow','&#8592;');
    tex=strrep(tex,'\uparrow','&#8593;');
    tex=strrep(tex,'\rightarrow','&#8594;');
    tex=strrep(tex,'\downarrow','&#8595;');
    tex=strrep(tex,'\circ','&#186;');
    tex=strrep(tex,'\propto','&#8733;');
    tex=strrep(tex,'\partial','&#8706;');
    tex=strrep(tex,'\bullet','&#8226;');
    tex=strrep(tex,'\div','&#247;');
    tex=latex2mif(tex,textfontname,textfontsize,'FNormal');
end
if isempty(tex)
    return;
end
if exponent
    tex=sprintf('10<tspan font-size="%0.1fpt" dy="%0.1fpt">%s</tspan>',0.6*textfontsize,-0.6*textfontsize,tex);
    shift = shift + 0.4*fontsize;   % Small correction to make it look nicer
end
fprintf(fid,'  <g transform="translate(%0.3f,%0.3f)">\n',x,y+shift);
fprintf(fid,'    <g transform="rotate(%0.1f)">\n',-angle);
fprintf(fid,'      <text x="%0.3f" y="%0.3f" font-family="%s" text-anchor="%s" font-size="%0.1fpt" fill="%s" >', 0, 0, textfontname, anchor, textfontsize, font_color);
fprintf(fid,'%s',tex);
fprintf(fid,'</text>\n'); 
fprintf(fid,'    </g>\n');
fprintf(fid,'  </g>\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% converts LATEX strings into Framemaker strings
function returnvalue=latex2mif(StringText,font,size,style)
if isempty(StringText)
    returnvalue='';
else
    leftbracket=0;
    rightbracket=0;
    bracketcounter=0;
    leftbracketpos=[];
    rightbracketpos=[];
    returnvalue=[];
    for i=1:length(StringText)
        if rightbracket==leftbracket
            returnvalue=[returnvalue StringText(i)];    
        end
        if StringText(i)=='{'
            leftbracket=leftbracket+1;
            bracketcounter=bracketcounter+1;
            leftbracketpos=[leftbracketpos i];
        end
        if StringText(i)=='}'
            rightbracket=rightbracket+1;
            rightbracketpos=[rightbracketpos i];
            if rightbracket==leftbracket
                fontnew=font;
                sizenew=size;
                stylenew=style;
                if leftbracketpos(leftbracket-bracketcounter+1)~=1
                    switch StringText(leftbracketpos(leftbracket-bracketcounter+1)-1)   
                        case '^'
                            stylenew='super';
                            returnvalue=returnvalue(1:(end-1));
                        case '_'
                            stylenew='sub';
                            returnvalue=returnvalue(1:(end-1));
                    end
                end
                if strcmp(style,stylenew)
                    format=[];
                    formatend=[];
                else
                    format=['<tspan baseline-shift="' stylenew '">'];
                    formatend=['</tspan>'];
                end
                textinbrackets=StringText((leftbracketpos(leftbracket-bracketcounter+1)+1):(rightbracketpos(rightbracket)-1));
                foundpos=findstr(textinbrackets,'\bf');
                if ~isempty(foundpos)
                    textinbrackets=strrep(textinbrackets,'\bf','<tspan font-weight="bold">');
                    textinbrackets=[textinbrackets '</tspan>'];
                end
                foundpos=findstr(textinbrackets,'\it');
                if ~isempty(foundpos)
                    textinbrackets=strrep(textinbrackets,'\it','<tspan font-style="italic">');
                    textinbrackets=[textinbrackets '</tspan>'];
                end
                returnvalue=[returnvalue(1:(end-1)) format latex2mif(textinbrackets,fontnew,sizenew,stylenew) formatend];
                bracketcounter=0;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function name=searchcolor(id,value)
if ischar(value)
    name = value;
else
    name=sprintf('#%02x%02x%02x',fix(value(1)*255),fix(value(2)*255),fix(value(3)*255));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rvalue=convertunit(value,from,to)
switch lower(from)  % convert from input unit to points
    case 'points', rvalue=value;
    case 'centimeters', rvalue=value/2.54*72;
    case 'inches', rvalue=value*72; % 72 points = 1 inch
    otherwise, error(['Unknown unit ' from '.']);
end
switch lower(to)    % convert from points to specified unit
    case 'points', rvalue=rvalue;
    case 'centimeters', rvalue=rvalue*2.54/72;
    case 'inches', rvalue=rvalue/72;    % 72 points = 1 inch
    otherwise, error(['Unknown unit ' to '.']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function strString=addBackSlash( strSlash)
% adds a backslash at the last position of the string (if not already there)
if ( strSlash(end) ~= '\')
    strString = [ strSlash '\'];
else
    strString = strSlash;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function strExt=getFileExtension( strFileName)
% returns the file extension of a filename
[path, name, strExt] = fileparts( strFileName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StringText=convertString(StringText)
if ~isempty(StringText)
    StringText=strrep(StringText,'&','&amp;');  % Do not change sequence !!
    StringText=strrep(StringText,'\\','\');
    StringText=strrep(StringText,'<','&lt;');
    StringText=strrep(StringText,'>','&gt;');
    StringText=strrep(StringText,'"','&quot;');
    StringText=deblank(StringText);
end

function IdString = createId
global PLOT2SVG_globals
if ~isfield(PLOT2SVG_globals,'runningIdNumber')
    PLOT2SVG_globals.runningIdNumber = 0;
end
IdString = ['ID' num2str(PLOT2SVG_globals.runningIdNumber,'%06.0f')];
PLOT2SVG_globals.runningIdNumber = PLOT2SVG_globals.runningIdNumber + 1;
