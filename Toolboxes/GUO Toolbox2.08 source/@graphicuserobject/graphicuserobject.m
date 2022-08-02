function GUO = graphicuserobject(varargin);

% function GUO = graphicuserobject(varargin);
% 
% Class constructor for graphicuserobject.  The argument list "varargin", if
% supplied, is passed on to the axes function when creating the GUO frame.  In
% particular, the Position property would normally be supplied and, for
% example, Visible can be specified as 'on' in order to provide a border for
% the GUO.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 1 & isa(varargin(1), 'graphicuserobject')
   GUO = varargin(1);
else
   GUO.Children = [];
   GUO.NormalizedChildren = [];
   GUO.ChildOriginalUnits = {};
   GUO.ChildOriginalPositions = {};
   GUO.ChildGUOs = {};
   GUO.NormalizedChildGUOs = [];
   GUO.ChildGUOOriginalUnits = {};
   GUO.ChildGUOOriginalPositions = {};
   % The following variables are for the hide & show methods
   GUO.Hidden = 0;
   GUO.HiddenFrameWasVisible = '';
   GUO.FrameChildren = [];
   GUO.FrameChildWasVisible = {};
   GUO.HiddenChildWasVisible = {};
   GUO.HiddenGrandchildren = {};
   GUO.HiddenGrandchildWasVisible = {};
   GUO.ChildGUOWasHidden = [];
   ChildArgs = varargin;
   if ~isempty(ChildArgs) & ishandle(ChildArgs{1})
      figure(ChildArgs{1});  % axes created in the current figure
      ChildArgs = ChildArgs(2:end);
   end
   if ~FindProperty('Color', ChildArgs)
      ChildArgs = [ChildArgs, {'Color', 'none'}];
   end
   if ~FindProperty('Box', ChildArgs)
      ChildArgs = [ChildArgs, {'Box', 'on'}];
   end
   if ~FindProperty('XTickMode', ChildArgs)
      ChildArgs = [ChildArgs, {'XTickMode', 'manual'}];
   end
   if ~FindProperty('YTickMode', ChildArgs)
      ChildArgs = [ChildArgs, {'YTickMode', 'manual'}];
   end
   if ~FindProperty('XLim', ChildArgs)
      ChildArgs = [ChildArgs, {'XLim', [0 1]}];
   end
   if ~FindProperty('YLim', ChildArgs)
      ChildArgs = [ChildArgs, {'YLim', [0 1]}];
   end
   if ~FindProperty('NextPlot', ChildArgs)
      ChildArgs = [ChildArgs, {'NextPlot', 'replacechildren'}];
   end  % avoid reset of axes properties (e.g. Tag) by plot function etc.
   if ~FindProperty('Visible', ChildArgs)
      ChildArgs = [ChildArgs, {'Visible', 'off'}];
   end
   TagFound = FindProperty('Tag', ChildArgs);
   GUO.Frame = axes(ChildArgs{:});
   if ~TagFound
      set(GUO.Frame, 'Tag', num2str(GUO.Frame, '%16bx'));
   end
   GUO = class(GUO, 'graphicuserobject');
end
