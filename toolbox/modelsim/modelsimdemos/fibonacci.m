function [iport,tnext] = fibonacci(oport,tnow,portinfo)
% FIBONACCI - Visualization functions of a VHDL Fibonacci-based 
%  pseudo random (PN) generator.  This function implements two 
%  useful plots with relevant characteristics of the supplied 
%  VHDL generator code.  This function is invoked by rising-edge
%  transition on the clock for 'fibonacci'.
%
%  ModelSim Entry - Executed by HDLDaemon on request from the HDL simulator
%   FIBONACCI(OPORT,TNOW,PORTINFO)
%   FIBONACCI(OPORT,TNOW)
%   Where
%     OPORT.DATA    - VHDL signal DATA value at simulation time TNOW
%     TNOW          - Simulation time (in seconds) 
%     PORTINFO.DATA - Structure of port information (first invocation)
% 

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/08/25 05:48:51 $
fib_demo(bin2dec(oport.dout'),tnow);

%=============================================================
function fib_demo(idata,tnow)
% Plot information in Fibonacci demo display
persistent nvbins;
persistent bins;
persistent edges;
persistent datas;
inc = round(tnow/20e-9); 

if inc < 1800, 
    if isempty(datas) || inc == 0,
        datas = zeros(1,1800);
    end
    startca = findobj('Tag','StartupPlot');
    if ~isempty(startca),
        mic = mod(inc,200);
        datas(inc+1) = double(idata);
        if mic == 199,   % Only plot every 200 samples (saves time)
            set(get(startca,'Children'),'XData',1:inc+1,'YData',(datas(1:inc+1)));
            set(startca,'XLim',[1 1800],'YLim',[0 2^32]);
        end
    end
else
    if inc == 1800 || isempty(bins),    % First time, empty the bins
        bins = zeros(1,26);
        edges = linspace(0,2^32,26);
        datas = zeros(1,200);
        nvbins = 1;
    end
    histca = findobj('Tag','HistoPlot');
    if ~isempty(histca),
        hbars = get(histca,'Children');
        mic = mod(inc,200);
        datas(mic+1) = double(idata);
        if mic == 199,   % Only plot/bin every 200 samples (saves time)
            bins = bins + histc(datas,edges);
            ydata = get(hbars,'YData');
            xdata = get(hbars,'XData');            
            ydata(2:3,:) = [bins; bins]/(nvbins*200);
            nvbins = nvbins +1;
            set(hbars,'FaceVertexCData',1);
            set(hbars, 'YData',ydata,'XData',xdata);
        end
   end
end

% [EOF] fibonacci.m

