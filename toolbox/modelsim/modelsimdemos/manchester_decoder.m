function [iport,tnext] = manchester_decoder(oport,tnow,portinfo)
% MANCHESTER_DECODER  Test bench for VHDL 'decoder' 
%  [IPORT,TNEXT]=MANCHESTER_DECODER(OPORT,TNOW,PORTINFO) - 
%    Implements a test of the VHDL decoder entity which is part 
%    of the Manchester receiver demo.  This test bench plots
%    the IQ mapping produced by the decoder. 
% 
%      iport              oport
%            +-----------+    
% isum -(5)->|           |-(2)-> adj
% qsum -(5)->| decoder   |-(1)-> dvalid
%            |           |-(1)-> odata
%            +-----------+
%  
%   isum - Inphase Convolution value
%   qsum - Quadrature Convolution value
%   adj  - Clock adjustment ('01','00','10')
%   dvalid - Data validity ('1' = data is valid)
%   odata - Recovered data stream
%
% Adjust = 0 (00b), generate full 16 cycle waveform

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/08 20:55:00 $

persistent isum;
persistent qsum;
%persistent ga;
persistent x;
persistent y;
persistent adj;
persistent data;
global testisdone;
% This useful feature allows you to manually
% reset the plot by simply typing: >manchester_decoder
tnext = [];
iport = struct();

if nargin == 0,
    isum = [];
    return;
end

if exist('portinfo') == 1
    isum = [];
end

tnext = tnow+1e-9;
if isempty(isum),  %% First call
    scale = 9;
    isum = 0;
    qsum = 0;
    for k=1:2,
        ga(k) = subplot(2,1,k);
        axis([-1 17 -1 17]);
        ylabel('Quadrature');
        line([0 16],[8 8],'Color','r','LineStyle',':','LineWidth',1)
        line([8 8],[0 16],'Color','r','LineStyle',':','LineWidth',1)
    end
    xlabel('Inphase');
    subplot(2,1,1);    
    title('Clock Adjustment (adj)');
    subplot(2,1,2);    
    title('Data with Validity');
    iport.isum = '00000';
    iport.qsum = '00000';
    return;
end
    
% compute one row, then plot
isum = isum + 1;
adj(isum) = bin2dec(oport.adj');
data(isum) = bin2dec([oport.dvalid oport.odata]);

if isum == 17,
    subplot(2,1,1);
    for k=0:16,
        if adj(k+1) == 0,  % Bang on! 
            line(k,qsum,'color','k','Marker','o');
        elseif adj(k+1) == 1,  % 
            line(k,qsum,'color','r','Marker','<');
        else 
            line(k,qsum,'color','b','Marker','>');
        end
    end
    subplot(2,1,2);  
    for k=0:16,    
        if data(k+1) < 2,  % Invalid
            line(k,qsum,'color','r','Marker','X');
        else
            if data(k+1) == 2,  %Valid and 0! 
                line(k,qsum,'color','g','Marker','o');
            else
                line(k,qsum,'color','k','Marker','.');
            end
        end
    end

    isum = 0;
    qsum = qsum + 1;    
    if qsum == 17,
        qsum = 0;
        disp('done');
        tnext = [];  % suspend callbacks
        testisdone = 1;
        return;
    end
    iport.isum = dec2bin(isum,5);
    iport.qsum = dec2bin(qsum,5);    
else
    iport.isum = dec2bin(isum,5);
end


