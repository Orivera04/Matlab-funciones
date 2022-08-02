function update_model_dict(forceDoubles)
%UPDATE_MODEL_DICT Update the Model Dicitionary
%
%   UPDATE_MODEL_DICT(FORCEDOUBLES)
%         Update the Model Dicitionary
%
%   INPUT:
%         forceDoubles: flag for forcing doubles

%   Steve Toeppe
%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.12.4.2 $
%   $Date: 2004/04/15 00:29:12 $

global ecac;

for i=1:length(ecac.file)
    fileName = ecac.file{i}.name;
    objects = get_data_objects('ChartInfo',  fileName);
    obj = objects{1};
    for j=1:length(obj.input)
        done = 0;
        type = dd_get(obj.input{j}.name,'TYPE');
        if isempty(type) == 0
            g=ac_get_type(type, 'userName', 'tmwName', 'all');
            if isempty(g) == 0
                sf('set',obj.input{j}.dataH,'.dataType',g{2});
                done = 1;
            end
        end
        if (done == 0) & (forceDoubles == 1)
            ty = sf('get',obj.input{j}.dataH,'.dataType');
            if strcmpi(ty,'double') == 1
                sf('set',obj.input{j}.dataH,'.dataType','single');
            end
        end
    end

    for j=1:length(obj.output)
        done = 0;
        type = dd_get(obj.output{j}.name,'TYPE');
        if isempty(type) == 0
            g=ac_get_type(type, 'userName', 'tmwName', 'all');
            if isempty(g) == 0
                sf('set',obj.output{j}.dataH,'.dataType',g{2});
                done = 1;
            end
        end
        if (done == 0) & (forceDoubles == 1)
            ty = sf('get',obj.output{j}.dataH,'.dataType');
            if strcmpi(ty,'double') == 1
                sf('set',obj.output{j}.dataH,'.dataType','single');
            end
        end
    end


    for j=1:length(obj.constant)
        done = 0;
        type = dd_get(obj.constant{j}.name,'TYPE');
        if isempty(type) == 0
            g=ac_get_type(type, 'userName', 'tmwName', 'all');
            if isempty(g) == 0
                sf('set',obj.constant{j}.dataH,'.dataType',g{2});
                done = 1;
            end
        end
        if (done == 0) & (forceDoubles == 1)
            ty = sf('get',obj.constant{j}.dataH,'.dataType');
            if strcmpi(ty,'double') == 1
                sf('set',obj.constant{j}.dataH,'.dataType','single');
            end
        end
    end
    for j=1:length(obj.temporary)
        done = 0;
        type = dd_get(obj.temporary{j}.name,'TYPE');
        if isempty(type) == 0
            g=ac_get_type(type, 'userName', 'tmwName', 'all');
            if isempty(g) == 0
                sf('set',obj.temporary{j}.dataH,'.dataType',g{2});
                done = 1;
            end
        end
        if (done == 0) & (forceDoubles == 1)
            ty = sf('get',obj.temporary{j}.dataH,'.dataType');
            if strcmpi(ty,'double') == 1
                sf('set',obj.temporary{j}.dataH,'.dataType','single');
            end
        end
    end
    for j=1:length(obj.local)
        done = 0;
        type = dd_get(obj.local{j}.name,'TYPE');
        if isempty(type) == 0
            g=ac_get_type(type, 'userName', 'tmwName', 'all');
            if isempty(g) == 0
                sf('set',obj.local{j}.dataH,'.dataType',g{2});
                done = 1;
            end
        end
        if (done == 0) & (forceDoubles == 1)
            ty = sf('get',obj.local{j}.dataH,'.dataType');
            if strcmpi(ty,'double') == 1
                sf('set',obj.local{j}.dataH,'.dataType','single');
            end
        end
    end

end
