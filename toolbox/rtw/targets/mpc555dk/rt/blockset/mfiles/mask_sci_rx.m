function iconstr = mask_sci_rx(show_length, show_reset, show_bytes_read, show_flags, show_overrun)
%MASK_SCI_RX creates a command string for the block icon

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:29:50 $
 
  
iconstr = [...
    'text(0.5, 0.5, [''SCI'' num2str(module) ''\nReceive''],''horizontalAlignment'',''center'');'...
    'port_label(''output'',1,''Data'');'...
];

nextIn = 1;
nextOut = 2;

if show_length
  iconstr = [ iconstr ...
              'port_label(''input'', ' num2str(nextIn) ', ''Len'');' ];
  nextIn = nextIn+1;
end

if show_reset
  iconstr = [ iconstr ...
              'port_label(''input'', ' num2str(nextIn) ', ''Rst'');' ];
  nextIn = nextIn+1;
end

if show_bytes_read
  iconstr = [ iconstr ...
              'port_label(''output'', ' num2str(nextOut) ', ''Num'');' ];
  nextOut = nextOut+1;
end

if show_flags
  iconstr = [ iconstr ...
              'port_label(''output'', ' num2str(nextOut) ', ''Flgs'');' ];
  nextOut = nextOut+1;
end

if show_overrun
  iconstr = [ iconstr ...
              'port_label(''output'', ' num2str(nextOut) ', ''Orun'');' ];
  nextOut = nextOut+1;
end

