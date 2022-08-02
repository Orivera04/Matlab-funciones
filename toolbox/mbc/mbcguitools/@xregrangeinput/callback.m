function out=callback(obj,editNum)
%% callback from xregrangeinput
%% checks that inputs are sensible:
%% min < max, max > min, pts >=1
%% looks in base workspace for non-numeric input and 
%% writes in a value or overwrites entire input with a vector

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:38 $


ud = get(obj.name,'userdata');

var = get(obj.edit(editNum),'string');
oldVar = {ud.min, ud.max, ud.points}; oldVar = oldVar{editNum};
newVar=oldVar;
oldVector = linspace(ud.min,ud.max,ud.points);
newVector=[];

if ~isempty(str2num(var)) & length(str2num(var))==1 & isreal(str2num(var))
   %% constant
   newVar = str2num(var);
else %% workspace variable (vector or const?), or rubbish
   try
      %% try base workspace
      new_value = evalin('base' , var);
      
      if isnumeric(new_value) & isreal(new_value) & length(new_value)>1 & length(new_value)==prod(size(new_value))
         %% vector - turn into linspace - use to fill all edit boxes
         newVector= new_value;
      elseif isnumeric(new_value) & isreal(new_value) & length(new_value)==1
         %% constant val - write numeric val in edit box
         set(obj.edit(editNum),'string',num2str(new_value));
         newVar = new_value;
      else%% leave it as it was
         set(obj.edit(editNum),'string',num2str(oldVar));
      end
      
   catch  %% leave it as it was
      set(obj.edit(editNum),'string',num2str(oldVar));
   end
end

if isempty(newVector)
   switch num2str(editNum)
   case '1'
      if newVar<ud.max, newVector = linspace(newVar, ud.max, ud.points); else, newVector=oldVector; end;
   case '2'
      if newVar>ud.min, newVector = linspace(ud.min, newVar, ud.points); else, newVector=oldVector; end;
   case '3'
      if newVar>0.5 , newVector = linspace(ud.min, ud.max, round(newVar)); else, newVector=oldVector; end;
   end
end


set(obj,'value',newVector);

if ~isempty(ud.callback)
   xregcallback(ud.callback,obj,[]);
end

