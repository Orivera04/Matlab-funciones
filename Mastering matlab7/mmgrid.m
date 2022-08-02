function mmgrid(varargin)
%MMGRID  Individual Axis Grid Lines on the Current Axes.
% V is a single character X, Y, or Z denoting the desired axis.
% MMGRID V toggles the major grid lines on the V-axis.
% MMGRID V ON adds major grid lines to the V-axis.
% MMGRID V ON MINOR adds minor grid lines to the V-axis.
% MMGRID V OFF removes major grid lines from the V-axis.
% MMGRID V OFF MINOR removes minor grid lines from the V-axis.
% 
% See also GRID

ni = nargin;
if ni==0
   error('At Least One Input Argument Required.')
end
if ~iscellstr(varargin)
   error('Input Arguments Must be Strings.')
end

Hf = get(0,'CurrentFigure'); % get current figure if it exists
if isempty(Hf) % no figure so do nothing
   return
end

Ha = get(Hf,'CurrentAxes'); % get current axes if it exists
if isempty(Ha) % no axes so do nothing
   return
end

% parse input and do work
V = varargin{1};
idx = strfind('xXyYzZ',V(1));
if isempty(idx)
   error('Unknown Axis Selected.')
end

VGrid = [upper(V(1)) 'Grid'];

if ni==1  % MMGRID V      Toggle Grid
   Gstate = get(Ha,VGrid);
   if strcmpi(Gstate,'on')
      set(Ha,VGrid,'off')
   else
      set(Ha,VGrid,'on')
   end
   
elseif ni==2  % MMGRID V ON  or MMGRID V OFF
   OnOff = varargin{2};
   if strcmpi(OnOff,'on')
      set(Ha,VGrid,'on')
   elseif strcmpi(OnOff,'off')
      set(Ha,VGrid,'off')
   else
      error('Second Argument Must be On or OFF.')
   end
   
elseif ni==3  % MMGRID V ON MINOR  or MMGRID V OFF MINOR
   if ~strcmpi(varargin{3},'minor')
      error('Unknown Third Argument.')
   end
   VGrid = [upper(V(1)) 'MinorGrid'];
   OnOff = varargin{2};
   if strcmpi(OnOff,'on')
      set(Ha,VGrid,'on')
   elseif strcmpi(OnOff,'off')
      set(Ha,VGrid,'off')
   else
      error('Second Argument Must be On or OFF.')
   end 
end