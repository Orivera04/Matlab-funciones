function val = set(GUO, varargin);

% function val = set(GUO, varargin);
% 
% Sets properties for the GUO frame of "GUO" (in which case the modified GUO is
% returned as "val") or returns information as for the standard MATLAB "set"
% function.  Property changes which affect the children of "GUO" are taken into
% consideration (e.g. Parent, Position and Units).
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
OldParent   = get(GUO.Frame, 'Parent');
OldPosition = get(GUO.Frame, 'Position');
OldUnits    = get(GUO.Frame, 'Units');
try  % try/catch necessary in MATLAB R13 because of error "One or more output arguments not assigned during call to 'set'"
    warning off;  % Suppress warning in R12 when the "set" function doesn't deliver a result (normal case!)
    val = set(GUO.Frame, varargin{:});
    warning on;
catch
    set(GUO.Frame, varargin{:});
end
if ~exist('val')
   nChildGUOs = length(GUO.ChildGUOs);
   nChildren = length(GUO.Children);
   if nChildGUOs > 0 | nChildren > 0
      NewParent = get(GUO.Frame, 'Parent');
      if OldParent ~= NewParent
         for k = 1:nChildGUOs
            set(GUO.ChildGUOs{k}, 'Parent', NewParent);
         end
         set(GUO.Children, 'Parent', NewParent);
         figflag(get(NewParent, 'Name'));
      end
      % Position calculations all in OldUnits
      NewUnits = get(GUO.Frame, 'Units');
      if ~strcmpi(OldUnits, NewUnits)
         set(GUO.Frame, 'Units', OldUnits);
      end
      NewPosition = get(GUO.Frame, 'Position');
      if ~strcmpi(OldUnits, NewUnits)
         set(GUO.Frame, 'Units', NewUnits);
      end
      if max(abs(NewPosition - OldPosition)) > 0
         PosChange = NewPosition(1:2) - OldPosition(1:2);
         SizeChange = NewPosition(3:4) ./ OldPosition(3:4);
         for k = 1:nChildGUOs
            ChildGUO = GUO.ChildGUOs{k};
            ChildGUOUnits = get(ChildGUO, 'Units');
            if ~strcmpi(ChildGUOUnits, OldUnits)
               set(ChildGUO, 'Units', OldUnits);
            end
            ChildGUOPosition = get(ChildGUO, 'Position');
            if GUO.NormalizedChildGUOs(k)
               ChildGUOPosition = ChildGUOPosition - [OldPosition(1:2) zeros(1,2)];
               ChildGUOPosition = [ChildGUOPosition(1:2).*SizeChange ChildGUOPosition(3:4).*SizeChange];
               ChildGUOPosition = ChildGUOPosition + [NewPosition(1:2) zeros(1,2)];
               ChildUnits = NewUnits;  % Set units for normalized child GUO same as GUO frame
            else
               ChildGUOPosition = ChildGUOPosition + [PosChange zeros(1,2)];
            end
            set(ChildGUO, 'Position', ChildGUOPosition);
            if ~strcmpi(ChildGUOUnits, OldUnits)
               set(ChildGUO, 'Units', ChildGUOUnits);
            end
         end
         for k = 1:nChildren
            Child = GUO.Children(k);
            ChildUnits = get(Child, 'Units');
            if ~strcmpi(ChildUnits, OldUnits)
               set(Child, 'Units', OldUnits);
            end
            ChildPosition = get(Child, 'Position');
            if GUO.NormalizedChildren(k)
               ChildPosition = ChildPosition - [OldPosition(1:2) zeros(1,2)];
               ChildPosition = [ChildPosition(1:2).*SizeChange ChildPosition(3:4).*SizeChange];
               ChildPosition = ChildPosition + [NewPosition(1:2) zeros(1,2)];
               ChildUnits = NewUnits;  % Set units for normalized child same as GUO frame
            else
               ChildPosition = ChildPosition + [PosChange zeros(1,2)];
            end
            set(Child, 'Position', ChildPosition);
            if ~strcmpi(ChildUnits, OldUnits)
               set(Child, 'Units', ChildUnits);
            end
         end
      end
   end
   val = GUO;
end
