function dataStr = get_data_info(name,attribute,varargin)
%GET_DATA_INFO - Get Data Attributes for named object.
%
%   [DATASTR]=GET_DATA_INFO(NAME,ATTRIBUTE,VARARGIN)
%   This function will return data attributes from the data objects
%   This is a standard insulation function between the core packaging
%   engine and the simulink data objects used for this packaging of the code.
%
%   The format :  attribute = get_data_info('name','attribute');
%   Example:  str = get_data_info('ect','DATATYPE');
%            The above returns the datatype of the ect parameter
%
%   INPUTS:
%            name       : The name of the Simulink Data Object
%            attribute  : The name of the attribute desired
%            varargin{1}: The name of model
%   OUTPUTS:
%
%            dataStr    : value of desired attribute.
%
%   Available Attributes:
%   DATATYPE      - Object DataType
%   DESCRIPTION   - Description or LongID of an object
%   PERSISTENCELEVEL/TUNELEVEL - TuneLevel or DisplayLevel
%   DEFINITIONFILE   - Definition File Name
%   EXPORTACCESSMETHOD/ALTERNATENAME - Export access method
%   FILEINCLUDE/HEADERFILE - Include File Name or Header file
%   INITIAL_VALUE - Initialization value of the object
%   RTWATTRIBUTES - RTW Attributes
%   ALIAS         - Another reference name
%   NAMINGRULEOVERRIDE - Alias overrides naming rule or not 
%   OWNER         - Owner of the data object
%   BASESTORAGECLASS - Storage Class of data object
%   STORAGECLASS  - MemorySection of data object
%   CUSSTORAGECLASS - Custom Storage Class of data object
%   UNITS         - Units of an Object
%   MIN           - Minimum Allowed Value
%   MAX           - Maximum Allowed Value
%   VALUE         - Value of a Paremeter object type
%   ALL           - Returns all of the attributes of the object
%   CSCOWNER          - CSC deafult value for Owner
%   CSCDEFINITIONFILE - CSC deafult value for DefinitionFile
%   CSCALTERNATENAME  - CSC deafult value for AlternateName
%   CSCPERSISTENCELEVEL - CSC deafult value for PersistenceLevel
%  The last four for R14 and R14+  only
%
%  Note: R13 does not support the modelworkspace.

%   Patrick W. Menter
%   Linghui Zhang
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.31.4.14 $  $Date: 2004/04/15 00:26:59 $

try
    
% Check to see if the object is present in the workspace
name = strrep(name,' ','');
ver = version('-release');
vernum = str2num(ver);
stat = [];
dataStr = [];
obj = [];
if vernum < 14
    %base workspace only before R14
    stat = evalin('base',['whos(''',name,''')']);
    caller = 'base';
    modelName = '';
    if isempty(stat)
        dataStr =[];
     %   disp(['** Warning: Data object "',name,'" does not exist in the base workspace. **']);
        return;
    end
else
 % for R14 and R14+ 
 if nargin >= 3 && ~isempty(varargin{1})
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
             dataStr = [];
             return;             
         else
             % model workspace parameter
             if isequal(upper(attribute),'VALUE')
                 if isa(obj,'Simulink.Parameter')
                     dataStr = obj.Value;
                 else
                     dataStr = obj;
                 end
             else
                 dataStr = [];
             end
             return;
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
    dataStr =[];
    %  disp(['** Warning: Data object "',name,'" does not exist in the base workspace. **']);
    return;
end

dataObjClass = stat.class;

objbase = evalin(caller,name);
if ~isa(objbase,'Simulink.Signal') & ~isa(objbase,'Simulink.Parameter')
    dataStr = [];
    return;
end
    
% Use the switch to determine the attribute desired
%
spaceRemoveFlag = 0;
switch upper(attribute),
    case{'DATATYPE'}
        if vernum < 14
          attributeStr ='.RTWInfo.CustomAttributes.UserDataType';
        else
          obj = evalin(caller,name);
          if isa(obj,'mpt.Signal') | isa(obj,'mpt.Parameter')
             attributeStr ='.DataType'; 
          else
             attributeStr ='.DataType';  
             cmd = [name,attributeStr];
             dataStr = evalin(caller,cmd);
             return
          end
        end
    case{'DESCRIPTION'}
        attributeStr = '.Description';
    case{'INITIAL_VALUE','INITIALVALUE'}
         if isa(objbase,'Simulink.Parameter')
            attributeStr = '.Value';
         elseif  isa(objbase,'mpt.Signal')
            if vernum < 14
               attributeStr = '.RTWInfo.CustomAttributes.InitialValue';
            else
               attributeStr = '.RTWInfo.InitialValue';
            end
         else
            dataStr = [];
            return;
         end
    case{'ALIAS'}
        attributeStr = '.RTWInfo.Alias';
    case{'NAMINGRULEOVERRIDE'}
        attributeStr = '.RTWInfo.NamingRuleOverride';      
    case{'BASESTORAGECLASS'}  
        attributeStr = '.RTWInfo.StorageClass';        
    case{'STORAGECLASS','SECTIONNAME'}
        if vernum < 14
           attributeStr = '.MemorySection';
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'MemorySection') 
              attributeStr = '.RTWInfo.CustomAttributes.MemorySection';
           else
              return;
           end
        end
    case{'CUSSTORAGECLASS'}
        attributeStr = '.RTWInfo.CustomStorageClass';
    case{'UNITS'}
        attributeStr = '.DocUnits';
    case{'SCOPE'}
        if vernum < 14
           attributeStr = '.DataScope';
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'DataScope') 
              attributeStr = '.RTWInfo.CustomAttributes.DataScope';
           else
              return;
           end
        end
    case{'MIN'}
        ver = version('-release');
        vernum = str2num(ver);
        if vernum < 14
            attributeStr = '.MinValue';
        else
            attributeStr = '.Min';
        end
    case{'MAX'}
        ver = version('-release');
        vernum = str2num(ver);
        if vernum < 14
            attributeStr = '.MaxValue';
        else
            attributeStr = '.Max';
        end
    case{'VALUE'}
        attributeStr = '.Value';
    case{'PERSISTENCELEVEL','TUNELEVEL'}
        if vernum < 14
           if isa(objbase,'Simulink.Parameter')
              attributeStr = '.RTWInfo.CustomAttributes.TuneLevel';
           else
              attributeStr = '.RTWInfo.CustomAttributes.DisplayLevel';
           end
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'PersistenceLevel') 
               attributeStr = '.RTWInfo.CustomAttributes.PersistenceLevel';
           else
               return;
           end
        end
    case{'FILEINCLUDE','HEADERFILE'}
        if vernum < 14
           attributeStr = '.RTWInfo.CustomAttributes.IncludeFile';
           spaceRemoveFlag=1;
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'HeaderFile') 
                attributeStr = '.RTWInfo.CustomAttributes.HeaderFile';
           else
               return;
           end
        end
    case{'DEFINITIONFILE'}
        if vernum < 14
           attributeStr = '.RTWInfo.CustomAttributes.getAttributes(''DefinitionFile'')';
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'DefinitionFile') 
                attributeStr = '.RTWInfo.CustomAttributes.DefinitionFile';
           else
               return;
           end
        end        
    case{'EXPORTACCESSMETHOD','ALTERNATENAME'}
        if vernum < 14
           attributeStr = '.RTWInfo.CustomAttributes.ExportAccessMethod';
           spaceRemoveFlag=1;
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'AlternateName') 
                attributeStr = '.RTWInfo.CustomAttributes.AlternateName';
           else
               return;
           end
        end
    case{'OWNER'}
        if vernum < 14
           attributeStr = '.RTWInfo.CustomAttributes.Owner';
        else
           cusAttri = get_data_info(name,'RTWATTRIBUTES','');
           attri = cusAttri.get;
           if isfield(attri,'Owner') 
                attributeStr = '.RTWInfo.CustomAttributes.Owner';
           else
               return;
           end
        end
    case{'DIMENSION'}
        attributeStr = '.Dimension';
    case{'VISIBILITY'}
        attributeStr = '.Visibility';
    case{'RTWATTRIBUTES'}
        attributeStr ='.RTWInfo.CustomAttributes';
    case{'ALL'}
        attributeStr = '';
    case {'OBJECTTYPE'}
        if vernum < 14
           attributeStr = '.RTWInfo.CustomAttributes.UserObjectType';
        else
           attributeStr = '.UserObjectType';
        end
    case{'RESOLUTION'}
        attributeStr = '.MptResolution';   
    case {'CSCOWNER','CSCDEFINITIONFILE','CSCALTERNATENAME','CSCPERSISTENCELEVEL'}
        % R14 and R14+ only
        cscDefns = processcsc('GetCSCDefns','mpt',false);
        csc = get_data_info(name,'CUSSTORAGECLASS','');
        for i = 1:length(cscDefns)
           cscName = get(cscDefns(i),'Name');
           if strcmp(cscName, csc)
               CSCTypeAttr = get(cscDefns(i),'CSCTypeAttributes');
               switch upper(attribute)
                   case {'CSCOWNER'}
                      dataStr = get(CSCTypeAttr,'Owner');
                   case {'CSCDEFINITIONFILE'}
                      dataStr = get(CSCTypeAttr,'DefinitionFile');
                   case {'CSCALTERNATENAME'}
                      dataStr = get(CSCTypeAttr,'AlternateName');
                   case {'CSCPERSISTENCELEVEL'}
                      dataStr = get(CSCTypeAttr,'PersistenceLevel');
                   otherwise
               end
               return
           end
        end
        return
    otherwise;
        disp(['** Warning: ''',attribute,''' is not a valid attribute for object ''',name,'''. **']);
        return
end

%
%  Use the Try-Catch mechanism to protect against the case of a non existant
%  object and to protect against the case of a missing attribute
%

% Build up the command to execute

cmd = [name,attributeStr];

 if isa(objbase,'Simulink.Signal') | isa(objbase,'Simulink.Parameter')
    try,
        if strcmp(upper(attribute),'INITIAL_VALUE')|strcmp(upper(attribute),'INITIALVALUE')
            dataStr = double(evalin(caller,cmd));
            dataStr = num2str(dataStr);
        elseif strcmp(upper(attribute),'ISFIXPT'),
            dataStr = evalin(caller,cmd);
        elseif strcmp(upper(attribute),'DIMENSION'),
            dataStr= evalin(caller,cmd);
            dataStrTemp = str2num(strrep(dataStr,'][',' '));
            dataStr = dataStrTemp;
        elseif strcmp(upper(attribute),'VALUE'),
            try
                dataStr = double(evalin(caller,cmd));
                dataStr = num2str(dataStr,15);
            catch
                dataStr= evalin(caller,cmd);
                if isstruct(dataStr)== 0
                    dataStr= double(dataStr);
                end
            end
        elseif strcmp(upper(attribute),'STORAGECLASS')| strcmp(upper(attribute),'SECTIONNAME')
            dataStrTmp = strrep(evalin(caller,cmd),' ','');
            switch dataStrTmp
                case{'IPC'}      % Parameter Case
                    dataStr ='ROM';
                case{'KAM'}      % Signal Case
                    dataStr ='RAM';
                otherwise
                    dataStr = dataStrTmp;
            end
        elseif strcmp(upper(attribute),'ALIAS'),
            dataStr = evalin(caller,cmd);
            if isempty(deblank(dataStr)),
                dataStr = name;
            end
        elseif strcmp(upper(attribute),'DATATYPE'),
            dataStr =  strrep(evalin(caller,cmd),' ','');
            DTInfo = get_user_objecttype_info(dataStr); % get user-defined objecttype info
            if isempty(DTInfo) == 0
                strMatch = ac_get_type(dataStr, 'userName', 'userName', 'all');
                if isempty(strMatch) == 1
                    dataStr = DTInfo.realdatatype;
                elseif iscell(strMatch) == 1
                    dataStr = strMatch{1};
                end
            end
        else
            dataStr = evalin(caller,cmd);
            if strcmp(upper(attribute),'DEFINITIONFILE') 
               dataStr = strrep(dataStr,'"','');
               dataStr = strrep(dataStr,'<','');
               dataStr = strrep(dataStr,'>','');
            end
        end
    catch
        dataStr = [];
        disp(['** Warning: unable to get the value of attribute ''',attribute,'''. **']);
    end
    if spaceRemoveFlag == 1
        if isempty(dataStr) == 0
            dataStr = strrep(dataStr,' ','');
        end
    end
 else
   % disp(['** Warning: "',name,'" is not a Parameter or Singal data object. **']);
    dataStr = [];
 end
catch
   dataStr = []; 
   disp(['** Warning: unable to get the value of attribute ''',attribute,'''. **']);
end

return
% EOF


