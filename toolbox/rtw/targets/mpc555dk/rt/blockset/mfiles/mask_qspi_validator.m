function argout = mask_qspi_validator(block, target, irq_str )
%MASK_QSPI_VALIDATOR  Validates resources held by the QSPI config block
%
% -- Notes ---
%
%   This validates the IRQ level held by the QSPI block. This
%   block should really be removed in favour of the Configuration
%   system but it is convienient at the moment to let this module
%   stay as it is.

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.10.4.1 $
%   $Date: 2004/04/19 01:29:49 $

    % Find a resources object
    resource = target.findResourceForClass('MPC555dkConfig.SYSTEM_CLOCKS');
    if isempty(resource)
        error('Could not find configuration for MPC555dkConfig.SYSTEM_CLOCKS');
    end

    res = resource.IRQ_LEVELS.manual_allocate(block, irq_str );

    if isempty(res)
        host = resource.IRQ_LEVELS.get_host(irq_str);
        if ischar(host)
            hilite_system(host,'error');
            error([ 'Failed to allocate ' irq_str ' to  CAN RX block ' block ...
                ' . This IRQ is currently allocated manually to ' host '. Please choose another ' ...
                ' irq. ']);
            %
        else
            error([ 'Failed to allocate ' irq_str ' to  CAN RX block ' block ...
                ' . This IRQ is currently already allocated to a driver in the configuration ' ...
                ' block. Please select another IRQ level ' ]);
            %
        end
        open_system(block);
    end

    argout = { irq_str };

