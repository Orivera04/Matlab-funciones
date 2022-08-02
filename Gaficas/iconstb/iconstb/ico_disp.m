function ico = ico_disp(filename,oldflag,nbCol)
% ICO_DISP - Display a set of icons stored in a MAT-File

% Init icon structure
ico = struct();

% Check input arguments
if ~nargin
  filename = 'icons.mat';
  oldflag  = false;
  nbCol    = 20;
elseif nargin < 2
  oldflag = false;
  nbCol   = 20;
elseif nargin < 3
  nbCol = 20;
end

% Load Icons File
load(filename,'ico');

% Get the names of all icons
icoNames = fieldnames(ico);

% Number of icons
nbIco = length(icoNames);

% Adapt the name of the figure in order to include the name of the icons file
figTitle = sprintf('Library %s / %d icons',filename,nbIco);

% Number of pushbuttons columns and lines displayed
nbC = nbCol;
nbL = ceil(nbIco/nbC);

% Pushbuttons dimensions
pbW = 40;
pbH = 40;

% Space between pushbuttons
spC = 15;
spL = 15;

% Compute figure width and height
figW = nbC * pbW + spC * (nbC + 1);
figH = nbL * pbH + spL * (nbL + 1);

% Create figure
f = figure( ...
  'NumberTitle', 'off', ...
  'MenuBar', 'none', ...
  'Name', figTitle, ...
  'Units', 'pixels', ...
  'Position', [100 100 figW figH]);

% Create all pushbuttons (1 for each icon)
for indIco=1:nbIco
  
  % Find column and line indice
  [iC,iL] = ind2sub([nbC,nbL],indIco);
  
  % Compute pushbutton position
  pbPos = [iC*spC+(iC-1)*pbW , figH - iL * (spL+pbH) , pbW , pbH];
  
  if oldflag
    
    % If oldflag is true display a Windows Classic style pushbutton
    
    uicontrol('Parent',f,...
      'Style','togglebutton',...
      'Units','pixels',...
      'Position',pbPos,...
      'BackgroundColor',[.85 .85 .85], ...
      'CData',ico.(icoNames{indIco}),...
      'TooltipString',['.    ' icoNames{indIco} '    .'],...
      'Callback',['disp(''ico.' icoNames{indIco} ''')']);
    
  else
    
    % Otherwise display the OS default pushbutton
    
    uicontrol('Parent',f,...
      'Style','togglebutton',...
      'Units','pixels',...
      'Position',pbPos,...
      'CData',ico.(icoNames{indIco}),...
      'TooltipString',['.    ' icoNames{indIco} '    .'],...
      'Callback',['disp(''ico.' icoNames{indIco} ''')']);
    
  end
  
end