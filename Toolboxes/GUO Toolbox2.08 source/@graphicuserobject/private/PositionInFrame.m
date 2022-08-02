function GUO = PositionInFrame(GUO, ChildHandle, Index, ChildUnits, ChildPosition);

% function GUO = PositionInFrame(GUO, ChildHandle, Index, ChildUnits, ChildPosition);
% 
% Position/size child relative to GUO frame.
% ChildHandle may be either a child GUO or the handle of a child control.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

ChildIsControl = ishandle(ChildHandle);  % otherwise child GUO
if nargin < 5
   if nargin < 4
      try
         if ChildIsControl
            ChildWasNormalized = GUO.NormalizedChildren(Index);
         else
            ChildWasNormalized = GUO.NormalizedChildGUOs(Index);
         end
      catch
         ChildWasNormalized = 0;  % in case Index not within range
      end
      if ChildWasNormalized
         ChildUnits = 'normalized';
      else
         ChildUnits = get(ChildHandle, 'Units');
      end
   end
   ChildPosition = get(ChildHandle, 'Position');
end
FrameUnits    = get(GUO.Frame, 'Units');
FramePosition = get(GUO.Frame, 'Position');
set(ChildHandle, 'Units', FrameUnits);
UnitsNormalized = strcmpi(ChildUnits, 'normalized');
if ChildIsControl
   GUO.NormalizedChildren(Index) = UnitsNormalized;
   GUO.ChildOriginalUnits{Index} = ChildUnits;
   GUO.ChildOriginalPositions{Index} = ChildPosition;
else
   GUO.NormalizedChildGUOs(Index) = UnitsNormalized;
   GUO.ChildGUOOriginalUnits{Index} = ChildUnits;
   GUO.ChildGUOOriginalPositions{Index} = ChildPosition;
end
if UnitsNormalized
   FrameXY = [FramePosition(1:2) zeros(1,2)];
   FrameSize = FramePosition(3:4);
   set(ChildHandle, ...
       'Position', ...
       FrameXY + (ChildPosition .* [FrameSize FrameSize]));
else
   set(ChildHandle, 'Position', FramePosition);
   set(ChildHandle, 'Units', ChildUnits);
   FramePosition = get(ChildHandle, 'Position');   % Frame position in child units
   FrameXY = [FramePosition(1:2) zeros(1,2)];      
   set(ChildHandle, 'Position', FrameXY + ChildPosition);
end
