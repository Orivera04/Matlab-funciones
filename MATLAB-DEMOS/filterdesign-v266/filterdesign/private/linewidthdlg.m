function linewidth = linewidthdlg(action)
%LINEWDITHDLG Line width dialog box.
%  w = LINEWIDTHDLG creates a modal dialog box that returns the width
%  of the line selected in the dialog box.
%
%  w = LINEWIDTHDLG(x) uses the default width of x.  x must be greater than
%  or equal to .5

% Jordan Rosenthal, 12/14/97
% Revision 2, 4/6/98
% Revision 3, 10/20/2003 (G. Krudysz)

if nargin == 1 & ischar(action)
   %------------------------%
   % Perform action
   %------------------------%
   switch action
   case 'SetWidth'
      hLine = findobj(gcbf,'Type','line');
      SliderValue = get(findobj(gcbf,'Style','slider'), 'Value');
      set(hLine, 'LineWidth', SliderValue);
   case 'OK'
      set(gcbf,'UserData',1);
   otherwise
      error('Illegal action');
   end
elseif nargin == 0 | ~ischar(action)
   if nargin == 0
      DefLineWidth = get(0,'DefaultlineLineWidth');
   elseif action >= .5
      DefLineWidth = action;
   else
      error('Illegal value for default line width.');
   end
   %------------------------%
   % Setup Dialog
   %------------------------%
   OldUnits = get(0, 'Units');
   set(0, 'Units','pixels');
   ScreenSize = get(0,'ScreenSize');
   set(0, 'Units', OldUnits);
   DlgPos = [0.35*ScreenSize(3), 0.325*ScreenSize(4), 0.3*ScreenSize(3), 0.35*ScreenSize(4)];
   dlg_color = get(gcbf,'color');   % or get(0,'defaultfigurecolor');
   hDlg = dialog( ...
      'Color',dlg_color, ...
      'Name','Line Thickness', ...
      'CloseRequestFcn','linewidthdlg OK', ...
      'Position',DlgPos, ...
      'UserData',0);
   %------------------------%
   % Setup Axis
   %------------------------%
   hAxes = axes('Parent',hDlg,'box','on', ...
      'NextPlot','Add', ...
      'Position',[0.15 0.25 0.7 0.7], ...
      'XTick',[],'YTick',[], ...
      'Xlim',[-3.5 3.5],'Ylim',[-1.2 1.2]);
   %------------------------%
   % Setup Lines
   %------------------------%
   xdata = [0.1 0.1 NaN 0.5 0.5 NaN 1 1 NaN 1.5 1.5 NaN 2 2 NaN 2.5 2.5 NaN 3 3]; 
   ydata = sin(xdata);
   ydata(1:3:end) = 0;
    
   line(xdata,ydata,'Parent',hAxes,'Erasemode','Xor','LineWidth',DefLineWidth,'color','r'); % line_stems
   xdata = [.1 NaN 0.5 NaN 1 NaN 1.5 NaN 2 NaN 2.5 NaN 3];   
   line(xdata,sin(xdata),'Parent',hAxes,'Erasemode','Xor','LineWidth',DefLineWidth,'marker','o'); % line_markers
   xdata = -pi:0.1:0;
   line(xdata,sin(xdata),'Parent',hAxes,'Erasemode','Xor','LineWidth',DefLineWidth);
   %------------------------%
   % Setup Slider
   %------------------------%
   hSlider = uicontrol('Parent',hDlg, ...
      'Units','Normalized', ...
      'Callback','linewidthdlg SetWidth', ...
      'Min',0.5, ...
      'Max',5.5, ...
      'Position',[0.15 0.17 0.7 0.07], ...
      'SliderStep',[0.1 0.2], ...
      'Style','slider', ...
      'Value',DefLineWidth );
   %------------------------%
   % Setup OK Button
   %------------------------%
   uicontrol('Parent',hDlg, ...
      'Units','normalized', ...
      'Callback','linewidthdlg OK', ...
      'FontWeight','Bold', ...
      'Position',[0.375 0.04 0.25 0.1], ...
      'String','OK', ...
      'Style','pushbutton');
   %------------------------%
   % Wait for user to hit OK and return result
   % For some reason I can't use just waitfor() and uiresume() when this
   % function is in a private directory.
   waitfor(hDlg,'UserData');
   linewidth = get(hSlider, 'Value');
   delete(hDlg);
else
   error('Too many input arguments.');
end
