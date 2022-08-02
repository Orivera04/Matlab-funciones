function varargout = psaspeed2default(varargin)
%PSASPEED2DEFAULT Standard PSA default rate.
%   This function returns NDEF number of vectors of PSA 
%   default rate, each containing 360 prepayment elements 
%   to represent 360 months in a 30-year mortgage pool.
%
% [ADRPSA, MDRPSA]= psadefault2rate(PSADefaultSpeed)
% 
% Input:
% PSADefaultSpeed - NDEFx1 vector of Annual speed 
%                   relative to the benchmark. 
%                   (100 is the PSA benchmark.)
% 
% Outputs: [Size is 360xNDEF each]
%          ADRPSA - PSA Default Rate, in decimal [360 x 1]
%          MDRPSA - PSA Monthly Default Rate, in decimal [360 x 1]
%  
% Example:
% DefaultSpeed = 100;
%
% [ADRPSA, MDRPSA]= psaspeed2default(DefaultSpeed);

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.5.6.3 $  $Date: 2004/04/06 01:09:03 $

if nargin < 1
    error('finfixed:psaspeed2default:invalidInputs','Not enough input arguments, will need at least PSADefaultSpeed');
else
    DefaultSpeed = varargin{1};
end

% Generate the benchmark
i = 1:30;
j = 31:60;
k = 61:120;
l = 349:360;

ADR = 0.03*ones(360,1) / 100; % Must divide by 100 to get fraction out of percentage.

ADR(i) = i/30*0.6/100;
ADR(j) = 0.6/100;
ADR(k) = 0.6/100 - ( (k-60)/60 ) * (0.6-0.03)/100;
ADR(l) = 0;

ADR = ADR*DefaultSpeed/100;

% now compute the monthly default rate.
MDR = 1 - (1 - ADR).^(1/12);

% ADRRemain = ADR(BeginTerm:end);
% MDRRemain = MDR(BeginTerm:end);

if nargout < 1
    plot(1:360,ADR,'*-r');%, BeginTerm:OriginalTerm, ADRRemain, 'b')
    return
else
    varargout = {ADR MDR};
end
