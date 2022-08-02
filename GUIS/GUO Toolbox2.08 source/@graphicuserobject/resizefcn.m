function GUO = resizefcn(GUO);

% function GUO = resizefcn(GUO);
% 
% Corrects the position of children and child GUOs of "GUO" after the parent
% figure is resized.  However, most cases are handled automatically:  it is 
% only necessary to call this function (from the figure's ResizeFcn) if "GUO"
% has Units 'normalized' and contains one or more children or child GUOs having
% Units other than 'normalized' (e.g. 'pixels').
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
if strcmpi(get(GUO.Frame,'Units'), 'normalized')
   nChildGUOs = length(GUO.ChildGUOs);
   for k = 1:nChildGUOs
      OrigUnits = GUO.ChildGUOOriginalUnits{k};
      if ~strcmpi(OrigUnits, 'normalized')
         GUO = PositionInFrame(GUO, GUO.ChildGUOs{k}, k, OrigUnits, GUO.ChildGUOOriginalPositions{k});
      end
   end
   nChildren = length(GUO.Children);
   for k = 1:nChildren
      OrigUnits = GUO.ChildOriginalUnits{k};
      if ~strcmpi(OrigUnits, 'normalized')
         GUO = PositionInFrame(GUO, GUO.Children(k), k, OrigUnits, GUO.ChildOriginalPositions{k});
      end
   end
end
