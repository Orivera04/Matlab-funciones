function argout = c166_twincan_tx_validate(block, target, bufferid)
% C166_TWINCAN_TX_VALIDATE - Resource allocater for C166 TwinCAN Transmit block
%   ARGOUT_CELL_ARRAY = C166_TWINCAN_TX_VALIDATE(BLOCK, TARGET, BUFFERID) 
%   performs resource allocation for the TwinCAN Transmit block

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/19 01:17:39 $


  % Find the resources object
    resource = target.findResourceForClass('c166Config.TwinCAN_C166');
    bsm = get_param(block, 'buffer_select_mode');
    
    if isempty(resource)
        error('Could not find configuration for c166Config.TwinCAN_C166');
    end

    buffer_resource = resource.TwinCAN_BUFFERS;

    switch bsm
     case 'Automatic'
      % -- Automatic Allocation of the bufferid ---
      buffer_str_alloc = ...
          buffer_resource.auto_allocate(block, { @i_buffer_callback  });
      
      if ~isempty(buffer_str_alloc)
        bufferid = eval(buffer_str_alloc);
        set_param(block,'bufferids',buffer_str_alloc);
      else
        error([ 'Failed to allocate a buffer for TwinCAN Transmit ' block ...
                '. There are only 32 buffers in total shared between TwinCAN nodes '...
                'A and B. You should reduce the total number of TwinCAN Receive '...
                'and TwinCAN Transmit blocks in your model.']);
      end
     case 'Manual'
      buffer_str = num2str(fix(bufferid));
      buffer_str_alloc = buffer_resource.manual_allocate(block, buffer_str);
      if isempty(buffer_str_alloc)
        host = buffer_resource.get_host(buffer_str);
        
        host = strrep(host,sprintf('\n'),' ');
        error([ 'Failed to allocate buffer ' buffer_str ' for TwinCAN Transmit block '...
                block '. This buffer is already allocated to ''' host '''. Please '...
                'choose another buffer number.']);
      end        
    end
      
    
    argout = { bufferid };
        
function i_buffer_callback(host, resource, value )
    % Resource auto-allocation resource callback:
    % re-allocate buffer used by block 'host'
    set_param(host,'bufferids',value);



