function hc12_do_abbyte_mcb(DOPortChoice)
    %
    % HC12 Digital Output (ports) A or B, Mask Initialization Callback.
    %
    % $Revision: 1.1.6.2 $  $Date: 2004/04/19 01:23:17 $
    % Copyright 2002-2003 The MathWorks, Inc.
    
    % Create resource keyword to be reserved in resource database
    DOPortChoiceStr = strcat('PORT',DOPortChoice);
    
    % Try reserving 'PORTA' or 'PORTB' for this block instance
    % If the resource is not available, it will error out immediately.
    reservationmanager('do', {DOPortChoiceStr} );

    modelRTWFields = struct( ...\
              'doport', DOPortChoiceStr, ...\
              'ddrStr', strcat('DDR',DOPortChoice) ); 

    % Insert modelRTWFields in the I/O block's S-Function
    % containing the Tag 'HC12DriverData'
    hc12_setsfunrtwdata(modelRTWFields);

