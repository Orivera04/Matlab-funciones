function evaltooltips(UserData, PTName);

% function evaltooltips(UserData, PTName);
% 
% Updates the TooltipString to display the current values for the
% controls corresponding to the parameter types specified by PTName
% (cell array of strings).
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

n = length(PTName);
for k = 1:n
   PTN = PTName{k};
   Pstring = getparametervalue(UserData, PTN);
   PTnum = find(strcmp(UserData.PTName, PTN));
   PDT = UserData.PTDataType{PTnum};  % Parameter data type
   PTQ = UserData.PTDataTypeQualifier{PTnum};
   if isempty(PTQ)
      DE = '';
   else
      DE = PTQ{1};  % Display Expression
   end
   if isempty(DE)
      if isempty(Pstring)
         Pstring = ['No value supplied for parameter "' PTN '"'];
      else
         switch PDT  % See AllowedDataTypes in setparametertypes.m
         case {'output', 'reference'}
            try  % Get value of variable in base workspace as string
               Pvalue = evalin('base', Pstring);
               Pstring = evalc('disp(Pvalue)');
            catch
               Pstring = lasterr;
            end
         end
      end
   else
      switch PDT  % See AllowedDataTypes in setparametertypes.m
      case 'string'
         Pstring = ['''' Pstring ''''];
      case 'array'
         Pstring = ['[' Pstring ']'];
      end
      try  % Substitute dollar sign & evaluate in base workspace
         Pstring = evalin('base', strrep(DE, '$', Pstring));
      catch
         Pstring = lasterr;
      end
   end
   if size(Pstring, 1) > 1  % TooltipString must be 1-dimensional
      Pstring = evalc('disp(Pstring)');
   end
   % The following code uses handles because this function does not have
   % access to the GUO itself and therefore cannot use the getchild and 
   % setchild methods, but it is NOT good GUO programming practice!
   hc = findobj(UserData.PTControls, 'Tag', PTN);  % Control handle
   set(hc, 'TooltipString', Pstring);
end
