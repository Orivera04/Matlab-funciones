function [iport,tnext] = modsimrand_plot(oport, tnow, portinfo)
%MODSIMRAND_PLOT HDL simulator data transfer for demo "modsimrand"
%    MODSIMRAND_PLOT is executed by HDLDaemon on request from the HDL simulator.
%
%    ModelSim Entry - Executed by HDLDaemon on request from the HDL simulator
%     MODSIMRAND_PLOT(OPORT,TNOW,PORTINFO)
%     MODSIMRAND_PLOT(OPORT,TNOW)
%     Where
%       OPORT.DATA    - VHDL signal DATA value at simulation time TNOW
%       TNOW          - Simulation time (in seconds) 
%       PORTINFO.DATA - Structure of port information (first invocation)
%
%    Visualize statistics of the VHDL lagged-Fibonacci pseudo-random
%    number generator.  Invoked by rising-edge transition on the clock
%    for 'entity_name.vhd'.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/08 20:55:06 $

persistent ud;  % userdata

tnext = [];
iport = struct();

% Plot information in DEMO_NAME demo display

if nargin == 3 || isempty(ud),  % first time being called?
    % Get handles to GUI plots:
    hax_vals = findobj('Tag','StartupPlot');
    hax_hist = findobj('Tag','HistoPlot');

    nbins         = 26;     % # of bins in histogram - no need to retain in UserData
    ud.bufsiz     = 200;    % # values to hold in buffer
    ud.startDelay = 2400;   % # ticks to display as "startup values", omitted from histogram
    ud.inc        = 0;      % # of callback events to this function
    ud.buffer = zeros(1,ud.bufsiz);          % buffer data values before updating GUI
    ud.bins   = zeros(1,nbins);              % histogram bins
    ud.edges  = linspace(0, 2.^32, nbins+1); % histogram bin edges
    ud.hline  = get(hax_vals,'Children');    % HG handle to line plot
    ud.hbars  = get(hax_hist,'Children');    % HG handle to bar chart
    
    set(hax_vals,'xlim',[1 ud.startDelay], 'ylim',[0 2.^32]);
    set(hax_hist,'ylim',[0 1.5 ./ nbins]);
    set(ud.hline, 'xdata',1:ud.startDelay, ...
                  'ydata',zeros(1,ud.startDelay));
    set(ud.hbars, 'FaceVertexCData',1);
end

% Update every time data is received from HDL simulator:
%
ud.inc = ud.inc+1;                % increment function-call counter
cyc = 1+mod(ud.inc-1, ud.bufsiz); % cyclic counter, 1:bufsiz
ud.buffer(cyc) = mvl2dec(oport.dout);  % buffer scalar values from simulator
if cyc == ud.bufsiz,              % update GUI every n'th scalar received
    if ud.inc <= ud.startDelay,
        % Plot values of initial data
        if ishandle(ud.hline), % in case GUI closed
            ydata = get(ud.hline,'ydata');
            ydata( (ud.inc-ud.bufsiz+1) : ud.inc ) = ud.buffer;
            set(ud.hline, 'ydata',ydata);
        end
    else
        % Generate running histogram of remaining data
        if ishandle(ud.hbars),  % in case GUI closed
            tmpbins = histc(ud.buffer,ud.edges);
            ud.bins = ud.bins + tmpbins(1:end-1);    % last bin from histc is always 0
            xdata = get(ud.hbars,'xdata');  % xxx bug fix: xdata changes
            ydata = get(ud.hbars,'ydata');
            ydata(2:3,:) = [ud.bins; ud.bins]./sum(ud.bins);
            set(ud.hbars, 'ydata',ydata, 'xdata',xdata); % xxx bug fix: xdata changes
        end
    end
    drawnow;  % update GUI displays
end

% [EOF] modsimrand_plot.m
