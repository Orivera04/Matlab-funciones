function playsound(h, type)

MsgStr = { 'Please define a proper region (range) to play.'; ''; 
           'To select a region, use:'
           '      - [make sure the +/- zoom buttons are off (not depressed)]'
           ' (i)  left-click to mark the starting point';
           '            (shown as solid vertical red line), and'; '';
           ' (ii) right-click to mark the end point of a region.'
           '            (shown as dotted vertical red line).';''; 
           '';
           'For more help, type "help pw" on the command line'};
       
if type == 1
    soundsc(h.x, h.fs)
elseif type == 2
    range = get(h.fig, 'UserData');
    range = floor( range * h.fs/1000 );
    if (range(2)-range(1)) <=0
        % play reverse - for curiosity or ....
        % soundsc( h.x(range(1):-1:range(2)), h.fs );
        msgbox(MsgStr, 'PT: ERROR', 'error');
        return;
    end;   
    soundsc( h.x(range(1):range(2)), h.fs );    
end