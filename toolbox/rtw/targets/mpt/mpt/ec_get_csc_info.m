function [status, value] = ec_get_csc_info(packageName, cscName, attribute)
%EC_GET_CSC_INFO - Get attribute info for registered csc.
%
%   [STATUS,VALUE] = EC_GET_CSC_INFO(PACKAGENAME,CSCNAME,ATTRIBUTE)
%   This function will return default setting value of inquiring attribute of 
%   inquiring CSC. It also return a status about the inquiring. If inquiring 
%   attribute of inquiring CSC exists, then status = 1; otherwise, status = 0. 
%
% Examples:  
%    [status, value] = ec_get_csc_info('mpt','Global','PersistenceLevel');
%    [status, value] = ec_get_csc_info('mpt','ExportToFile','dataaccess');
%    [status, value] = ec_get_csc_info('Simulink','BitField','StructName');
%
%   INPUTS:
%       packageName: The name of the package which the inquiring CSC belongs to
%       cscName:     The name of the custom storage class
%       attribute:   The inquiring attributes (see below for the list of valid attributes) 
%   OUTPUTS:
%       status:      1 if inquiring attribute of inquiring CSC exists.
%                    0 otherwise

%   Available inquiring attributes (full or short name, case insensitive):
%   'CSCTYPE'
%   'MEMSEC' or 'MEMORYSECTION'
%   'ISMEMSEC' or 'ISMEMORYSECTIONINSTANCESPECIFIC'}
%   'ISGROUPED'
%   'DATAUSAGE'
%   'DATASCOPE'
%   'ISDATASCOPE' or 'ISDATASCOPEINSTANCESPECIFIC'
%   'DATAINIT'
%   'ISDATAINIT' or 'ISDATAINITINSTANCESPECIFIC'
%   'DATAACCESS'
%   'ISDATAACCESS' or 'ISDATAACCESSINSTANCESPECIFIC'
%   'HEADERFILE'
%   'ISHEADERFILE' or 'ISHEADERFILEINSTANCESPECIFIC'
%   'COMMENTSRC' or 'COMMENTSOURCE'
%   'TYPECOMMENT'
%   'DELCOMMENT' or 'DECLARECOMMENT'
%   'DEFCOMMENT' or 'DEFINECOMMENT'
%   'CSCATTRICLASSNAME' or 'CSCTYPEATTRIBUTESCLASSNAME'
%   'CSCATTRICLASS' or 'CSCTYPEATTRIBUTES'
%   'TLCNAME' or 'TLCFILENAME'
%   'OWNER'
%   'ISOWNER' or 'ISOWNERINSTANCESPECIFIC'
%   'DEFFILE' or 'DEFINITIONFILE'
%   'ISDEFFILE' or 'ISDEFINITIONFILEINSTANCESPECIFIC'
%   'ALTERNAME' or 'ALTERNATENAME'
%   'ISALTERNAME' or 'ISALTERNATENAMEINSTANCESPECIFIC'
%   'PERSISTLEVEL' or 'PERSISTENCELEVEL'
%   'ISPERSISTLEVEL' or 'ISPERSISTENCELEVELINSTANCESPECIFIC'
%   'STRUCTNAME'
%   'ISSTRUCTNAME' or 'ISSTRUCTNAMEINSTANCESPECIFIC'
%   'BITPACKBOOLEAN'
%   'ISTYPEDEF'
%   'TYPENAME'
%   'TYPETOKEN'
%   'TYPETAG'
%   'GETFUNCTION'
%   'ISGETFUNCTION' or 'ISGETFUNCTIONSPECIFIC'
%   'SETFUNCTION'
%   'ISSETFUNCTION' or 'ISSETFUNCTIONSPECIFIC'
%   'INCLUDEDELIMITER'
%   'ISINCLUDEDELIM' or 'ISINCLUDEDELIMITERSPECIFIC'

%
%   Linghui Zhang
%   Copyright 1994-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/12/31 19:43:28 $


%%%% Get CSC definition
cscDefns = processcsc('GetCSCDefns', packageName, false);

value = '';
status = 1;   
special = 0;

%Map inquiring attibute to real attibute 
switch upper(attribute)
    case 'CSCTYPE'
         attriStr = 'CSCType';
    case {'MEMSEC','MEMORYSECTION'}
         attriStr = 'MemorySection';
    case {'ISMEMSEC','ISMEMORYSECTIONINSTANCESPECIFIC'}
         attriStr = 'IsMemorySectionInstanceSpecific';
    case 'ISGROUPED'
         attriStr = 'IsGrouped';
    case 'DATAUSAGE'
         attriStr = 'DataUsage';
    case 'DATASCOPE'
         attriStr = 'DataScope';
    case {'ISDATASCOPE','ISDATASCOPEINSTANCESPECIFIC'}
         attriStr = 'IsDataScopeInstanceSpecific';
    case 'DATAINIT'
         attriStr = 'DataInit';
    case {'ISDATAINIT','ISDATAINITINSTANCESPECIFIC'}
         attriStr = 'IsDataInitInstanceSpecific';
    case 'DATAACCESS'
         attriStr = 'DataAccess';
    case {'ISDATAACCESS','ISDATAACCESSINSTANCESPECIFIC'}
         attriStr = 'IsDataAccessInstanceSpecific';
    case 'HEADERFILE'
         attriStr = 'HeaderFile';
    case {'ISHEADERFILE','ISHEADERFILEINSTANCESPECIFIC'}
         attriStr = 'IsHeaderFileInstanceSpecific';
    case {'COMMENTSRC','COMMENTSOURCE'}
         attriStr = 'CommentSource';
    case 'TYPECOMMENT'
         attriStr = 'TypeComment';
    case {'DELCOMMENT','DECLARECOMMENT'}
         attriStr = 'DeclareComment';
    case {'DEFCOMMENT','DEFINECOMMENT'}
         attriStr = 'DefineComment';
    case {'CSCATTRICLASSNAME','CSCTYPEATTRIBUTESCLASSNAME'}
         attriStr = 'CSCTypeAttributesClassName';
    case {'CSCATTRICLASS','CSCTYPEATTRIBUTES'}
         attriStr = 'CSCTypeAttributes';
    case {'TLCNAME','TLCFILENAME'}
         attriStr = 'TLCFileName';
    case 'OWNER'
         attriStr = 'Owner';
         special = 1;
    case {'ISOWNER','ISOWNERINSTANCESPECIFIC'}
         attriStr = 'IsOwnerInstanceSpecific';
         special = 1;
    case {'DEFFILE','DEFINITIONFILE'}
         attriStr = 'DefinitionFile';
         special = 1;
    case {'ISDEFFILE','ISDEFINITIONFILEINSTANCESPECIFIC'}
         attriStr = 'IsDefinitionFileInstanceSpecific';
         special = 1;
    case {'ALTERNAME','ALTERNATENAME'}
         attriStr = 'AlternateName';
         special = 1;
    case {'ISALTERNAME','ISALTERNATENAMEINSTANCESPECIFIC'}
         attriStr = 'IsAlternateNameInstanceSpecific';
         special = 1;
    case {'PERSISTLEVEL','PERSISTENCELEVEL'}
         attriStr = 'PersistenceLevel';
         special = 1;
    case {'ISPERSISTLEVEL','ISPERSISTENCELEVELINSTANCESPECIFIC'}
         attriStr = 'IsPersistenceLevelInstanceSpecific';
         special = 1;
    case 'STRUCTNAME'
         attriStr = 'StructName';
         special = 1;
    case {'ISSTRUCTNAME', 'ISSTRUCTNAMEINSTANCESPECIFIC'}
         attriStr = 'IsStructNameInstanceSpecific';
         special = 1;
    case 'BITPACKBOOLEAN'
         attriStr = 'BitPackBoolean';
         special = 1;
    case 'ISTYPEDEF'
         attriStr = 'IsTypeDef';
         special = 1;
    case 'TYPENAME'
         attriStr = 'TypeName';
         special = 1;
    case 'TYPETOKEN'
         attriStr = 'TypeToken';
         special = 1;
    case 'TYPETAG'
         attriStr = 'TypeTag';
         special = 1;
    case 'GETFUNCTION'
         attriStr = 'GetFunction';
         special = 1;
    case {'ISGETFUNCTION','ISGETFUNCTIONSPECIFIC' }
         attriStr = 'IsGetFunctionSpecific';
         special = 1;
    case 'SETFUNCTION'
         attriStr = 'SetFunction';
         special = 1;
    case {'ISSETFUNCTION','ISSETFUNCTIONSPECIFIC'}
         attriStr = 'IsSetFunctionSpecific';
         special = 1;
    case 'INCLUDEDELIMITER'
         attriStr = 'IncludeDelimiter';
         special = 1;
    case {'ISINCLUDEDELIM','ISINCLUDEDELIMITERSPECIFIC'}
         attriStr = 'IsIncludeDelimiterSpecific';
         special = 1;
    otherwise
        status = 0;
        disp(['** Warning: ''',attribute,''' is an invalid attribute for inquiring. **']);
        return;
end

%Get the value for inquiring attibute
for i = 1 : length(cscDefns)
    if strcmp(cscDefns(i).Name, cscName) 
        csc = cscDefns(i).get;
        if special == 0 
            if isfield(csc,attriStr)   
                value = getfield(csc,attriStr);
                status = 1;
            else
                disp(['** Warning: ''',attriStr,''' is an invalid attribute of ''',cscName,'''. **']);
                status = 0;
            end
        else         
            if ~isempty(cscDefns(i).CSCTypeAttributes)
                cscAttriClass = cscDefns(i).CSCTypeAttributes;
                cscAttri = cscAttriClass.get;
                if isfield(cscAttri,attriStr)   
                   value = getfield(cscAttri,attriStr);
                   status = 1;
                else
                   disp(['** Warning: ''',attriStr,''' is an invalid attribute of ''',cscName,'''. **']);
                   status = 0;
                end            
            else
               disp(['** Warning: ''',attriStr,''' is an invalid attribute of ''',cscName,'''. **']);
               status = 0;
            end
        end;    
        break;
    else
        status = 0;
    end
end

% EOF

