% showwind script
%
%	Called by sigdemo1 if the signal processing toolbox is present
% 

%	Copyright (c) 1984-94 by The MathWorks, Inc.

    figure

    axes('Position',[.15 .62 .8 .3]);
    plot(t,window); 
    title('Window function');
    xlabel('time (seconds)');
    grid;
    ylabel('Window');

    axes('Position',[.15 .2 .8 .3]);
    [W,omega]=freqz(window,1,512);
    plot(omega/2/pi/T,20*log10(abs(W))); 
    set(gca,'xlim',[0 1/(2*T)]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    grid;
    windclose=uicontrol('Style','Pushbutton','Position',[.85 .02 .12 .08],...
        'Units','normalized','Callback','close','String','Close');
    
