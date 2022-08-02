function setfonts(hFig,SCALE)
%SETFONTS Set the fontname and fontsizes used in the GUI.
%   SETFONTS(hFig,SCALE) sets the fonts of the figure hFig.  The 
%   'Helvetica' font was chosen as the default for all text since 
%   it resizes well.  To change the font or font sizes, change the 
%   constants in the code for this function.
%
%   The SCALE parameter is a positive number used to SCALE the size
%   of the fonts in this file.  Using SCALE = 1, or leaving the argument
%   out, means the font size will be determined exactly by the constants
%   given in the code.  Using SCALE = 2 will double the font size.
%  
%   This function was specifically written for the ZDRILL GUI, but 
%   can easily be adapted to other GUIs.
%
%   See also GETFONTSCALE

% Jordan Rosenthal, 11-Sep-1999
%    Adapted from LTIDEMO-V111/SETFONTS (18-Jun-1999)

error(nargchk(1,2,nargin));         % Error check number of input arguments
if nargin == 1, SCALE = 1; end       % Let SCALE = 1 if not given

%--------------------------------------------------------------------------------
% FONT NAME
%--------------------------------------------------------------------------------
FontName = 'Helvetica';     % Font to use for all labels

%--------------------------------------------------------------------------------
% FONT SIZE (points)
%--------------------------------------------------------------------------------
AxisTickLabels    = 14;        % Axis Tick Labels
AxisXLabel        = 14;        % Axis X Labels
AxisYLabel        = 14;        % Axis Y Labels
AxisTitle         = 14;        % Axis Titles
GuessHeaderLabels = 11;        % Headers in Guess box
CheckboxLabels    = 9;        % Labels for the checkboxes
DefaultLabel      = 9;        % All other labels



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not change code below this point.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%--------------------------------------------------------------------------------
% Get Handles for objects
%--------------------------------------------------------------------------------
hAxes       = findall(hFig,'type','axes');
hXLabel     = get(hAxes,'XLabel'); hXLabel = [hXLabel{:}]; %Comment 2nd part out
hYLabel     = get(hAxes,'YLabel'); hYLabel = [hYLabel{:}]; % if more than one
hTitle      = get(hAxes,'Title');  hTitle = [hTitle{:}];
hUIControls = findall(hFig,'type','uicontrol');
hCheckboxLabels    = findall(hUIControls,'style','checkbox');
hGuessHeaderLabels = findall(hUIControls,'Tag','HeaderSize1');

%--------------------------------------------------------------------------------
% Set FontName
%--------------------------------------------------------------------------------
set([hAxes; hUIControls],'FontName',FontName);

%--------------------------------------------------------------------------------
% Set FontSizes
%--------------------------------------------------------------------------------
hObj = [hAxes; hXLabel'; hYLabel'; hTitle'; hUIControls];
OldUnits = get(hObj,'FontUnits');
set(hObj,'FontUnits','Points');
set(hAxes  ,              'FontSize', SCALE*AxisTickLabels);
set(hXLabel,              'FontSize', SCALE*AxisXLabel);
set(hYLabel,              'FontSize', SCALE*AxisYLabel);
set(hTitle,               'FontSize', SCALE*AxisTitle);
set(hUIControls,          'FontSize', SCALE*DefaultLabel);
set(hCheckboxLabels,      'FontSize', SCALE*CheckboxLabels);
set(hGuessHeaderLabels,   'FontSize', SCALE*GuessHeaderLabels);
set(hObj,{'FontUnits'},OldUnits);

switch computer
case 'MAC2'
   % On MAC, baseline of text inside edit boxes remains at same
   % vertical position irregardless of change in font size.
   % To properly align text, here the old edit boxes are deleted
   % and new ones created with the proper size.
   hEd = findall(gcf,'type','uicontrol','style','edit');
   OldFontUnits = get(hEd,'FontUnits');
   hEdNew = zeros(size(hEd));
   warning off; % Turn off warning about units
   for i = 1:length(hEd)
      Props = get(hEd(i));
      Props = rmfield(Props,{'Extent','Type','FontSize','FontUnits'});
      delete(hEd(i));
      hEdNew(i) = uicontrol('FontUnits','Normalized','FontSize',0.35,Props);
   end
   warning on;
   set(hEdNew,{'FontUnits'},OldFontUnits);
end