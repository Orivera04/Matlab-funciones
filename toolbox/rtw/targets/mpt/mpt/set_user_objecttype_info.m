function set_user_objecttype_info(userObjectType);
%SET_USER_OBJECTTYPE_INFO  Save the details about a user-defined object type
%
%    SET_USER_OBJECTTYPE_INFO(USEROBJECTTYPE)
%    This function will register details about a user-defined object type.
%    If the userObjectType already exists, it will be replaced. If it is new,
%    it is added to the userDTInfo list.
%    INPUT:
%              userObjectType: User-defined object type to register
%    OUTPUT:
%              None

%   Linghui Zhang
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/15 00:29:09 $
%

if isempty(userObjectType) == 1
    return;
else
    try
        userDTInfo = rtwprivate('rtwattic', 'AtticData', 'userDTInfo');
        cr = sprintf('\n');
        DTInfo.name = fliplr(deblank(fliplr(deblank(userObjectType.Name))));
        DTInfo.type = fliplr(deblank(fliplr(deblank(userObjectType.Type))));
        DTInfo.realdatatype = fliplr(deblank(fliplr(deblank(userObjectType.DataType))));
        
        % Make sure user registered DataTypes exist before using them
        custom_user_type_registration;

        dtype = ac_get_type(DTInfo.realdatatype, 'userName', 'tmwName','all');
        if isempty(dtype) == 0
            % User registered DataType mapped to TMW type
            if iscell(dtype)
                DataType = dtype{1};
            else
                DataType = dtype;
            end
        else
            % not user registered DataType (may be TMW type or may not)
            tmwDT = {'int32','uint32','int16','uint16','int8','uint8',...
                'double','single','boolean',...
                'int32_T','uint32_T','int16_T','uint16_T','int8_T',...
                'uint8_T','real64_T','real32_T','real_T'};
            comm = intersect(DTInfo.realdatatype,tmwDT);
            if isempty(comm) == 0
                DataType = DTInfo.realdatatype;
            else
                msg = {['''',DTInfo.name,''' is using undefined DataType ''', DTInfo.realdatatype,...
                    '''.'],['Your Object Type ''',DTInfo.name,''' will not be registered.'],...
                    'To fix it, use either one of registered user DataType or register it.'};
                errordlg(msg, 'Data Error');
                return
            end
        end
        DataType = tmw_to_baseguiname(DataType);

        DTInfo.units = '';
        DTInfo.description = '';
        DTInfo.definitionfile = '';
        DTInfo.includefile = '';
        DTInfo.level = 1;
        DTInfo.owner = '';
        DTInfo.initialvalue = 0;
        try
          DTInfo.value = eval([DataType,'(0)']);
          DTInfo.minValue = eval([DataType,'(-Inf)']);
          DTInfo.maxValue = eval([DataType,'(Inf)']);       
        catch
          DTInfo.value = 0;
          DTInfo.minValue = -Inf;
          DTInfo.maxValue = Inf;       
        end
        DTInfo.csc = 'Global';
        fields = fieldnames(userObjectType);
        for i = 1:length(fields)
            switch lower(fields{i})
                case 'units'
                    DTInfo.units = getfield(userObjectType,fields{i});
                case 'definitionfile'
                    DTInfo.definitionfile = getfield(userObjectType,fields{i});
                case 'description'
                    DTInfo.description = getfield(userObjectType,fields{i});
                case 'includefile'
                    DTInfo.includefile = getfield(userObjectType,fields{i});
                case 'level'
                    DTInfo.level = getfield(userObjectType,fields{i});
                case 'owner'
                    DTInfo.owner = getfield(userObjectType,fields{i});
                case 'customstorageclass'
                    DTInfo.csc = getfield(userObjectType,fields{i});                    
                case {'initialvalue'}
                    DTInfo.initialvalue = getfield(userObjectType,fields{i});
                case {'value'}
                    value = getfield(userObjectType,fields{i});
                    try
                        if strcmp(class(value),DataType) == 0
                            DTInfo.value = eval([DataType,'(value)']);
                        end
                    catch
                        value = 0;
                    end
                case 'min'
                    try
                        value = getfield(userObjectType,fields{i});
                        if strcmp(class(value),DataType) == 0
                            DTInfo.minValue = eval([DataType,'(value)']);
                        end
                    catch
                        value = -Inf;
                    end
                case 'max'
                    try
                        value = getfield(userObjectType,fields{i});
                        if strcmp(class(value),DataType) == 0
                            DTInfo.maxValue = eval([DataType,'(value)']);
                        end
                    catch
                        value = Inf;
                    end
                otherwise
            end
        end
    catch
        disp(['*** Warning: Fail to register the object type ''',DTInfo.name,...
            ''' due to: ',lasterr]);
        rtwprivate('rtwattic', 'AtticData', 'userDTInfo', userDTInfo);
        return
    end

    % Check all pre-registered user-defined special data type for a match.
    % If found, then replace.
    % Otherwise, insert into end of list.

    for i=1:length(userDTInfo)
        if strcmp(lower(userDTInfo{i}.name), lower(DTInfo.name)) == 1
            % requested registing objectType found, replace in list.
            userDTInfo{i} = DTInfo;
            rtwprivate('rtwattic', 'AtticData', 'userDTInfo', userDTInfo);
%             disp([' ** Warning: The Object Type (case insensitive) ''',DTInfo.name,...
%                 ''' already exists. It replaces the existing one.']);
            return;
        end
    end

    % Insert UserDataType into end of list.
    userDTInfo{end+1} = DTInfo;
    rtwprivate('rtwattic', 'AtticData', 'userDTInfo', userDTInfo);
end
return

