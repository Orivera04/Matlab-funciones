% adjustableColorbar(h)
% where h is an axes handle 
% creates an interactive colorbar
% Click, hold, then drag the upper or lower limit of the
% colorbar to adjust the data range to which the color palette
% is applied.  A condensed palette can then be 'moved' all at once
% by clicking/holding/dragging the middle portion of the palette.
%
% call with axes handle argument
%
% example
%
% data = randn(100,100);
% imagesc(data)
% adjustableColorbar(gca)
%
% John Franklin 2006
% john.franklin@gmail.com


function adjustableColorbar(varargin)

if nargin == 1;
    plotHandle = varargin{:};
    figureHandle = get(plotHandle,'Parent');
    set(figureHandle,'WindowButtonDownFcn','UserData = get(gcbo,''UserData''); UserData.buttonDown = 1; set(gcbo,''UserData'',UserData)')
    set(figureHandle,'WindowButtonUpFcn','UserData = get(gcbo,''UserData''); UserData.buttonDown = 0; set(gcbo,''UserData'',UserData)')
    map = jet(100);
    set(figureHandle,'Colormap',map)
    set(figureHandle,'Renderer','opengl')
    colorbarHandle = colorbar('peer',plotHandle);
    colorHandle = get(colorbarHandle,'Children');
    set(colorbarHandle,'ButtonDownFcn',@adjustableColorbar,'Interruptible','on')
    UserData = get(colorbarHandle,'UserData');
    UserData.topPadLength = 0;
    UserData.bottomPadLength = 0;
    UserData.paletteLength = size(get(figureHandle,'Colormap'),1);
    UserData.PlotHandle = plotHandle;
    
                            %1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16
    UserData.cursorTop =  [NaN NaN NaN NaN NaN NaN 1   1   1   1   NaN NaN NaN NaN NaN NaN; %1
                           NaN NaN NaN NaN NaN 1   2   2   2   2   1   NaN NaN NaN NaN NaN; %2
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %3
                           NaN NaN NaN NaN 1   2   NaN NaN NaN NaN 2   1   NaN NaN NaN NaN; %4
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %5
                           1   1   1   1   1   1   2   2   2   2   1   1   1   1   1   1; %6
                           1   2   2   2   1   2   1   1   1   1   2   1   2   2   2   1  ; %7
                           NaN 1   2   2   1   2   NaN NaN NaN NaN 2   1   2   2   1   NaN; %8
                           NaN NaN 1   2   1   2   NaN NaN NaN NaN 2   1   2   1   NaN NaN;   %9
                           NaN NaN NaN 1   1   2   1   1   1   1   2   1   1   NaN NaN NaN; %10
                           NaN NaN NaN NaN 1   1   2   2   2   2   1   1   NaN NaN NaN NaN; %11
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %12
                           NaN NaN NaN NaN 1   2   NaN NaN NaN NaN 2   1   NaN NaN NaN NaN; %13
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %14
                           NaN NaN NaN NaN NaN 1   2   2   2   2   1   NaN NaN NaN NaN NaN; %15
                           NaN NaN NaN NaN NaN NaN 1   1   1   1   NaN NaN NaN NaN NaN NaN];%16   

    UserData.cursorBottom=[NaN NaN NaN NaN NaN NaN 1   1   1   1   NaN NaN NaN NaN NaN NaN; %1
                           NaN NaN NaN NaN NaN 1   2   2   2   2   1   NaN NaN NaN NaN NaN; %2
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %3
                           NaN NaN NaN NaN 1   2   NaN NaN NaN NaN 2   1   NaN NaN NaN NaN; %4
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %5
                           NaN NaN NaN NaN 1   1   2   2   2   2   1   1   NaN NaN NaN NaN; %6
                           NaN NaN NaN 1   1   2   1   1   1   1   2   1   1   NaN NaN NaN; %7
                           NaN NaN 1   2   1   2   NaN NaN NaN NaN 2   1   2   1   NaN NaN; %8
                           NaN 1   2   2   1   2   NaN NaN NaN NaN 2   1   2   2   1   NaN; %9
                           1   2   2   2   1   2   1   1   1   1   2   1   2   2   2   1  ; %10
                           1   1   1   1   1   1   2   2   2   2   1   1   1   1   1   1  ; %11
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %12
                           NaN NaN NaN NaN 1   2   NaN NaN NaN NaN 2   1   NaN NaN NaN NaN; %13
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %14
                           NaN NaN NaN NaN NaN 1   2   2   2   2   1   NaN NaN NaN NaN NaN; %15
                           NaN NaN NaN NaN NaN NaN 1   1   1   1   NaN NaN NaN NaN NaN NaN];%16 

    UserData.cursorMiddle=[NaN NaN NaN NaN NaN NaN 1   1   1   1   NaN NaN NaN NaN NaN NaN; %1
                           NaN NaN NaN NaN NaN 1   2   2   2   2   1   NaN NaN NaN NaN NaN; %2
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %3
                           NaN NaN NaN 1   1   2   NaN NaN NaN NaN 2   1   1   NaN NaN NaN; %4
                           NaN NaN 1   2   1   2   1   1   1   1   2   1   2   1   NaN NaN; %5
                           NaN 1   2   2   1   1   2   2   2   2   1   1   2   2   1   NaN; %6
                           1   2   2   2   1   2   1   1   1   1   2   1   2   2   2   1  ; %7
                           1   1   NaN 1   1   2   NaN NaN NaN NaN 2   1   NaN 1   NaN 1  ; %8
                           1   NaN 1   NaN 1   2   NaN NaN NaN NaN 2   1   1   NaN 1   1  ; %9
                           1   2   2   2   1   2   1   1   1   1   2   1   2   2   2   1  ; %10
                           NaN 1   2   2   1   1   2   2   2   2   1   1   2   2   1   NaN; %11
                           NaN NaN 1   2   1   2   1   1   1   1   2   1   2   1   NaN NaN; %12
                           NaN NaN NaN 1   1   2   NaN NaN NaN NaN 2   1   1   NaN NaN NaN; %13
                           NaN NaN NaN NaN 1   2   1   1   1   1   2   1   NaN NaN NaN NaN; %14
                           NaN NaN NaN NaN NaN 1   2   2   2   2   1   NaN NaN NaN NaN NaN; %15
                           NaN NaN NaN NaN NaN NaN 1   1   1   1   NaN NaN NaN NaN NaN NaN];%16
    
    set(colorbarHandle,'UserData',UserData);
    
else
    
    hotSpot = [9,9];
    barHandle = gcbo;
    imageHandle = get(barHandle,'Children');
    UserData = get(barHandle,'UserData');
    plotHandle = UserData.PlotHandle;
    figureHandle = get(barHandle,'Parent');
    cLim = get(plotHandle,'CLim');
    yLim = get(barHandle,'YLim');
    paletteLength = UserData.paletteLength;
    palette = [1:paletteLength]';
    barHotSpots = repmat([cLim(1),cLim(1)+(cLim(2)-cLim(1))/2,cLim(2)]',1,2) + repmat([-1,1],3,1)*min(diff(cLim)/3,diff(yLim)/20);
    point = get(barHandle,'CurrentPoint');
    point = point(1,1:2);
    flag = 'none';
    oldPointerType = get(figureHandle,'Pointer');
    oldPointerShape = get(figureHandle,'PointerShapeCData');
    oldHotSpot = get(figureHandle,'PointerShapeHotSpot');
    if point(2) > barHotSpots(1,1) & point(2) < barHotSpots(1,2)
        flag = 'bottom';    
        set(figureHandle,'Pointer','custom');
        set(figureHandle,'PointerShapeCData',UserData.cursorBottom);
        set(figureHandle,'PointerShapeHotSpot',hotSpot);
    elseif point(2) > barHotSpots(2,1) & point(2) < barHotSpots(2,2)
        flag = 'middle';
        set(figureHandle,'Pointer','custom');
        set(figureHandle,'PointerShapeCData',UserData.cursorMiddle);
        set(figureHandle,'PointerShapeHotSpot',hotSpot);
    elseif point(2) > barHotSpots(3,1) & point(2) < barHotSpots(3,2)
        flag = 'top';
        set(figureHandle,'Pointer','custom');
        set(figureHandle,'PointerShapeCData',UserData.cursorTop);
        set(figureHandle,'PointerShapeHotSpot',hotSpot);
    end
    if strcmp(flag,'bottom')|strcmp(flag,'top')|strcmp(flag,'middle')
        UserData = get(figureHandle,'UserData');
        buttonDown = UserData.buttonDown;
        %compute pixels -> plot coordinate scale factors
        oldPosition = get(barHandle,'Position');
        oldPlotPosition = get(plotHandle,'Position');
        oldUnits = get(barHandle,'Units');
        set(barHandle,'Units','Pixels')
        pixelPosition = get(barHandle,'Position');
        set(barHandle,'Units',oldUnits)
        set(barHandle,'Position',oldPosition)
        set(plotHandle,'Position',oldPlotPosition)
        oldUnits = get(figureHandle,'Units');
        set(figureHandle,'Units','Pixels')
        figurePosition = get(figureHandle,'Position');
        set(figureHandle,'Units',oldUnits)
        slope = (yLim(2)-yLim(1))/pixelPosition(4);
        intercept = yLim(1)-slope*(pixelPosition(2) + figurePosition(2));
        pointerLocation = get(0,'PointerLocation');
        switch flag
        case 'top'
            pointerLocation(2) = round((cLim(2)-intercept)/slope);
        case 'middle'
            cLimLength = cLim(2)-cLim(1);
            pointerLocation(2) = round(((cLim(1) + cLimLength/2)-intercept)/slope);
        case 'bottom'
            pointerLocation(2) = round((cLim(1)-intercept)/slope);
        end
        set(0,'PointerLocation',pointerLocation)
        while buttonDown
            drawnow
            UserData = get(figureHandle,'UserData');
            buttonDown = UserData.buttonDown;
            pointerLocation = get(0,'PointerLocation');
            pointerYLocation = slope*pointerLocation(2) + intercept;
            switch flag
            case 'bottom'
                if pointerYLocation < cLim(2)
                    if pointerYLocation > yLim(1) 
                        cLim(1) = pointerYLocation;
                    else
                        cLim(1) = yLim(1);
                    end
                end
            case 'middle'
                if (pointerYLocation < (yLim(2)-cLimLength/2)) 
                    if (pointerYLocation > (yLim(1) + cLimLength/2))
                        cLim = pointerYLocation + [-1,1]*(cLimLength/2);
                    else
                        cLim = [yLim(1),yLim(1) + cLimLength];
                    end
                else
                    cLim = [yLim(2)-cLimLength,yLim(2)];
                end
            case 'top'
                if pointerYLocation > cLim(1)
                    if pointerYLocation < yLim(2) 
                        cLim(2) = pointerYLocation;
                    else
                        cLim(2) = yLim(2);
                    end
                end
            end
            scaleFactor = (paletteLength/(cLim(2)-cLim(1)));
            topPad = repmat(paletteLength,round(scaleFactor*(yLim(2)-cLim(2))),1);
            bottomPad = ones(round(scaleFactor*(cLim(1)-yLim(1))),1);
            set(imageHandle,'CData',[bottomPad;palette;topPad])
            set(plotHandle,'CLim',cLim);
            drawnow
        end
    end
    set(figureHandle,'Pointer',oldPointerType);
    set(figureHandle,'PointerShapeCData',oldPointerShape);
    set(figureHandle,'PointerShapeHotSpot',oldHotSpot);
end


