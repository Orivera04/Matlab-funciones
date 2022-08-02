function optionFcnFile = establish_function_file_name_rt(path,uniqueName)
%ESTABLISH_FUNCTION_FILE_NAME This function establishes function file name
%
%   [OPTIONFCNFILE]=ESTABLISH_FUNCTION_FILE_NAME(PATH,UNIQUENAME) 
%   This function takes in the path to the function and the unique function
%   name as its inputs and sets the option function file attributes in the 
%   output structure. 
%
%   INPUTS:
%            path          : Path to the generated code file 
%            uniqueName    : Unique function anme
%
%   OUTPUTS:
%            optionFcnFile : structure containing the function file names  
%                  
%

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/04/15 00:28:01 $

optionFcnFile.subSysName = get_param(path,'Name');
optionFcnFile.RTWSystemCode = get_param(path,'RTWSystemCode');
optionFcnFile.RTWFcnNameOpts = get_param(path,'RTWFcnNameOpts');
optionFcnFile.RTWFcnName = get_param(path,'RTWFcnName');
optionFcnFile.TreatAsAtomicUnit = get_param(path,'TreatAsAtomicUnit');
optionFcnFile.RTWFileNameOpts = get_param(path,'RTWFileNameOpts');
optionFcnFile.RTWFileName = get_param(path,'RTWFileName');
ph = get_param(path,'PortHandles');
if isempty(ph.Trigger) == 0
    optionFcnFile.trigBlock = 1;
else
    optionFcnFile.trigBlock = 0;
end
switch(optionFcnFile.RTWSystemCode)
    case {'Function','Reusable function'}
        switch(optionFcnFile.RTWFcnNameOpts)
            case 'Auto'
                %         optionFcnFile.MPMFcnName = optionFcnFile.subSysName;
                optionFcnFile.MPMFcnName = [];
            case {'UserSubsystemName','Use subsystem name'}
                optionFcnFile.MPMFcnName = optionFcnFile.subSysName;
            case {'UserSpecified','User specified'}
                optionFcnFile.MPMFcnName = optionFcnFile.RTWFcnName;
                if isempty(optionFcnFile.MPMFcnName) == 1
                    optionFcnFile.MPMFcnName =  uniqueName;
                end
            otherwise
                optionFcnFile.MPMFcnName = optionFcnFile.subSysName;
        end
    case 'Auto'
        %     optionFcnFile.MPMFcnName = optionFcnFile.subSysName;
        optionFcnFile.MPMFcnName = [];
        optionFcnFile.MPMFileName = optionFcnFile.subSysName;
        return;
    case 'Inline'
        optionFcnFile.MPMFcnName = [];
        %     optionFcnFile.MPMFcnName = optionFcnFile.subSysName;
        optionFcnFile.MPMFileName = optionFcnFile.subSysName;
        return;
    otherwise
        optionFcnFile.MPMFcnName = optionFcnFile.subSysName;
end


switch(optionFcnFile.RTWFileNameOpts)
case 'Auto'
    optionFcnFile.MPMFileName = optionFcnFile.subSysName;
case {'UseSubsystemName','Use subsystem name'}
    optionFcnFile.MPMFileName = optionFcnFile.subSysName;
case {'UseFunctionName','Use function name'}
    optionFcnFile.MPMFileName = optionFcnFile.MPMFcnName;
case {'UserSpecified','User specified'}
    optionFcnFile.MPMFileName = optionFcnFile.RTWFileName;
            if isempty(optionFcnFile.MPMFileName) == 1
            optionFcnFile.MPMFileName =  uniqueName;
        end
otherwise
end
 