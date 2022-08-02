function num = mpc555_module_available(variant, module)
% MPC555_MODULE_AVAILABLE  Determine available i/o modules on a particular
% variant.
%
% Returns number of available I/O modules for "variant" matching
% the "module" name provided.
% 
% NOTE: part names, such as "toucan" can be 
% provided to match all of "toucan_a", "toucan_b",
% "toucan_c", returning num = 3

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $
% $Date: 2004/04/19 01:29:57 $

switch (variant)
    case '555'
        info = i_get555Info;
    case { '561' '562' '563' '564' }
        % 561, 562, 563, 564 are same configuration
        info = i_get561Info;
    case {'565' '566'}
        % 565, 566 are same configuration
        info = i_get565Info;
    otherwise
        error('Unrecognised variant!');
end;
num = i_getNumModules(info, module);

% Returns number of modules in info matching
% the name provided.
% 
% NOTE: part names, such as "toucan" can be 
% provided to match all of "toucan_a", "toucan_b",
% "toucan_c", returning num = 3
function num = i_getNumModules(info, name)
    % count number of matches in info
    num = 0;
    for i=1:length(info)
        num = num + strncmpi(info(i), name, length(name));
    end;

% 555 info
function info = i_get555Info
    info = { 'tpu_a'
             'tpu_b'
             'qadc_a'
             'qadc_b'
             'qsmcm'
             'mios1'
             'toucan_a'
             'toucan_b'
             };
    
% 561, 562, 563, 564 info
function info = i_get561Info
    info = { 'tpu_a'
             'tpu_b'
             'qadc64_a'
             'qadc64_b'
             'qsmcm'
             'mios14'
             'toucan_a'
             'toucan_b'
             'toucan_c'
             };
    
% 565, 566 info
function info = i_get565Info
    info = { 'tpu_a'
             'tpu_b'
             'tpu_c'
             'qadc64_a'
             'qadc64_b'
             'qsmcm_a'
             'qsmcm_b'
             'mios14'
             'toucan_a'
             'toucan_b'
             'toucan_c'
             };
