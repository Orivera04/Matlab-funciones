function tbediscount = tbillrepo(varargin)
%TBILLREPO True break-even discount of T-bill.
%   Breakeven discount rates of NTBILL number of T-bills 
%   given funding (repo) rate.
% 
% TbeDiscount = tbillrepo(RepoRate, InitialDiscount, ...
%                    PurchaseDate, SaleDate, Maturity);
%
% Inputs:
%        RepoRate - NTBILLx1 vector of annualized, 
%                   ACT/360 based, term-repo rate in decimal. 
%
% InitialDiscount - NTBILLx1 vector of discount on the T-bill 
%                   at the date of purchase, in decimal. 
%
%    PurchaseDate - NTBILLx1 vector of date T-bill is 
%                   purchased and repoed.
%
%        SaleDate - NTBILLx1 vector of dates the repo 
%                   term is due/T-bill is sold.
%
%        Maturity - NTBILLx1 vector of T-bill maturity
%
% Outputs:
%     TbeDiscount - True breakeven discount, in decimal.
%                  
% Example:
% RepoRate = [0.045; 0.0475]
% InitialDiscount = 0.0475;
% PurchaseDate = datenum('3-Jan-2002');
% SaleDate = datenum('3-Feb-2002');
% Maturity = datenum('3-Apr-2002');
%
% tbediscount = tbillrepo(RepoRate, InitialDiscount, ...
%     PurchaseDate, SaleDate, Maturity);

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.3 $   $Date: 2004/04/06 01:09:09 $

if nargin ~= 5
    error('finfixed:tbillrepo:invalidInput',['Incorrect number of input argument. ',...
          'please type "help tbillrepo" for information']);
else
    RepoRate = varargin{1}(:);
    InitialDiscount = varargin{2}(:);
    PurchaseDate = datenum(varargin{3});
    SaleDate = datenum(varargin{4});
    Maturity = datenum(varargin{5});    
end

[RepoRate, PurchaseDate, SaleDate, Maturity, InitialDiscount] ...
    = finargsz(1,RepoRate(:), PurchaseDate(:), ... 
  SaleDate(:), Maturity(:), InitialDiscount(:));
                
%after everything fully expanded
if any(SaleDate-PurchaseDate < 0)
    error('finfixed:tbillrepo:invalidPurchaseDate','PurchaseDate must be less than or equal to SaleDate ')
end

if any(Maturity-SaleDate < 0)
    error('finfixed:tbillrepo:invalidSaleDate','SaleDate must be less than or equal to Maturity')
end

T1 = daysdif(PurchaseDate, Maturity);
T2 = daysdif(SaleDate, Maturity);

tbediscount = (1 - (1 - InitialDiscount.*T1/360).*...
    (1 + RepoRate.*(T1-T2)./360) ) * 360./T2;
