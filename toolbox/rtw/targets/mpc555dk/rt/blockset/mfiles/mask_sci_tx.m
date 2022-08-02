function iconstr = mask_sci_tx(show_length, show_num_sent)
%MASK_SCI_TX creates a command string for the SCI Transmit block icon

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:29:51 $
 
  
iconstr = [...
    'text(0.5, 0.5, [''SCI'' num2str(module) ''\nTransmit''],''horizontalAlignment'',''center''); '...
    'port_label(''input'',1,''Data''); '...
];

nextIn = 2;
nextOut = 1;

if show_length
  iconstr = [ iconstr ...
              'port_label(''input'', ' num2str(nextIn) ', ''Req'');' ];
  nextIn = nextIn+1;
end

if show_num_sent
  iconstr = [ iconstr ...
              'port_label(''output'', ' num2str(nextOut) ', ''Num'');' ];
  nextOut = nextOut+1;
end
