function [varargout] = psaspeed2rate(PSASpeed)
%PSASPEED2RATE PSA Standard prepayment vectors.
%   This function returns NSPD number of vectors of PSA 
%   prepayments, each containing 360 prepayment elements 
%   to represent 360 months in a 30-year mortgage pool.
%   
% [CPRPSA, SMMPSA]= psaspeed2rate(PSASpeed)
%
% Inputs:
%  PSASpeed - NSPDx1 vector of percentage multiple to
%             PSA standard prepayment speed.
%             Any value > 0, with 100 being equal to 
%             benchmark PSA speed.
%
% Outputs: [Size is 360xNSPD each]
%    CPRPSA - PSA Conditional Prepayment Rate, in decimal
%
%    SMMPSA - PSA Single Monthly Mortality Rate, in decimal
% 
% Example:
% PSASpeed = [100 200];
% [CPRPSA, SMMPSA]= psaspeed2rate(PSASpeed);

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision 1.3 $  $Date: 2004/04/06 01:09:04 $
if nargin < 1
    error('finfixed:psaspeed2rate:invalidInputs','Not enough input arguments, will need at least PSASpeed');
else
    PSASpeed = PSASpeed(:);  % orient to column vector  
end

CPR = 0.06 * (PSASpeed'/100); % row vector
CPR = CPR(ones(360,1),:);

% This is just formality to indicate where the ramp ends.
PSASwitch = 30; 

for i = 1:length(PSASpeed)
    CPR(1:PSASwitch,i) = 0.06 * [1:PSASwitch]' /...
        30 .* (PSASpeed(i)/100); % This is the growing part
end

% if no argument requested a plot of the CPR is provided

SMM = 1 - (1 - CPR).^(1/12); % All SMM
    
if nargout < 1
    plot(1:360, CPR, '*-r')
    return
else
    varargout = {CPR SMM};% CPRPSAremain SMMPSAremain};
end
