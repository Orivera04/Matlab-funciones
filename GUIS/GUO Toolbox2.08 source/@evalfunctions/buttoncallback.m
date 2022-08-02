function buttoncallback(DummyEF, FrameTag);

% function buttoncallback(DummyEF, FrameTag);
% 
% Callback function for buttons within evalfunctions object.
% FrameTag is used to access the UserData property of the GUO frame.
% DummyEF is required by MATLAB and will be deleted.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = getuserdata(DummyEF, FrameTag);
F = UserData.Functions{UserData.PopupValue};
FName = UserData.FunctionNames{UserData.PopupValue};
ButtonTag = get(gcbo, 'Tag');
switch ButtonTag
case 'EF_Evaluate'
   FIP = UserData.FirstInputParameter(UserData.PopupValue);
   if FIP > 2                       % Output parameters
      E = '[';
      LOP = min(FIP-1, length(F));  % Last Output Parameter
      for k = 2:LOP
         if k > 2
            E = [E ','];
         end
         E = [E getparametervalue(UserData, F{k})];
      end
      E = [E '] = '];
   else
      E = '';
   end
   E = [E FName];                   % Function name
   if FIP <= length(F)
      E = [E '('];
      for k = FIP:length(F)         % Input parameters
         if k > FIP
            E = [E ','];
         end
         PTName = F{k};             % Parameter type name
         Pvalue = getparametervalue(UserData, PTName);
         PTnum = find(strcmp(UserData.PTName, PTName));
         PDT = UserData.PTDataType{PTnum};  % Parameter data type
         switch PDT  % See AllowedDataTypes in setparametertypes.m
         case 'string'
            E = [E '''' Pvalue ''''];
         case 'number'
            E = [E Pvalue];
         case 'array'
            E = [E '[' Pvalue ']'];
         case 'reference'
            E = [E Pvalue];
         otherwise  % e.g. 'output' should never appear here
            error(['Unexpected parameter data type:  ' PDT]);
         end
      end
      E = [E ')'];
   end
   E = [E ';'];
   disp(E);
   evalin('base', E);
   evaltooltips(UserData, F(2:end));
case 'EF_Help'
   E = ['help ' FName];
   disp(E);
   evalin('base', E);
otherwise
   error(['Unknown ButtonTag:  ' ButtonTag]);
end
delete(DummyEF);
