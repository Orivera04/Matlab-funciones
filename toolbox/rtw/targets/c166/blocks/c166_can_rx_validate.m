function argout = c166_can_rx_validate(block, target, bufferid )
% C166_CAN_RX_VALIDATE - Resource allocater for the C166 CAN Receive block
%   resource allocation for the CAN Receive block.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/19 01:17:37 $

    % Retrieve and check the ReferenceBlock Parameter
    module = get_param(block,'module'); % A | B
    
    % Find the resources object
    resource = target.findResourceForClass('c166Config.CAN_C166');
    
    if isempty(resource)
        error('Could not find configuration for c166Config.CAN_C166');
    end

    bsm = get_param(block,'buffer_select_mode');

    switch module
    case 'A'
        buffer_resource = resource.CAN_A_BUFFERS;
    case 'B'
        buffer_resource = resource.CAN_B_BUFFERS;
    end

    switch bsm
    case 'Automatic'

        buffer_str_alloc = buffer_resource.auto_allocate(block, { @i_buffer_callback  });
      
        if ~isempty(buffer_str_alloc)
            bufferid = eval(buffer_str_alloc);
            set_param(block,'bufferids',buffer_str_alloc);
        else
          error([ 'Failed to allocate a buffer for CAN Receive block ' block ...
                  '. There are only 15 buffers in total. You must reduce the '...
                  'number of separate CAN receive blocks for CAN module ' module ]);
        end
        
     case 'Manual'
      
      buffer_str = num2str(fix(bufferid));
      
      buffer_str_alloc = buffer_resource.manual_allocate(block, buffer_str );

      if isempty(buffer_str_alloc)
        host = buffer_resource.get_host(buffer_str);
        try
          hostName = host.getTarget.block;
        catch 
          hostName = host;
        end
        hostName = strrep(hostName,sprintf('\n'),' ');
        error([ 'Failed to allocate CAN ' module ' buffer number ' buffer_str ' to  CAN Receive '...
                'block ' block ...
                '. This buffer is already allocated to ''' hostName '''. Please '...
                'choose another buffer number.']);
      end
      
    end
    
    argout = { bufferid };

function i_buffer_callback(host, resource, value )
    % Resource auto-allocation resource callback:
    % re-allocate buffer used by block 'host'
    set_param(host,'bufferids',value);



