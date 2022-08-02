function [iport,tnext] = manchester_statecnt(oport,tnow,portinfo)
% MANCHESTER_STATECNT  Test bench for VHDL statecnt
%  [IPORT,TNEXT]=MANCHESTER_STATECNT(OPORT,TNOW,PORTINFO) 
%    Implements a test of the state counter applied by
%    the Manchester receiver.  The state counter produces the
%    I and Q waveforms and defines the acquisition period.  The
%    acquisition period is nominally 16 cycles, but may be
%    increased or decreased by one cycle based on the 'adj'
%    input.  
%    The test produces a plot of the IQ waveform for the 
%    3 possible acquistion periods: 15,16 and 17.
%
% 
%                 +-----------+
%                 |   VHDL    |-(1)-> oport.i_wf
% iport.adj -(2)->| statecnt  |-(1)-> oport.q_wf
%                 |           |-(1)-> oport.sync
%                 +-----------+
%   
%   adj  - receive clock adjustment (-1,0,1)
%   i_wf - Inphase waveform
%   q_wf - Quadrature waveform
%   sync - indicates completion of one receive cycle
%   Note - clk, enable,reset omitted for clarity
%
% Adjust = 0 (00b), generate full 16 cycle waveform

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/03/15 22:19:38 $
persistent i_wf_vect;
persistent q_wf_vect;
persistent ploti;
global testisdone;
tnext = [];
iport = struct();

% Run clock
tnext = tnow+10e-9;  % Call me back in 5 ns (10 ns rate)
if tnow < 1e-9 | nargin == 3,  %% First call
    iport.reset = '0';  % intialize these values
    iport.enable = '1';
    iport.adj = '11';
    subplot(3,1,1);
    ploti(1,1) = plot(zeros(1,17)+2,'r');   
    hold on
    ploti(1,2) = plot(zeros(1,17));
    ylabel('Long cycle (17)');
    axis([1 17,-1 4]);
    
    subplot(3,1,2);
    ploti(2,1) = plot(zeros(1,16)+2,'r');   
    hold on
    ploti(2,2) = plot(zeros(1,16));
    ylabel('Nominal cycle (16)');  
    axis([1 16,-1 4]);
    
    subplot(3,1,3);
    ploti(3,1) =plot(zeros(1,15)+2,'r');   
    hold on
    ploti(3,2) =plot(zeros(1,15));
    ylabel('Short cycle (15)');    
    axis([1 15,-1 4]);    
    
    i_wf_vect = [];
    q_wf_vect = [];
    return;  % No action at time 0
end

if tnow > 900e-9,
    tnext = [];  % Call me back in 5 ns (10 ns rate)
    testisdone = 1;      
end

i_wf_vect = [ i_wf_vect oport.i_wf - '0'];
q_wf_vect = [ q_wf_vect oport.q_wf - '0'];
if oport.sync == '1',
    if numel(i_wf_vect) == 17,
        set(ploti(1,1),'YData',i_wf_vect+2);
        set(ploti(1,2),'YData',q_wf_vect);
        iport.adj = '00';
    elseif numel(i_wf_vect) == 16,
        set(ploti(2,1),'YData',i_wf_vect+2);
        set(ploti(2,2),'YData',q_wf_vect);
        iport.adj = '01';
    elseif numel(i_wf_vect) == 15,
        set(ploti(3,1),'YData',i_wf_vect+2);
        set(ploti(3,2),'YData',q_wf_vect);
        iport.adj = '11';
    else
        testisdone = 1;
        error('Test of statecnt.vhd has failed.  The state counter produced an illegal IQ cycle period')
    end
    i_wf_vect = [];
    q_wf_vect = [];  
end

% [EOF] manchester_statecnt.m
