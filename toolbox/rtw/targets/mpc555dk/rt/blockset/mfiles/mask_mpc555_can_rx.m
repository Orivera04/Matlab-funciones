function varargout = mask_mpc555_can_rx(action,block,varargin)
%MASK_MPC555_CAN_RX
%   Mask processing function for the TOUCAN RX block
%
% Usage 1 - The initfcn of the mask
%
% 	Parameters 
% 		
% 		action 		            -		'initfcn'
% 		block			        -		The block to process
%
%   Returns
%   
%   		{}
%
% Usage 2 - Initializing the library block
%
% 	Parameters
%
% 		action		-	'init'
% 		block		-	The block to process
%
%	Returns
%		
%			{}
%
% Usage 3 - Mask parameter callback
%
% 	Parameters
%
% 		action		-	'auto_select_buffer'
% 		block		-	The block to process
%
%  Returns
%
%  		{}
%

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.12.4.1 $
%   $Date: 2004/04/19 01:29:43 $

    tkn = java.util.StringTokenizer(block,'/');
    top_level_system = char(tkn.nextElement);

    switch action
    case 'dispstr'
        varargout = { sprintf('%s\nAuto buffer  = %s\nTOUCAN buffer = %d\n%s\nID = %d', ...
            get_param(gcb,'module'), ...
            get_param(gcb,'auto_select_buffer'), ...
            slresolve('bufferids',block), ...
            get_param(gcb,'message_type'), ...
            slresolve('ids',block)) } ;
        

    case 'get_resource_fcn'
        % -- Return the function handle to the resource allocator
        varargout = { @i_resource_allocator };

    case 'init'
        % -- Initialize the callbacks for the library block ---
        simUtil_maskParam('callback',block,'auto_select_buffer' , ...
            'mask_mpc555_can_rx(''auto_select_buffer'',gcb)');
        %

    case 'auto_select_buffer'
        % -- auto_select_buffer callback ---
        asb = get_param(block,'auto_select_buffer');
        switch asb
        case 'on'
            simUtil_maskParam('disable',block,'bufferids');
        case 'off'
            simUtil_maskParam('enable',block,'bufferids');
        end

    otherwise
        error([' Invalid action ' action]);
    end

function i_resource_allocator(block, target, varargin )
    % -- Resource allocation function ---

    % Retrieve and check the ReferenceBlock Parameter
    module = get_param(block,'module'); % A | B

    % Find a resources object
    resource = target.findResourceForClass('MPC555dkConfig.TOUCAN');
    if isempty(resource)
        error('Could not find configuration for MPC555dkConfig.TOUCAN');
    end

    asb = get_param(block,'auto_select_buffer');

    switch module
    case 'A'
        buffer_resource = resource.CAN_A_BUFFERS;
    case 'B'
        buffer_resource = resource.CAN_B_BUFFERS;
    end

    switch asb
    case 'on'
        % -- Automatic Allocation of the buffer ---

        buffer_str_alloc = buffer_resource.auto_allocate(block, { @i_buffer_callback module });

        if ~isempty(buffer_str_alloc)
            set_param(block,'bufferids',buffer_str_alloc);
            % disp(['auto allocated ' buffer_str_alloc ' on ' module ' to ' block ]);
        else
            error([ 'Failed to allocate a buffer to CAN_RX block ' block ...
                '. This will be because you have added too many CAN blocks to the ' ...
                'model. There are only 16 buffers available' ]);
            %
        end

    case 'off'
        % -- Manual Allocation of the buffer ---

        buffer = slresolve('bufferids',gcb);
        buffer_str = num2str(fix(buffer));

        buffer_str_alloc = buffer_resource.manual_allocate(block, buffer_str );

        if isempty(buffer_str_alloc)
            host = buffer_resource.get_host(buffer_str);
            if ischar(host)
                hilite_system(host,'error');
                error([ 'Failed to allocate ' module ' buffer ' buffer_str ' to  CAN RX block ' block ...
                    ' . This buffer is currently allocated manually to ' host '. Please choose another ' ...
                    ' buffer. ']);
                %
            else
                error([ 'Failed to allocate ' module ' buffer ' buffer_str ' to  CAN RX block ' block ...
                    ' . This buffer is currently allocated to the CAN transmit driver. Please choose ' ...
                    ' another buffer. ']);
            end
            open_system(block);
        else
            % disp(['manually allocated ' buffer_str_alloc ' on CAN_A to ' block ]);
        end

    end

function i_buffer_callback(host, resource, value, module )
    % -- Auto resource callback ---
    % disp(['re-allocated ' value ' on CAN_A to ' host ]);
    set_param(host,'bufferids',value);



