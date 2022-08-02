function argout = c166_serial_resource(block, target, resource_string )
% C166_SERIAL_RESOURCE - Resource allocation for C166 serial blocks
%   ARGOUT_CELL_ARRAY = C166_SERIAL_RESOURCE(BLOCK, TARGET, RESOURCE) performs 
%   resource allocation for the the Serial Transmit or Serial Receive
%   BLOCK. In this case the resource is one of ASC0_TX or ASC0_RX.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/11/15 17:10:42 $

    % -- Resource allocation function ---

    % Find a resources object
    resource = target.findResourceForClass('c166Config.C166System');
    if isempty(resource)
        error('Could not find configuration for c166Config.C166System');
    end

    serial_interface = resource.SERIAL_INTERFACE;

    serial_interface_alloc = serial_interface.manual_allocate(block,resource_string);
    
    if isempty(serial_interface_alloc)
      host = serial_interface.get_host(resource_string);
      host = strrep(host,sprintf('\n'),' ');
      error([ 'Attempt to use resource that is already allocated. '...
              'The serial communications resource ' resource_string ...
              ', required by block ' block ' is already allocated to '''...
              host '''. Please  resolve the conflict. ']);
    end
    
    argout = {resource_string};
    



