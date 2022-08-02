function hc12_adc_v_mcb(bank)
    %
    % HC12 ADC Output Mask Initialization callback.
    %   Allow ADC block to reserve a single instance
    %   of this block for bank 0 and a single instance
    %   for bank 1.
    
    % $Revision: 1.2.6.2 $  $Date: 2004/04/19 01:23:15 $
    % Copyright 2002-2003 The MathWorks, Inc.

    ADCBankChoiceStr = strcat('ATD',num2str(bank),'CTL5');

    % Try reserving 'ATD0CTL5' or 'ATD1CTL5' for this block instance
    % If the resource is not available, it will error out immediately.
    reservationmanager('adc', {ADCBankChoiceStr});
    