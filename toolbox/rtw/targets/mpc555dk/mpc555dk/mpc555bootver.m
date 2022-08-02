function version_out = mpc555bootver(direction, version_in)
%   MPC555BOOTVER translates bootcode version to/from product version
%
%   VERSION_OUT=MPC555_BOOTVER(DIRECTION, VERSION_IN) 
%   
%   If DIRECTION == 'prod2boot' then the translation is product version
%   number to bootcode version number.   If DIRECTION == 'boot2prod' then
%   the translation is bootcode version number to product version number.
%
%   DIRECTION, VERSION_IN and VERSION_OUT are all strings.
%

%   Copyright 2002-2003 The MathWorks, Inc.

if (~ischar(direction) | ~ischar(version_in))
    error('Direction and Version arguments must be strings.');
end;

% read data from the text file in this directoty
[curr_version, prod_versions, boot_versions] = readFile;

switch (direction)
    case 'prod2boot'
        % product version supplied
        index = strmatch(version_in, prod_versions, 'exact');
        if (isempty(index))
            error(['Unknown product version: ' version_in]);
        end;
        version_out = boot_versions{index};    
        return;
    case 'boot2prod'
        % bootcode version supplied
        index = strmatch(version_in, boot_versions, 'exact');
        if (isempty(index))
            error(['Unknown bootcode version: ' version_in]);
        end;
        version_out = prod_versions{index};
        return;
    otherwise
        error(['Unknown direction (prod2boot | boot2prod) : ' direction]);
end;

% read data from auto generated mpc555bootver.txt file
function [curr_version, prod_versions, boot_versions] = readFile
    [path, name, ext, versn] = fileparts(mfilename('fullpath'));
    txtfile = fullfile(path, 'mpc555bootver.txt');
    fid = fopen(txtfile);
    prod_versions = {};
    boot_versions = {};
    curr_section = 0;
    while 1
        curr_line = fgetl(fid);
        if ~ischar(curr_line)
            % EOF
            break;
        end;
        if (~isempty(findstr(curr_line, '# Section')))
            % move on to next section
            curr_section = curr_section + 1;
            continue;
        end;
        if (length(curr_line) > 0)
            if (curr_line(1) == '#') 
                % skip comments
                continue;
            end;
            % real line
            switch (curr_section)
                case 1
                    curr_version = curr_line;
                case 2
                    prod_versions{length(prod_versions) + 1} = curr_line;
                case 3
                    boot_versions{length(boot_versions) + 1} = curr_line;
            end;
        end;
    end;
    fclose(fid);
return;