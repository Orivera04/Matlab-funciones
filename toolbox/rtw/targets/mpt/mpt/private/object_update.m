function object_update(scriptName)
%OBJECT_UPDATE - UDD Data Object Updates.
%
%   OBJECT_UPDATE(SCRIPTNAME)
%         This function updates simulink data objects from a script file with
%         the corresponding values of the variables in the script file.  The
%         relationship is purely name recognition of the simulink data objects
%         and the script variables.
%
%   INPUT:
%         scriptName: The script file to use


%   Revised: Linghui Zhang
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:28:39 $

%
% Evaluate the script and get the parameters in the script file
%
try
   eval(scriptName);
catch
   disp(['Invalid script name, cannot execute script : ',scriptName]);
   return
end
sData = who;
crlf = sprintf('\n');
%
% Check the base workspace to get all of the Parameters there
%

wsData = evalin('base','whos');

%
% Set temporary counter to 1;
%

cnt = 1;

%
% Search through the workspace data looking for mpt.Parameter Data Objects to update
% and create a list of these data objects to
%

dataObject = get_mpt_data_object_registry;

for i=1:length(wsData)
    for j = 1:length(dataObject)
        %    if strcmp(wsData(i).class,'mpm.Parameter'),
       if strcmp(wsData(i).class,[dataObject(j).class{1},'.Parameter']) | ...
          strcmp(wsData(i).class,[dataObject(j).class{1},'.Signal'])    
            wspData{cnt} = wsData(i);
            wspDataName{cnt} = wsData(i).name;
            cnt = cnt + 1;
            break;
       end
    end
end

%
% Next Check for Overlap between the script file and the data Objects
%

if exist('wspDataName','var')==1,
   [commonValues,sDataIndex,wspDataNameIndex] = intersect(sData,wspDataName);
   if isempty(commonValues) == 0
       for k = 1:length(wspDataNameIndex)
           commonVClass{k} = wspData{wspDataNameIndex(k)}.class;
       end
   end
else
   evalin('base',scriptName);
   return
end

%
% Add "scriptName" to the list to eliminate ist from being created in the workspace.
%

wspDataName{end+1} = 'scriptName';

%
% Next check for values in the script that are not in the workspace data objects
%

[sDataValues,sDataIndex]= setdiff(sData,wspDataName);

%
% Update the data Objects with the values from the script file
%

for i=1:length(commonValues)
  assignin('base','tempValueName',eval(commonValues{i}));
  if strfind(commonVClass{i},'Parameter')
     evalin('base',[commonValues{i},'.Value = tempValueName;']);
  elseif strfind(commonVClass{i},'Signal')
     evalin('base',[commonValues{i},'.InitialValue = tempValueName;']);
  end
  evalin('base','clear tempValueName;');
end

%
% Add the rest of the variables to the base workspace that were not in the script file.
%

for i=1:length(sDataValues)
  assignin('base',sDataValues{i},eval(sDataValues{i}));
end

return
