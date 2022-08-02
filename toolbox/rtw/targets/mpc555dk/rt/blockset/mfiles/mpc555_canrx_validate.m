function argout = mpc555_canrx_validate(block, target, bufferid )
% MPC555_CANRX_VALIDATE - Resource allocater for the MPC555 CAN RX block
%
%   [ argout_cell_array ] = mpc555_canrx_validate(block, target, bufferid )
%   and returns ...
%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.5.4.3 $
%   $Date: 2004/04/19 01:29:53 $

    % -- Resource allocation function ---

    % Retrieve and check the ReferenceBlock Parameter
    module = get_param(block,'module'); % A | B | C

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
    case 'C'
        buffer_resource = resource.CAN_C_BUFFERS;
    end

    switch asb
    case 'on'
        % -- Automatic Allocation of the bufferid ---

        buffer_str_alloc = buffer_resource.auto_allocate(block, { @i_buffer_callback  });
      
        if ~isempty(buffer_str_alloc)
            bufferid = eval(buffer_str_alloc);
            set_param(block,'bufferids',buffer_str_alloc);
        else
            error([ 'Failed to allocate a buffer for CAN Receive ' block ...
                    '. There are only 16 buffers in total for CAN module ' ...
                    module '. You should reduce the number of CAN Receive '...
                    ' blocks in your model or configure any CAN Transmit '...
                    ' to use a shared buffer' ]);
        end

     case 'off'
      % -- Manual Allocation of the bufferid ---
      
      buffer_str = num2str(fix(bufferid));
      
      buffer_str_alloc = buffer_resource.manual_allocate(block, buffer_str );
      
      if isempty(buffer_str_alloc)
        host = buffer_resource.get_host(buffer_str);
        
       host = strrep(host,sprintf('\n'),' ');
       error([ 'Failed to allocate buffer ' buffer_str ' for CAN Receive block '...
               block '. This buffer is already allocated to ''' host '''. Please '...
               'choose another buffer number.']);
      end
    end
    
    argout = { bufferid };
        
function i_buffer_callback(host, resource, value )
    % -- Auto resource callback ---
    % disp(['re-allocated ' value ' on CAN_A to ' host ]);
    set_param(host,'bufferids',value);



