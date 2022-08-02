function status = set_data_info(name,attribute,newValue,varargin)
%SET_DATA_INFO - Set the data object property fields.
%
%   [STATUS]=SET_DATA_INFO(NAME,ATTRIBUTE,NEWVALUE,VARARGIN)
%   This function will set the attribute of the simulink data object named
%   as the newvalue passed in.  A 1 or 0 will be returned as a pass or fail
%   of the operation.
%
%   INPUTS:     name       : Name  of the simulink data object.
%               attribute  : Name of the attribute to set.
%               newValue   : New value to which the attribute is to be set.
%               varargin{1}: The name of model
%   OUTPUTS:    status     : Pass Fail Status Flag, 1 = pass, 0 = fail.
%
%   Possible Attributes that this function will set.
%   ALIAS          - Another refernce name
%   DATATYPE       - Object DataType
%   DEFINITIONFILE - Definition file associated with this object
%   DESCRIPTION    - Description or LongID of an object
%   DECLARE        - Determines of RTW or MPT declares a variable/parameter
%                    (Hidden Flag for internal use only) 0 - RTW, 1 - MPT
%   FILEINCLUDE    - Include file for this object
%   INITIALVALUE   - Initialization value of the object
%   MIN            - Minimum Allowed Value
%   MAX            - Maximum Allowed Value
%   OWNER          - Owner of the data object
%   SCOPE          - Scope of the Variable
%   BASESTORAGECLASS - Storage Class of data object
%   STORAGECLASS  - MemorySection of data object
%   SYMBOL         - Code Generation Template Symbol
%   UNITS          - Units of an Object
%   VALUE          - Value of a Paremeter object type
%
%  Note: R13 does not support the modelworkspace.

%  Patrick W. Menter
%  Linghui Zhang
%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.1.6.6 $  $Date: 2004/04/15 00:29:04 $

%
% Check to see if the object is present in the workspace

name = strrep(name,' ','');
ver = version('-release');
vernum = str2num(ver);
status = 0;
stat = [];
dataStr = [];
obj = [];

if vernum < 14
    %base workspace only before R14
    stat = evalin('base',['whos(''',name,''')']);
    caller = 'base';
    modelName = '';
    if isempty(stat)
        %    disp(['** Warning: Data object "',name,'" does not exist in the base workspace. **']);
        return;
    end
else
    % for R14 and R14+
    if nargin >= 4 && ~isempty(varargin{1})
        %base workspace or model workspace
        modelName = varargin{1};
        modelws = get_param(modelName, 'ModelWorkspace');
        statM = evalin(modelws,['whos(''',name,''')']);  %model worksapce
        statB = evalin('base',['whos(''',name,''')']);   %base workspace
        stat = statB;
        caller = 'base';
        if ~isempty(statM)
            %model worksapce
            obj = evalin(modelws,name);
            if isa(obj,'Simulink.Signal')
                status = 0;
                return
            else
              % model workspace parameter                
                caller = modelws;
                status = 0;
                if isequal(upper(attribute),'VALUE')
                    if isa(obj,'Simulink.Parameter')
                        if isnumeric(newValue)
                            cmd = [name,'.Value = ',num2str(newValue),';'];
                        else
                            cmd = [name,'.Value = ''',newValue,''';'];
                        end
                    else
                        if isnumeric(newValue)
                            cmd = [name,'= ',num2str(newValue),';'];
                        else
                            cmd = [name,'= ''',newValue,''';'];
                        end
                    end
                    try
                        evalin(caller,cmd);
                        status = 1;
                    catch
                        status = 0;
                    end
                end
                return
            end
        end
    else
        %base workspace only
        stat = evalin('base',['whos(''',name,''')']);
        caller = 'base';
        modelName = '';
    end
end

% For base workspace parameter & singal

if isempty(stat)
    %  disp(['** Warning: Data object "',name,'" does not exist in the base workspace. **']);
    return;
end

dataObjClass = stat.class;

if isempty(findstr(dataObjClass,'.Parameter'))& ...
   isempty(findstr(dataObjClass,'.Signal'))
    % disp(['** Warning: Data object "',name,'" does not exist in the workspace. **']);
    return
end

%
% Use the switch to determine the attribute desired
try
    switch upper(attribute)
        case{'RESOLUTION'}
            attributeStr ='MptResolution';
        case{'DATATYPE'}
          obj = evalin(caller,name);
          if isa(obj,'mpt.Signal') 
             attributeStr ='UserDataType'; 
          elseif ~isa(obj,'Simulink.Parameter')
              attributeStr ='DataType';
              cmd = [name,'.set(''',attributeStr,''',''',newValue,''');'];
              try,
                  evalin(caller,cmd);
                  status = 1;
              catch
                  status = 0;
              end
              return
          else
              status = 0;
              return
          end
        case{'DESCRIPTION'}
            attributeStr = 'Description';
        case{'INITIALVALUE','INITIAL_VALUE'}
            attributeStr = 'InitialValue';
            % newValue = num2str(newValue);
        case{'DIMENSION'}
            attributeStr = 'Dimension';
            newValue = num2str(newValue);
        case{'ALIAS'}
            attributeStr = 'Alias';
        case{'BASESTORAGECLASS'}
            attributeStr = 'StorageClass';            
        case{'STORAGECLASS','SECTIONNAME'}
           if vernum < 14
              attributeStr = 'MemorySection';
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'MemorySection') 
                 attributeStr = 'MemorySection';
              else
                 status=0;
                 return;
              end
           end
        case{'CUSSTORAGECLASS'}
            attributeStr = 'CustomStorageClass';
        case{'UNITS'}
            attributeStr = 'DocUnits';
        case{'SCOPE'}
           if vernum < 14
              attributeStr = 'DataScope';
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'DataScope') 
                 attributeStr = 'DataScope';
              else
                 status=0;
                 return;
              end
           end
        case{'MIN'}
            attributeStr = 'Min';
            %  newValue = num2str(newValue);
        case{'MAX'}
            attributeStr = 'Max';
            %  newValue = num2str(newValue);
        case{'VALUE'}
            attributeStr = 'Value';
            %  newValue = num2str(newValue);
        case{'FILEINCLUDE','HEADERFILE'}           
           if vernum < 14
              attributeStr = 'IncludeFile';
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'HeaderFile') 
                 attributeStr = 'HeaderFile';
              else
                 status=0;
                 return;
              end
           end
       case{'OWNER'}
           if vernum < 14
              attributeStr = 'Owner';
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'Owner') 
                 attributeStr = 'Owner';
              else
                 status=0;
                 return;
              end
           end          
        case{'DEFINITIONFILE'}
           if vernum < 14
              attributeStr = 'DefinitionFile';
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'DefinitionFile') 
                 attributeStr = 'DefinitionFile';
              else
                 status=0;
                 return;
              end
           end
        case{'VISIBILITY'}
            attributeStr = 'Visibility';
        case{'DECLARE'}
            attributeStr ='MptDeclare';
        case{'EXPORTACCESSMETHOD','ALTERNATENAME'}
           if vernum < 14
              attributeStr = 'ExportAccessMethod';
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'AlternateName') 
                 attributeStr = 'AlternateName';
              else
                 status=0;
                 return;
              end
           end
        case{'PERSISTENCELEVEL','TUNELEVEL'}
           if vernum < 14
                if isempty(findstr(dataObjClass,'.Parameter'))==0,
                    attributeStr = 'TuneLevel';
                else
                    attributeStr = 'DisplayLevel';
                end
           else
              cusAttri = get_data_info(name,'RTWATTRIBUTES','');
              attri = cusAttri.get;
              if isfield(attri,'PersistenceLevel') 
                 attributeStr = 'PersistenceLevel';
              else
                 status=0;
                 return;
              end
           end
        otherwise
            %   disp(['This property "',attribute,'" is not supported.']);
            status=0;
            return;
    end

    switch  upper(attribute)
        case{'OWNER','DEFINITIONFILE','FILEINCLUDE','HEADERFILE','STORAGECLASS','SECTIONNAME',...
                'VISIBILITY'}
            if vernum < 14
                if isempty(newValue) == 0
                    if isnumeric(newValue)
                        cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',',num2str(newValue),');'];
                    else
                        cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
                    end
                else
                    cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
                end
            else
                if isempty(newValue) == 0
                    if isnumeric(newValue)
                        cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',',num2str(newValue),');'];
                    else
                        cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',''',newValue,''');'];
                    end
                else
                    cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',''',newValue,''');'];
                end
            end
        case {'EXPORTACCESSMETHOD','ALTERNATENAME','PERSISTENCELEVEL','TUNELEVEL'}
            if isempty(newValue) == 0
                if isnumeric(newValue)
                    cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',',num2str(newValue),');'];
                else
                    cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',''',newValue,''');'];
                end
            else
                cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',''',newValue,''');'];
            end
        case{'DATATYPE'}
            if vernum < 14
                cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
            else
                cmd = [name,'.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
            end
        case{'INITIALVALUE','INITIAL_VALUE'}
            if vernum < 14
                if isempty(newValue) == 0
                    if isnumeric(newValue)
                        cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',',num2str(newValue),');'];
                    else
                        cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
                    end
                else
                    cmd = [name,'.RTWInfo.CustomAttributes.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
                end
            else
                if isempty(newValue) == 0
                    if isnumeric(newValue)
                        cmd = [name,'.RTWInfo.set(''',attributeStr,''',[',num2str(newValue),']);'];
                    else
                        cmd = [name,'.RTWInfo.set(''',attributeStr,''',''',newValue,''');'];
                    end
                else
                    cmd = [name,'.RTWInfo.set(''',attributeStr,''',''',newValue,''');'];
                end
            end
        case 'ALIAS'
            if vernum < 14
                cmd = [name,'.RTWInfo.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
            else
                cmd = [name,'.RTWInfo.set(''',attributeStr,''',''',newValue,''');'];
            end
        case 'BASESTORAGECLASS'
            cmd = [name,'.RTWInfo.set(''',attributeStr,''',''',newValue,''');'];            
        case 'CUSSTORAGECLASS'
            cmd = [name,'.RTWInfo.set(''',attributeStr,''',''',newValue,''');'];                    
        case 'SCOPE'
            %Check version to determine if DataScope shoul be included or not
            if vernum < 14
                cmd = [name,'.setLockedAttributes(''',attributeStr,''',''',newValue,''');'];
            else
                cmd = [name,'.RTWInfo.CustomAttributes.set(''',attributeStr,''',''',newValue,''');'];
            end
        case {'DESCRIPTION', 'UNITS','VALUE','MAX','MIN'}
            if isnumeric(newValue)
                cmd = [name,'.setAttributes(''',attributeStr,''',',num2str(newValue),');'];
            else
                cmd = [name,'.setAttributes(''',attributeStr,''',''',newValue,''');'];
            end
        otherwise
            if vernum < 14
                if isnumeric(newValue)
                    cmd = [name,'.RTWInfo.CustomAttributes.setAttributes(''',attributeStr,''', [',num2str(newValue),']);'];
                else
                    cmd = [name,'.RTWInfo.CustomAttributes.setAttributes(''',attributeStr,''',''',newValue,''');'];
                end
            else
                if isnumeric(newValue)
                    cmd = [name,'.setAttributes(''',attributeStr,''',',num2str(newValue),');'];
                else
                    cmd = [name,'.setAttributes(''',attributeStr,''',''',newValue,''');'];
                end
            end
    end
catch
    status = 0;
end

%
% Execute the command and set the attribute
%

try,
    evalin(caller,cmd);
    status = 1;
catch
    status = 0;
end

return
%EOF

