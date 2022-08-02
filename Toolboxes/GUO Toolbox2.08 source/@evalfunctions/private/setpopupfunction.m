function setpopupfunction(DummyEF, FrameTag, FunctionNumber);

% function setpopupfunction(DummyEF, FrameTag, FunctionNumber);
% 
% Selects function in PopupMenu control and makes the
% associated parameter controls visible.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = getuserdata(DummyEF, FrameTag);
UserData.PopupValue = FunctionNumber;
set(UserData.PTControls, 'Visible', 'off');
% Handles used - see also below...
PopupHandle = findobj(UserData.FunctionControls, 'Tag', 'EF_Popup');
Ppos = get(PopupHandle, 'Position');
X1 = Ppos(1) + Ppos(3);
X = X1;
Y = Ppos(2) - Ppos(4);
Ytext = Ppos(2) + Ppos(4);
F = UserData.Functions{UserData.PopupValue};
FIP = UserData.FirstInputParameter(UserData.PopupValue);
for k = 2:length(F)
   if k == FIP     % First input parameter (after output parameters) -
      X = X1;      % reinitialise X and Y positions
      Y = Ppos(2);
   end
   PTN = F{k};  % Parameter Type Name
   PTNText = UserData.PTNameText{find(strcmp(UserData.PTName, PTN))};
   % The following code uses handles and assumes that all controls have
   % the same units (normalized) as set by setparametertypes...
   % This is necessary because the popupcallback routine does not have
   % access to the GUO itself and therefore cannot use the getchild and 
   % setchild methods, but it is NOT good GUO programming practice!
   hc = findobj(UserData.PTControls, 'Tag', PTN);  % Control handle
   Cpos = get(hc, 'Position');
   set(hc, 'Position', [X Y Cpos(3) Cpos(4)], 'Visible', 'on');
   if k >= FIP  % No text objects for output parameters
      ht = findobj(UserData.PTControls, 'Tag', PTNText);  % Text handle
      Tpos = get(ht, 'Position');
      set(ht, 'Position', [X Ytext Tpos(3) Tpos(4)], 'Visible', 'on');
   end
   X = X + Cpos(3);
end
evaltooltips(UserData, F(2:end));
setuserdata(DummyEF, FrameTag, UserData);
