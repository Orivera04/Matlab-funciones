function callback(obj)
%% callback from XREGCONSTINPUT
%% checks that inputs are sensible:
%% min < value < max
%% looks in base workspace for non-numeric input and 
%% writes in a value

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:31:49 $

ud = get(obj.text,'userdata');
%% should we fire the callback??
cbFLAG=1;

if ud.CharStatus
   %Then we do no checks, and allow anything to be put into the XREGCONSTINPUT.
else
   %% check value is within limits
   minVal = ud.min;
   maxVal = ud.max;
   oldVar = ud.value;
   var = get(obj.edit,'string');
   
   if isempty(var)
      set(obj.edit,'string',num2str(oldVar));
      newVar = oldVar;
      cbFLAG=0; %% no callback
   elseif ~isempty(str2num(var)) & length(str2num(var))==1 & isreal(str2num(var))...
         & str2num(var) <= maxVal & str2num(var) >= minVal
      newVar = str2num(var);
   else %% workspace variable, or rubbish
      try
         %% try base workspace
         new_value = evalin('base' , var);
         
         if ~isempty(str2num(var)) & isnumeric(new_value) & isreal(new_value) & length(new_value)==1 ...
               & str2num(var) <= maxVal & str2num(var) >= minVal
            %% constant val - write numeric val in edit box
            set(obj.edit,'string',num2str(new_value));
            newVar = new_value;
         else%% leave it as it was
            set(obj.edit,'string',num2str(oldVar));
            newVar = oldVar;
         end
         
      catch  %% leave it as it was
         set(obj.edit,'string',num2str(oldVar));
         newVar = oldVar;
         cbFLAG=0; %% no callback
      end
   end
   ud.value = newVar;
   set(obj.text,'userdata',ud);
end

if ~isempty(ud.callback) & cbFLAG
   xregcallback(ud.callback,obj,[]);
end

