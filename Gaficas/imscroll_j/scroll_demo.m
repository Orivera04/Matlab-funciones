function scroll_demo(opt)
% Demo function to illustrate the use of the IMSCROLL_J tool
%
% SCROLL_DEMO with no arguments loads the peppers image and fakes
% a zoom factor. In this mode you case use the sliders with the current
% zoom factor.
%
% SCROLL_DEMO('whatever') creates a zoom uitoggletool (if running on R13)
% or a zoom and a pan uitoggletools (on R14 or above).
%
% NOTE1: the zoom_j.m function is a R13 modified version that interfaces with
% the IMSCROLL_J fucntion. It may be used by R13 or R14 releases.
%
% NOTE2: On R14 you must do the following change to the pan.m function
% pan.m         (R14 only)
% On the locWindowButtonMotionFcn function at the end of the 
% "if ok2pan" test (but inside this IF test)  ad
% imscroll_j(ax,'PanSetSliders')
%

hf = figure('units','pixels','DoubleBuffer','on');

img = imread('peppers.png');
image(img);

hAx = gca;
set(hAx,'units','pixels')
posAx = get(hAx,'pos');

if (nargin == 1)
    % Fake a zoom factor
	x_lim = get(hAx,'XLim');
	y_lim = get(hAx,'YLim');
	set(hAx,'XLim',[150 400], 'YLim',[150 350]);
    
else
    % Create two uitoggletools to do zoom & pan (this later only on >= R14)
    % NOTE: This assumes that the pan function was modified according to instructions
    
    % Trick to get zoom (& pan icons)
	hA = findall(hf);
	hh = findobj(hA,'TooltipString','Zoom In');
	zoomIn_img = get(hh(1),'CData');
	hh = findobj(hA,'TooltipString','Pan');
	
    h_toolbar = uitoolbar('parent',hf, 'BusyAction','queue','HandleVisibility','on');
    if (~isempty(hh))        % It means we are in R14 or above
    	pan_img = get(hh(1),'CData');
	    uitoggletool('parent',h_toolbar,'Click',{@PanZoom_Callback,gcf,'zoom'},'Tag','Zoom',...
            'cdata',zoomIn_img,'TooltipString','Zoom');
	    uitoggletool('parent',h_toolbar,'Click',{@PanZoom_Callback,gcf,'pan'},'Tag','Pan',...
            'cdata',pan_img,'TooltipString','Pan');
    else
	    uitoggletool('parent',h_toolbar,'Click',@zoom_Callback,'Tag','Zoom',...
            'cdata',zoomIn_img,'TooltipString','Zoom');   
    end
end

% Create the sliders
hSliderHor = uicontrol('units','pixels','Style','slider',...
    'Min',0,'Max',1,...
    'Tag','HOR',...
    'pos', [posAx(1) posAx(2)-35 posAx(3) 13],...
    'Callback',{@slider_Cb,hAx,'SetSliderHor'});
hSliderVer = uicontrol('units','pixels','Style','slider',...
    'Min',0,'Max',1,...
    'Tag','VER',...
    'pos', [posAx(1)+posAx(3) posAx(2) 13 posAx(4)],...
    'Callback',{@slider_Cb,hAx,'SetSliderVer'});

% register the sliders in the axes appdata
setappdata(hAx,'SliderAxes',[hSliderHor hSliderVer])
imscroll_j(hAx,'ZoomSetSliders')


% -------------------------------------------------
function slider_Cb(obj,evt,ax,opt)
% Sliders callback function
imscroll_j(ax,opt)

% --------------------------------------------------------------------------------------------------
function zoom_Callback(obj,eventdata)
% Toogle on/off the zoom button
if (strcmp(get(obj,'State'),'on'))
    zoom_j on;
else
    zoom_j off;
end

% --------------------------------------------------------------------
function PanZoom_Callback(hObject,event,hFig,opt)
% Toogle on/off the zoom and the pan buttons (and respective functions)
if (strcmp(opt,'zoom'))
	if strcmp(get(hObject,'State'),'on')
        zoom_j('on');    h = findobj(hFig,'Tag','Pan');
        if (strcmp(get(h,'State'),'on'))
            set(h,'State','off');   pan('off');
        end
	else
        zoom_j('off');
	end
else        % Pan case
	if strcmp(get(hObject,'State'),'on')
        pan('on');    h = findobj(hFig,'Tag','Zoom');
        if (strcmp(get(h,'State'),'on'))
            set(h,'State','off');   zoom_j('off');
        end
	else
        pan('off');
	end
end
