function argout = c166_twincan_rx_validate(block, target, bufferid )
% C166_TWINCAN_RX_VALIDATE - Resource allocater for the C166 TwinCAN Receive block
%   resource allocation for the TwinCAN Receive block.

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/09/01 09:16:32 $


    % Find the resources object
    resource = target.findResourceForClass('c166Config.TwinCAN_C166');
    
    if isempty(resource)
        error('Could not find configuration for c166Config.TwinCAN_C166');
    end

    buffer_resource = resource.TwinCAN_BUFFERS;

    % Automatic Allocation of the bufferid
    buffer_str_alloc = buffer_resource.auto_allocate(block, { @i_buffer_callback  });
    
    if ~isempty(buffer_str_alloc)
      bufferid = eval(buffer_str_alloc);
      set_param(block,'bufferids',buffer_str_alloc);
    else
      error([ 'Failed to allocate a buffer for TwinCAN Receive block ' block ...
              '. There are only 32 buffers in total shared between TwinCAN nodes '...
              'A and B. You must reduce the total number of TwinCAN Receive and '...
              'TwinCAN transmit blocks']);
    end
    
    argout = { bufferid };

function i_buffer_callback(host, resource, value )
    % Resource auto-allocation resource callback:
    % re-allocate buffer used by block 'host'
    set_param(host,'bufferids',value);



