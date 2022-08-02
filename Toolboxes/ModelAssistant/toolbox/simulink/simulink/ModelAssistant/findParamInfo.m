function [prompt, inputBox] = findParamInfo(Parameter, htmlFieldName, onChangeMethod, objects)
% looking for parameter info from paramater name and object list
%  prompt is the prompt of parameter if it exists
%  inputBox could be either menu box or input text box

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

prompt = 'No associated dialog prompt'; % empty by default
inputBox = ['<input type="text" name="' htmlFieldName '" onChange="' onChangeMethod '" size="20">']; % input text box by default 
for i=1:length(objects)
    if overtimeCtl('check')
        error('Operation was cancelled by user.');  % user choose to stop
    end
    fp = get_param(objects(i), 'ObjectParameters');
    if ismember(Parameter, fieldnames(fp)) && strcmpi(get_param(objects(i), 'Type'), 'port')   
        prompt = '';   % skip filter for parameters for ports 
        return
    end

    if isfield(fp, 'DialogParameters')
        dp = get_param(objects(i), 'DialogParameters');
        try
            if ~isempty(dp)
                dialogParams = fieldnames(dp);
                if ismember(Parameter, dialogParams)
                    tp = getfield(dp, Parameter);
                    if (isfield(tp, 'Prompt'))
                        if ~isempty(tp.Prompt)
                            prompt = tp.Prompt;  % if it's defined field but empty value, still consider defined
                        end
                    end
                    if (isfield(tp, 'Type'))
                        switch lower(tp.Type)
                            case 'enum'
                                if length(tp.Enum) > 1
                                    inputBox = ['<select name="' htmlFieldName '" onChange="' onChangeMethod '">'];
                                    for j=1:length(tp.Enum)
                                        currentEnum = tp.Enum(j);
                                        inputBox = [inputBox '<option>' currentEnum{:} '</option>'];
                                    end
                                    inputBox = [inputBox '</select>'];
                                else
                                end
                                return
                            case 'boolean'
                                inputBox = ['<select name="' htmlFieldName '" onChange="' onChangeMethod '">'];
                                inputBox = [inputBox '<option>on</option>'];
                                inputBox = [inputBox '<option>off</option>'];
                                inputBox = [inputBox '</select>'];                                
                            otherwise % keep default settings
                        end % switch
                    end % if isfield(tp,'Type')
                    return % return immediately when found first Parameter
                end % if ismember(Parameter, dialogParams)
            end % if ~isempty(dp)
        catch
            %just ignore it;
        end
    end
end
