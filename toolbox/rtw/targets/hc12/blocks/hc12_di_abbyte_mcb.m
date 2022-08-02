function hc12_di_abbyte_mcb(DIPortChoice)
    %
    % HC12 Digital Input (ports) A or B, Mask Initialization Callback.
    %
    % $Revision: 1.1.6.2 $  $Date: 2004/04/19 01:23:16 $
    % Copyright 2002-2003 The MathWorks, Inc.
    
    % Create resource keyword to be reserved in resource database
    DIPortChoiceStr = strcat('PORT',DIPortChoice);

    % Try reserving 'PORTA' or 'PORTB' for this block instance
    % If the resource is not available, it will error out immediately.
    reservationmanager('di', {DIPortChoiceStr} );

    modelRTWFields = struct( ...\
              'diport', DIPortChoiceStr, ...\
              'ddrStr', strcat('DDR',DIPortChoice) ); 

    % Insert modelRTWFields in the I/O block's S-Function
    % containing the Tag 'HC12DriverData'
    hc12_setsfunrtwdata(modelRTWFields);
