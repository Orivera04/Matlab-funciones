function argout = c166_can_tx_validate(block, target, bufferid)
% C166_CAN_TX_VALIDATE - Resource allocater for C166 CAN Transmit block
%   ARGOUT_CELL_ARRAY = C166_CAN_RX_VALIDATE(BLOCK, TARGET, BUFFERID) 
%   performs resource allocation for the CAN Transmit block

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $
%   $Date: 2004/04/19 01:17:38 $

    % Retrieve and check the ReferenceBlock Parameter
    module = get_param(block,'module'); % A | B
    bsm = get_param(block, 'buffer_select_mode');

    % Find the resources object
    resource = target.findResourceForClass('c166Config.CAN_C166');
    config = target.findConfigForClass('c166Config.CAN_C166');
    
    if isempty(resource)
        error('Could not find configuration for c166Config.CAN_C166');
    end

    switch module
     case 'A'
      buffer_resource = resource.CAN_A_BUFFERS;
      config_can = config.CAN_A;
     case 'B'
      buffer_resource = resource.CAN_B_BUFFERS;
      config_can = config.CAN_B;
    end      
    
    tx_mode = get_param(block,'tx_mode');
    
    switch tx_mode
     case {'Direct transmission with dedicated buffer',...
           'FIFO queued transmission with dedicated buffer'}
      switch bsm
        case 'Automatic'
        % -- Automatic Allocation of the bufferid ---
        buffer_str_alloc = ...
            buffer_resource.auto_allocate(block, { @i_buffer_callback  });
        
        if ~isempty(buffer_str_alloc)
          bufferid = eval(buffer_str_alloc);
          set_param(block,'bufferids',buffer_str_alloc);
        else
          error([ 'Failed to allocate a buffer for CAN Transmit ' block ...
                  '. There are only 15 buffers in total for CAN module ' ...
                  module '. You should reduce the number of CAN Receive '...
                  'blocks in your model or configure any CAN Transmit blocks '...
                  'to use a shared buffer.' ]);
        end
       case 'Manual'
        buffer_str = num2str(fix(bufferid));
        buffer_str_alloc = buffer_resource.manual_allocate(block, buffer_str);
        if isempty(buffer_str_alloc)
          host = buffer_resource.get_host(buffer_str);
          
          host = strrep(host,sprintf('\n'),' ');
          error([ 'Failed to allocate buffer ' buffer_str ' for CAN Transmit block '...
                  block '. This buffer is already allocated to ''' host '''. Please '...
                  'choose another buffer number.']);
        end        
      end
     case 'Queued transmission with shared buffer'
        buffer_str = config_can.CAN_transmit_buffer_number;
        buffer_str_alloc = buffer_resource.manual_allocate('Shared Transmit Buffer', buffer_str);
        if isempty(buffer_str_alloc)
          host = buffer_resource.get_host(buffer_str);
          % Permissible that the resource already in use as Shared Tx buffer, otherwise error
          if ~strcmp(host,'Shared Transmit Buffer')
            host = strrep(host,sprintf('\n'),' ');
            error([ 'Failed to allocate buffer ' buffer_str ' for CAN Transmit block '...
                    block '. This buffer is already allocated to ''' host '''. Please '...
                    'choose another buffer number.']);
          end
        end        
        config_can.RequireSharedTxBuffer = 1;
     case 'FIFO queued transmission with dedicated buffer'
     otherwise
      error(['Unrecognized value for transmit mode ' tx_mode ])
    end
    
    argout = { bufferid };
        
function i_buffer_callback(host, resource, value )
    % Resource auto-allocation resource callback:
    % re-allocate buffer used by block 'host'
    set_param(host,'bufferids',value);



