function result = ec_get_placement_rules(name)
%EC_GET_PLACEMENT_RULES will determine proper rules for give storage class.
%

%NOTE: this will change to use CSC attributes in the near future.

%temp basic CSC rules
% Name             Definition .c Reference .h Other
% Scalar               X              X
% BitField          Dont Touch    Dont Touch  Structured
% Const                X              X
% Volatile             X              X
% ConstVolatile        X              X
% Define                                       .c if local, .h if header
% ExportToFile         X              X
% Struct            Dont Touch    Dont Touch   Structured
% GetSet            Dont Touch    Dont Touch
% ImportFromFile                               Include File

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/15 00:26:45 $

result=[];
result.definitionEnable = 0;  %is a definition required
result.referenceEnable = 0;   %is a reference required
result.poundDefine = 0;       %is it a #define (special rules)
result.placementEnable = 0;   %is placement required at all
result.HeaderFile ='';
result.exportCat = 'None';
result.importCat = 'None';
result.mode = 'None';         %Modes:
try
    % None: Do nothing
    % Data: Normal data with definition/reference
    % #Define: special case for #define
    % Include: Import header only for reference
    %  obj = get_data_info(name,'Obj');
    %  className = class(obj);
    %  package = strtok(className,'.');
    %  if isempty(package) == 0
    %  cscDefns = processcsc('GetCSCDefns',package,false);
    storageClass = get_data_info(name,'BASESTORAGECLASS');
    if isempty(storageClass) == 0
        switch (storageClass)
            case 'Custom'
                cscdef = ec_get_cscdef(name);
                if isempty(cscdef) == 0
                    %             if strcmp(cscdef.CSCType,'Other') == 0
                    customStorageClass = get_data_info(name,'CUSSTORAGECLASS');
                    if isempty(customStorageClass) == 0
                        switch (customStorageClass)
                            case 'GetSet'
                                result.mode = 'None';
                                result.importCat = 'None';
                                result.HeaderFile = '';
                            otherwise
                                if cscdef.IsGrouped == 0
                                    if cscdef.IsDataScopeInstanceSpecific == 0
                                        dataScope = cscdef.DataScope;
                                    else
                                        dataScope = get_data_info(name,'Scope')

                                    end
                                    switch(dataScope)
                                        case 'Imported'
                                            result.mode = 'Include';
                                            if cscdef.IsHeaderFileInstanceSpecific
                                                result.importCat = 'Instance';
                                                result.HeaderFile = '';
                                            elseif (isempty(cscdef.HeaderFile) == 0)
                                                result.importCat = 'csc';
                                                result.HeaderFile = cscdef.HeaderFile;
                                            end
                                        case 'Exported'
                                            if cscdef.IsHeaderFileInstanceSpecific
                                                result.exportCat = 'Instance';
                                                result.HeaderFile = '';
                                            elseif (isempty(cscdef.HeaderFile) == 0)
                                                result.exportCat = 'csc';
                                                result.HeaderFile = cscdef.HeaderFile;
                                            end
                                            %else case is handled as default init
                                            if strcmp(cscdef.DataInit,'Macro') == 0
                                                result.mode = 'Data';
                                            else
                                                % #DEFINE Case
                                                result.mode = '#Define';
                                            end
                                        otherwise
                                            result.mode='None';
                                    end

                                else
                                    result.mode = 'None';
                                end
                        end
                    end

                    %             else
                    %                 %Other case. This is not structured or unstructured data.
                    %                 %This is a special case. One known special case is getset.
                    %                        result.mode = 'None';
                    %             end
                end
            case 'ExportedGlobal'
                result.mode = 'Data';
                %             result.mode = 'None';
                result.importCat = 'None';
                result.HeaderFile = '';
            case 'Auto'
                result.mode = 'None';
                result.importCat = 'None';
                result.HeaderFile = '';
            case {'ImportedExtern','ImportedExternPointer'}
                %             result.mode = 'None';
                %             cscdef = ec_get_cscdef(name);
                result.mode = 'Include';
                %             if cscdef.IsHeaderFileInstanceSpecific
                result.importCat = 'None';
                result.HeaderFile = '';
                %             elseif (isempty(cscdef.HeaderFile) == 0)
                %                 result.importCat = 'Extern';
                %                 result.HeaderFile = cscdef.HeaderFile;
                %             end
            otherwise
                result.mode = 'None';
        end
        %     customStorageClass = get_data_info(name,'CUSSTORAGECLASS');
        %     if isempty(customStorageClass) == 0
        %         switch (customStorageClass)
        %             case 'GetSet'
        %                 result.mode = 'None';
        %             otherwise
        %         end
        %     end
    end
catch
end
