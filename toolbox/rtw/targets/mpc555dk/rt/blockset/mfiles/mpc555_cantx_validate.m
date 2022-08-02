function argout = mpc555_cantx_validate(block, target, bufferid)
% MPC555_CANTX_VALIDATE - Resource allocater for the MPC555 CAN RX block
%
%   [ argout_cell_array ] = mpc555_cantx_validate(block, target)
%   and returns ...
%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/19 01:29:54 $

    % -- Resource allocation function ---

    % Retrieve and check the ReferenceBlock Parameter
    module = get_param(block,'module'); % A | B | C

    % Find a resources object
    resource = target.findResourceForClass('MPC555dkConfig.TOUCAN');
    config = target.findConfigForClass('MPC555dkConfig.TOUCAN');
    
    switch module
     case 'A'
      buffer_resource = resource.CAN_A_BUFFERS;
      config_toucan = config.CAN_A;
     case 'B'
      buffer_resource = resource.CAN_B_BUFFERS;
      config_toucan = config.CAN_B;
     case 'C'
      buffer_resource = resource.CAN_C_BUFFERS;
      config_toucan = config.CAN_C;
     otherwise
      module
      error(['Unrecognized value for parameter module.']);
    end      
    
    if isempty(resource)
        error('Could not find configuration for MPC555dkConfig.TOUCAN');
    end

    tx_mode = get_param(block,'tx_mode');

    switch tx_mode
     case {'Direct transmission with dedicated buffer',...
           'FIFO queued transmission with dedicated buffer'}
      
      
      % -- Automatic Allocation of the bufferid ---

      buffer_str_alloc = buffer_resource.auto_allocate(block, { @localBufferCallback  });
      
      if ~isempty(buffer_str_alloc)
        bufferid = eval(buffer_str_alloc);
        set_param(block,'bufferids',buffer_str_alloc);
      else
        error([ 'Failed to allocate a buffer for CAN Transmit ' block ...
                '. There are only 16 buffers in total for CAN module ' ...
                module '. You should reduce the number of CAN Receive '...
                'blocks in your model or configure any CAN Transmit blocks '...
                'to use a shared buffer.' ]);
      end

     case 'Queued transmission with shared buffer'
      localReserveSharedTxBuffers(config_toucan, buffer_resource, block);
     otherwise
      error(['Unrecognized value for transmit mode ' tx_mode ])
    end
    
    argout = { bufferid };


function localReserveSharedTxBuffers(config_toucan, buffer_resource, block)
  config_toucan.RequireSharedTxBuffer = 1;     
  % Reserve shared queue transmit buffers for CAN module
  num_buffers = localVal2numbuffers(config_toucan.Transmit_Shared_Buffers);
  for i=1:num_buffers
    buffer = num2str(i-1);
    resource_host = ['Transmit Queue Shared Buffers ' buffer];
    buffer_str_alloc = buffer_resource.manual_allocate(resource_host, buffer );
    if isempty(buffer_str_alloc)
      host = buffer_resource.get_host(buffer);
      % Permissible that the resource already in use as Shared Tx buffer, otherwise error
      if ~strcmp(host,resource_host)
        host = strrep(host,sprintf('\n'),' ');
        error([ 'Failed to allocate buffer ' buffer ' for CAN Transmit block '...
                block '. This buffer is already allocated to ''' host '''. Please '...
                'choose another buffer number.']);
      end
    end        
  end 
  
    
    
function localBufferCallback(host, resource, value )
    % -- Auto resource callback ---
    % disp(['re-allocated ' value ' on CAN_A to ' host ]);
    set_param(host,'bufferids',value);



    
function num_buffers = localVal2numbuffers(value)
  if strcmp(value,'Single TouCAN buffer')
    num_buffers = 1;
  elseif strcmp(value, 'Three TouCAN buffers')
    num_buffers = 3;
  else
    error('Unrecognized setting for value');
  end
  
