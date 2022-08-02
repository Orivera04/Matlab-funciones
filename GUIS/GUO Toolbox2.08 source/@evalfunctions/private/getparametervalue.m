function Pvalue = getparametervalue(UserData, PTName);

% function Pvalue = getparametervalue(UserData, PTName);
% 
% Returns the current value (string) from the control for the parameter
% type specified by PTName (also checks for ListBox / PopupMenu).
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

% The following code uses handles because this function does not have
% access to the GUO itself and therefore cannot use the getchild and 
% setchild methods, but it is NOT good GUO programming practice!
hc = findobj(UserData.PTControls, 'Tag', PTName);  % Control handle
Pvalue = get(hc, 'String');        % Parameter value
ControlStyle = get(hc,'Style');
if strcmpi(ControlStyle, 'listbox') | strcmpi(ControlStyle, 'popupmenu')
   U = get(hc, 'UserData');        % Translation list
   if isempty(U)
      U = itemlist2cell(Pvalue);
   end
   Pvalue = U{get(hc, 'Value')};
end
