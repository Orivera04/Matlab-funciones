function [iport,tnext] = manchester_iqconv(oport,tnow,portinfo)
% MANCHESTER_IQCONV  Test bench for VHDL IQ convolution
%  [IPORT,TNEXT]=MANCHESTER_IQCONV(OPORT,TNOW,PORTINFO) 
%   IQ Convolver of the Manchester decoder does an xor of 
%   the raw samples (samp) with two waveforms: i_wf and q_wf.  
%   The results of the xor are summed and output as isum 
%   and qsum. This computation is related to a convolution of 
%   NRZ waveforms.  This test bench verifies that the VHDL
%   computes the expected output for a random generated
%   stream of samples.  
%
%  
%  iport                        oport
%            +-----------+
% i_wf -(1)->|   IQ      |-(2)-> isum
% q_wf -(1)->| Convolver |-(1)-> qsum
% samp -(1)->|           |
%            +-----------+
%  Major signals
%   adj  - Clock adjustment ('01','00','10')
%   dvalid - Data validity ('1' = data is valid)
%   isum - Inphase Convolution value = Sum(i_wf * samp)
%   qsum - Quadrature Convolution value = Sum(q_wf * samp)
%   Note - clk, enable,reset omitted for clarity
% 
% Input controls signals
%  clk,enable, reset

% Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/08 20:55:01 $

persistent iters; 
persistent icycle;
persistent samp_vect;
persistent i_wf_vect;
persistent q_wf_vect;
global testisdone;
tnext = [];

iport.reset = '0';  % Disable reset (might be overwitten at end of cycle
if isempty(iters),  %% First call
    iters = 0;
    icycle = 15 + floor(rand*3);  %% Create random cycle length of 15,16 or 17
    samp_vect = randbin(icycle);
    i_wf_vect = randbin(icycle);
    q_wf_vect = randbin(icycle);
elseif icycle == 0,
    % test isum and qsum for correct value
    % Verify result computed by VHDL (using previous vector of data)
    test_isum = binary_xor(i_wf_vect,samp_vect);
    test_qsum = binary_xor(q_wf_vect,samp_vect);    
    if (test_isum ~= bin2dec(oport.isum')),
        disp(['Failed on iteration ' num2str(iters) ' Expected ISUM = ' dec2bin(test_isum,5) ' Received ISUM = ' oport.isum' ]);
    end
    if (test_qsum ~= bin2dec(oport.qsum')),
        disp(['Failed on iteration ' num2str(iters) ' Expected QSUM = ' dec2bin(test_qsum,5) ' Received QSUM = ' oport.qsum' ]);
    end
    % prepare for NEXT cycle
    icycle = 15 + floor(rand*3);  %% Create random cycle length of 15,16 or 17
    samp_vect = randbin(icycle);
    i_wf_vect = randbin(icycle);
    q_wf_vect = randbin(icycle);
elseif icycle == 1,    
    iport.reset = '1';  % This goes here to cause the internal counter to clear
end
iport.i_wf = i_wf_vect(icycle);
iport.q_wf = q_wf_vect(icycle);
iport.samp = samp_vect(icycle);


iters = iters +1;
icycle = icycle-1;

if iters == 101,  % done when this occurs (
    iters = [];
    testisdone = 1;
end

function out = randbin(nlen)
% Create a random vector of binary states '1' and '0'
out =  char((rand(1,nlen) > 0.5) + '0');

function convol = binary_xor(x,y)
% BINARY_XOR - performs a binary convolution
% Convolution of two binary encoded waveforms (vectors)
num = numel(x);
if num ~= numel(y),
    error('Convolution requires equal sized vectors');
end
convol = sum(xor(x - '0',y - '0'));

% [EOF] 
