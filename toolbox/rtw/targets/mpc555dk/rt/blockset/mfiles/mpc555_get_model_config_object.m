function obj = mpc555_get_model_config_object(block)
%MPC555_GET_MODEL_CONFIG_OBJECT
%   Returns the MPC555 Configuration object from the model.
%   The function throws an error if the block which holds it
%   cannot be found. The function return [] if the calling
%   block is in a library block diagram instead of a model
%
% Parameters
%
%   block   -   The block which is requesting a config object
%
% Returns
%
%   obj  -  Configuration Object 
%           If the object is empty [] then the block
%           is in a library. This is not an error and
%           should be handled gracefully by the caller. 
%

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/19 01:29:56 $

    t = java.util.StringTokenizer(block,'/');
    if (t.hasMoreElements)
        root = t.nextElement;
    else
        error(['Could not find the root of "' num2str(block) ...
            '" confirm that the value is a string block path.']);
    end
    root = char(root);

    if strcmp(get_param(root,'BlockDiagramType'), 'library' )
        obj = [];
        return; % With no error
    end

    config_block = find_system(root,'tag','MPC555 Configuration');

    if isempty(config_block)
        error([ 'You must place an MPC555 configuration block ' ...
            'in this model ' ]);
    end


    obj = get_param(config_block{1},'UserData');
    

