function Err = axisfn(action, AxesHandle, ResizeFigHandle)
%AXISFN Switchyard function for axisgui.
% Change axis parameters of the axes referenced by AxesHandle,
% and resize the handle to the figure.
%
% See also axisgui, axismenu, payoff

% Author(s): Greg Portmann (May 1997)
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/02/05 15:00:59 $ 

Err = 0;

if nargin < 2
   AxesHandle = get(gcbf,'Userdata');
end

if nargin < 3
   ResizeFigHandle = get(findobj(gcbf,'Tag','CloseAxisGUI'),'Parent');
end

if isempty(ResizeFigHandle)
   Err = -1;
   return;
end

AxesList = findobj('Type','axes');
if isempty(find(AxesHandle==AxesList))
   close(ResizeFigHandle)
   return;
end

FigHandle = get(AxesHandle,'Parent');

switch(action)

case 'Initialize'

   % Set to resize figure
   figure(ResizeFigHandle);

     
   % Axis should not be visible
   cla;
   set(gca,'visible','off');                        % Not working (or figure command reactivates)
   set(gca,'Units','points','position',[0 0 1 1]);  % So make the axis very small

   % Change figure title
   if strcmp(lower(get(get(AxesHandle,'Parent'),'NumberTitle')),'off') == 1
      FigName = get(get(AxesHandle,'Parent'),'Name');
      set(gcf,'Name',['Resize: ', FigName]);
   else
      set(gcf,'Name',['Resize: Figure(', num2str(get(AxesHandle,'Parent')),')']);   
   end
   
   % Position uicontrols (in points)
   set(gcf,'units','points');
   VSpace = 1.5;
   HSpace = 2.5;
   ColSpace = 20;
   HBoarder = 2;
   VBoarder = 2;
   TextWidth = 30;
   EditWidth = 40;
   Height = 13;
      
   ButtonWidth = EditWidth+TextWidth+HSpace;
   set(findobj(gcf,'Tag','AutoScale'),   'Position',[HBoarder VBoarder ButtonWidth 17.5]);
   set(findobj(gcf,'Tag','CloseAxisGUI'),'Position',[HBoarder+ButtonWidth+ColSpace VBoarder ButtonWidth 17.5]);
   Y = VBoarder + 17.5 + VSpace;
   
   % Get view (Note: axis set the current figure to the plot figure)
   axes(AxesHandle);
   a = axis;
   [AZ,EL]=view;
   figure(ResizeFigHandle);   % Go back to resize figure as the current figure

   if size(a,2) == 4
      set(findobj(gcf,'Tag','EditXmin'),'String',num2str(a(1)));
      set(findobj(gcf,'Tag','EditXmax'),'String',num2str(a(2)));
      set(findobj(gcf,'Tag','EditYmin'),'String',num2str(a(3)));
      set(findobj(gcf,'Tag','EditYmax'),'String',num2str(a(4)));

      set(findobj(gcf,'Tag','TextZmin'),'Visible','Off');
      set(findobj(gcf,'Tag','EditZmin'),'Visible','Off');
      set(findobj(gcf,'Tag','TextZmax'),'Visible','Off');
      set(findobj(gcf,'Tag','EditZmax'),'Visible','Off');
      
      set(findobj(gcf,'Tag','TextHorizontal'),'Visible','Off');
      set(findobj(gcf,'Tag','SliderHorizontal'),'Visible','Off');
      set(findobj(gcf,'Tag','TextVertical'),'Visible','Off');
      set(findobj(gcf,'Tag','SliderVertical'),'Visible','Off');

   else
      set(findobj(gcf,'Tag','TextHorizontal'),'Visible','On');
      set(findobj(gcf,'Tag','SliderHorizontal'),'Visible','On');
      set(findobj(gcf,'Tag','TextVertical'),'Visible','On');
      set(findobj(gcf,'Tag','SliderVertical'),'Visible','On');
      
      Y = Y + 2*VSpace;
      SliderWidth = TextWidth + EditWidth + HSpace;
      
      set(findobj(gcf,'Tag','SliderHorizontal'),'Value',AZ);
      set(findobj(gcf,'Tag','SliderVertical'),  'Value',EL);
      set(findobj(gcf,'Tag','SliderHorizontal'),'Position',[HBoarder Y SliderWidth Height]);
      set(findobj(gcf,'Tag','SliderVertical'),'Position',[HBoarder+SliderWidth+ColSpace Y SliderWidth Height]);
      Y = Y + Height;
      
      set(findobj(gcf,'Tag','TextHorizontal'),'Position',[HBoarder Y SliderWidth 9]);
      set(findobj(gcf,'Tag','TextVertical'),'Position',[HBoarder+SliderWidth+ColSpace Y SliderWidth 9]);
      Y = Y + Height + 2*VSpace;
      
      set(findobj(gcf,'Tag','EditXmin'),'String',num2str(a(1)));
      set(findobj(gcf,'Tag','EditXmax'),'String',num2str(a(2)));
      set(findobj(gcf,'Tag','EditYmin'),'String',num2str(a(3)));
      set(findobj(gcf,'Tag','EditYmax'),'String',num2str(a(4)));
      set(findobj(gcf,'Tag','EditZmin'),'String',num2str(a(5)));
      set(findobj(gcf,'Tag','EditZmax'),'String',num2str(a(6)));

      set(findobj(gcf,'Tag','TextZmin'),'Visible','On');
      set(findobj(gcf,'Tag','EditZmin'),'Visible','On');
      set(findobj(gcf,'Tag','TextZmax'),'Visible','On');
      set(findobj(gcf,'Tag','EditZmax'),'Visible','On');
      
      set(findobj(gcf,'Tag','TextZmin'),'Position',[HBoarder Y TextWidth Height]);
      set(findobj(gcf,'Tag','TextZmax'),'Position',[HBoarder+EditWidth+TextWidth+HSpace+ColSpace Y TextWidth Height]);
      set(findobj(gcf,'Tag','EditZmin'),'Position',[HBoarder+TextWidth+HSpace Y EditWidth Height]);
      set(findobj(gcf,'Tag','EditZmax'),'Position',[HBoarder+EditWidth+2*TextWidth+2*HSpace+ColSpace Y EditWidth Height]);
      Y = Y + Height + VSpace;
   end
      
   set(findobj(gcf,'Tag','TextYmin'),'Position',[HBoarder Y TextWidth Height]);
   set(findobj(gcf,'Tag','TextYmax'),'Position',[HBoarder+EditWidth+TextWidth+HSpace+ColSpace Y TextWidth Height]);
   set(findobj(gcf,'Tag','EditYmin'),'Position',[HBoarder+TextWidth+HSpace Y EditWidth Height]);
   set(findobj(gcf,'Tag','EditYmax'),'Position',[HBoarder+EditWidth+2*TextWidth+2*HSpace+ColSpace Y EditWidth Height]);
   Y = Y + Height + VSpace;
   
   set(findobj(gcf,'Tag','TextXmin'),'Position',[HBoarder Y TextWidth Height]);
   set(findobj(gcf,'Tag','TextXmax'),'Position',[HBoarder+EditWidth+TextWidth+HSpace+ColSpace Y TextWidth Height]);
   set(findobj(gcf,'Tag','EditXmin'),'Position',[HBoarder+TextWidth+HSpace Y EditWidth Height]);
   set(findobj(gcf,'Tag','EditXmax'),'Position',[HBoarder+EditWidth+2*TextWidth+2*HSpace+ColSpace Y EditWidth Height]);
   Y = Y + Height + VSpace;
   
   set(findobj(gcf,'Tag','TextHeader'),'Position',[HBoarder Y (2*EditWidth+2*TextWidth+2*HSpace+ColSpace) 9]);
   Y = Y + 9;   
   
   p=get(gcf,'Position');
   Width = (2*HBoarder+2*EditWidth+2*TextWidth+2*HSpace+ColSpace);
   if size(a,2) == 4
      set(gcf,'Position',[p(1) p(2)+p(4)-Y-2 Width Y+2]);
   else
      % Add height for rotation scales
      set(gcf,'Position',[p(1) p(2)+p(4)-Y-2 Width Y+2]);
   end
   set(gcf,'Resize','off');
   
   % Make resize figure active
   set(ResizeFigHandle, 'Visible', 'on');

   
   % Check inputs
   a = getinputs;

case 'AutoScale'
   caxes = gca;
   AxesHandle = get(gcbf,'Userdata');
   axes(AxesHandle);
   
   FigName = get(get(AxesHandle,'Parent'),'Name');
   if strcmp(FigName,'Profit/Loss Diagram') == 1        % Name set in payoff.m
      figure(get(AxesHandle,'Parent'));
      payofffn('PlotPortfolio');
   elseif strcmp(FigName,'Hedging Diagram') == 1        % Name set in payoff.m
      figure(get(AxesHandle,'Parent'));
      payofffn('PlotPortfolio');
   elseif strcmp(FigName,'Probability Diagram') == 1    % Name set in payoff.m
      figure(get(AxesHandle,'Parent'));
      payofffn('PlotPortfolio');
   elseif strcmp(FigName,'Option Valuation (Black-Scholes Formula)')==1 | strcmp(FigName,'Option Valuation (Binomial Tree)')==1 % Name set in oneoptfn.m
      figure(get(AxesHandle,'Parent'));
      oneoptfn('PlotPortfolio');
   else
      axis auto
   end

   axes(caxes);
   axisfn('Initialize');
   axes(caxes);
   
   
case 'ChangeAxis'
   figure(ResizeFigHandle);
   a = getinputs;
   axes(AxesHandle);
   
   %if (strcmp(lower(get(findobj(gcbf,'Tag','EditZmin'),'Visible')),'off')==1 & length(axis)==6) | (strcmp(lower(get(findobj(gcbf,'Tag','EditZmin'),'Visible')),'on')==1 & length(axis)==4)
   %   axisfn('Initialize');
   %   set(findobj(gcbf,'Tag','EditXmin'),'String',num2str(a(1)));
   %   set(findobj(gcbf,'Tag','EditXmax'),'String',num2str(a(2)));
   %   set(findobj(gcbf,'Tag','EditYmin'),'String',num2str(a(3)));
   %   set(findobj(gcbf,'Tag','EditYmax'),'String',num2str(a(4)));
   %end
   
   figure(ResizeFigHandle);
   a = getinputs;
   axes(AxesHandle);
   if any(isnan(a))
      % Input error
   else
      % All inputs OK
      
      % Save the view
      [AZ,EL] = view;
      
      % Replot 
      FigName = get(get(AxesHandle,'Parent'),'Name');
      if strcmp(FigName,'Portfolio Pricing (Profit/Loss Diagram)') == 1        % Name set in payoff.m
         figure(get(AxesHandle,'Parent'));
         payofffn('PlotPortfolio',a(1:4));
      elseif strcmp(FigName,'Portfolio Pricing (Hedging Diagram)') == 1        % Name set in payoff.m
         figure(get(AxesHandle,'Parent'));
         payofffn('PlotPortfolio',a(1:4));
      elseif strcmp(FigName,'Portfolio Pricing (Probability Diagram)') == 1    % Name set in payoff.m
         figure(get(AxesHandle,'Parent'));
         payofffn('PlotPortfolio',a(1:4));
      elseif strcmp(FigName,'Option Valuation (Black-Scholes Formula)')==1 | strcmp(FigName,'Option Valuation (Binomial Tree)')==1 % Name set in oneopt.m
         figure(get(AxesHandle,'Parent'));
         oneoptfn('PlotPortfolio',a(1:4));
      end
      %if length(axis) == 4
      %   axis(a(1:4));   % Force the axis size.  Some functions limit the range.
      %else
      %   axis(a);        % Force the axis size.  Some functions limit the range.
      %end
      axis(a);  % Force the axis size.  Some functions limit the range.
      
      % restore the view
      view(AZ,EL);
      
   end
   
   
   % Make resize figure active
   figure(ResizeFigHandle);
   
   % Make edittext active ??????????
    
  
case 'RotateHorizontal'
   figure(ResizeFigHandle);
   AZ=get(findobj(gcf,'Tag','SliderHorizontal'),'Value');
   EL=get(findobj(gcf,'Tag','SliderVertical'),'Value');
   axes(AxesHandle);
   view(AZ,EL);

   % Make resize figure active
   figure(ResizeFigHandle);
    
case 'RotateVertical'
   figure(ResizeFigHandle);
   AZ=get(findobj(gcf,'Tag','SliderHorizontal'),'Value');
   EL=get(findobj(gcf,'Tag','SliderVertical'),'Value');
   axes(AxesHandle);   
   view(AZ,EL);
   
   % Make resize figure active
   figure(ResizeFigHandle);
   
end


% Main input checking function 
function Value = getcheckinput(tag);

Value = str2double(get(findobj(gcf,'Tag',tag),'string'));

if isempty(Value) | isnan(Value) | isinf(Value) | ~isreal(Value) | any(size(Value)~=[1 1]) 
   Value = NaN;
   set(findobj(gcf,'Tag',['Text',tag(5:length(tag))]),'ForegroundColor',[1 0 0]);
else
   % Special case input errors
   %if strcmp(tag,'EditText???')==1 & Value==0
   %   Value = NaN;
   %   set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
   %end
end

if ~isnan(Value)
   set(findobj(gcf,'Tag',['Text',tag(5:length(tag))]),'ForegroundColor',[0 0 0]);
end
% End function


function a = getinputs

a(1) = getcheckinput('EditXmin');
a(2) = getcheckinput('EditXmax');
if ~isnan(a(1)) & ~isnan(a(2))
   if a(1) >= a(2)
      set(findobj(gcf,'Tag','TextXmin'),'ForegroundColor',[0 0 1]);
      set(findobj(gcf,'Tag','TextXmax'),'ForegroundColor',[0 0 1]);
      a(1) = NaN;
      a(2) = NaN;
   end
end

a(3) = getcheckinput('EditYmin');
a(4) = getcheckinput('EditYmax');
if ~isnan(a(3)) & ~isnan(a(4))
   if a(3) >= a(4)
      set(findobj(gcf,'Tag','TextYmin'),'ForegroundColor',[0 0 1]);
      set(findobj(gcf,'Tag','TextYmax'),'ForegroundColor',[0 0 1]);
      a(3) = NaN;
      a(4) = NaN;
   end
end

if strcmp(lower(get(findobj(gcbf,'Tag','EditZmin'),'Visible')),'on') == 1
   a(5) = getcheckinput('EditZmin');
   a(6) = getcheckinput('EditZmax');
   if ~isnan(a(5)) & ~isnan(a(6))
      if a(5) >= a(6)
         set(findobj(gcf,'Tag','TextZmin'),'ForegroundColor',[0 0 1]);
         set(findobj(gcf,'Tag','TextZmax'),'ForegroundColor',[0 0 1]);
         a(5) = NaN;
         a(6) = NaN;
      end
   end
end
% End function

