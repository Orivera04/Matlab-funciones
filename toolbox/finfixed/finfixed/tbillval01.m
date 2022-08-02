function [value01Disc, value01MMY, value01BEY] = ...
    tbillval01(Settle, Maturity)
%TBILLVAL01 Value of basis point of T-bills.
%   Value of one basis point of NTBILL number
%   of T-bills.
%
% [Val01Disc, Val01MMY, Val01BEY] = tbillval01(Settle, Maturity)
%
% Inputs:
%      Settle - NTBILLx1 vector of settlement dates.
%
%    Maturity - NTBILLx1 vector of maturity of T-Bills.
%
% Outputs:
%   Val01Disc - Value of one basis point of discount rate
%               for every $100 face.
%
%    Val01MMY - Value of one basis point of Money market 
%               yield of T-bill for every $100 face.
%
%    Val01BEY - Value of one basis point of Bond Equivalent
%               yield of T-bill for every $100 face.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.7.6.3 $   $Date: 2004/04/06 01:09:10 $

if (nargin ~= 2)
    error('finfixed:tbillval01:invalidInput',['Incorrect number of inputs, need Settle and Maturity. ',... 
           'Please type "help TBILLVAL01`" for more information'])
end

[Settle, Maturity] = finargsz(1, datenum(Settle), datenum(Maturity));

if any(Settle > Maturity)
    error('finfixed:tbillval01:invalidSettleDate','Settle must be less than or equal to Maturity')
end

% Days to maturity in actual basis
DSM = daysact(Settle, Maturity);

% Rate = 0.0001 (1 bp.) out of $100
Rate = 0.0001;
Face = 100;

% While Rate can be a scalar, a vector was chosen 
% for possible future expansion of this function
CMMY = 360.*Rate ./ (360 + Rate.*DSM);
CBEY = 360.*Rate ./ (365 + Rate.*DSM);

% We will compute the value of Tbills 01 now that we have all 
% annualized discount rate
value01Disc = Rate.*Face.*DSM/360;
value01MMY = CMMY.*Face.*DSM/360; 
value01BEY = CBEY.*Face.*DSM/360;
