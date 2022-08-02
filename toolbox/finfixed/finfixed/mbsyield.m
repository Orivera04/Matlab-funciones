function varargout = mbsyield(varargin)
%MBSYIELD Mortgage pool yield to maturity given price and prepayment. 
%   Theoretical yields of NMBS number of mortgage-pool 
%   given their prices and prepayment assumptions.
%
% [myield, bembsyld] = mbsyield(Price, Settle, Maturity, IssueDate, ...
%     GrossRate)
%
% [myield, bembsyld] = mbsyield(Price, Settle, Maturity, IssueDate, ...
%     GrossRate, CouponRate, Delay, PrepaySpeed)
%
% [mbsyld, beyld] = mbsyield(Price, Settle, ...
%     Maturity, IssueDate, GrossRate, CouponRate, Delay, [], PrepayMatrix)
%
% Inputs:
%             Price - NMBSx1 vector of clean price for every 
%                     $100 face of issue.
%                    
%            Settle - NMBSx1 vector of settlement date. 
%                    
%          Maturity - NMBSx1 vector of maturity date.   
%                   
%         IssueDate - NMBSx1 vector of issue date.      
%                     
%         GrossRate - NMBSx1 vector of gross coupon rate, 
%                     in decimal. 
%
% Optional Inputs:
%        CouponRate - NMBSx1 vector of Net Coupon Rate, 
%                     in decimal. 
%                     Default is equal to GrossRate. 
%              
%             Delay - NMBSx1 vector of delay in days.
%   
%       PrepaySpeed - NMBSx1 vector of speed relative to 
%                     PSA standard. PSA standard is 100.
%                     Default is 0 (zero) prepayment speed.
%
%      PrepayMatrix - Customized prepayment vector. A matrix of size 
%                     [max(TermRemaining) x NMBS]. Missing values are
%                     padded with NaNs.  Each column corresponds to each
%                     MBS, and each row corresponds to each month after
%                     settlement. 
%
% Outputs:
%            myield - Yield to maturity of MBS, or mortgage yield. 
%                     This yield is compounded monthly (12 times a year).
%
%          bembsyld - The corresponding Bond equivalent yield of MBS. 
%                     This yield is compounded semiannually (2 times a year).
%
%
% Example:
% Price = 102;
% Settle    = datenum('15-Apr-2002');
% Maturity  = datenum('01 Jan 2030');
% IssueDate = datenum('01-Jan-2000');
% GrossRate = 0.08125;
% CouponRate = 0.075;
% Delay = 14;
% Speed = 100;
%
% [mbsyld, beyld] = mbsyield(Price, Settle, ...
%       Maturity, IssueDate, GrossRate, CouponRate, Delay, Speed)
%
% Note: This function is PSA compliant. 
%       Reference: PSA Uniform Practices, SF-49

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.6.6.4 $  $Date: 2004/04/06 01:08:59 $

if nargin > 9
    error('finfixed:mbsyield:invalidMoreInputs','Too many input arguments. Type "help mbsyield" for information.')
end


if nargin < 5
    error('finfixed:mbsyield:invalidLessInputs','Need at least Price, Settle, Maturity, IssueDate, and GrossRate')
else
    Price     = varargin{1};
    Settle    = datenum(varargin{2});
    Maturity  = datenum(varargin{3});
    IssueDate = datenum(varargin{4});
    GrossRate = varargin{5}(:);
    if any(IssueDate > Settle)
        error('finfixed:mbsyield:invalidSettle',['Settle must be at, or after IssueDate.', sprintf('\n'),...
              'Settle before IssueDate is unsupported at this time']);
    end    
end

if nargin <6 | isempty(varargin{6})
    CouponRate = GrossRate;
else
    CouponRate = varargin{6}(:);
end

if nargin <7 | isempty(varargin{7})
    Delay = 0;
else
    Delay = varargin{7}(:);
end

if nargin == 9;
    customized = 1;
else
    customized = 0;
end

if customized == 1
    if ~isempty(varargin{8})
        error('finfixed:mbsyield:invalidPrepaySpeed',['Cannot use benchmark when supplying ', sprintf('\n') ...
              'customized prepayment CPR - Put ', sprintf('\n') ...
              'empty matrices ([]) for 8th input arguments'])    
    end
        
    % check that prepayment is supplied and not empty.
    if isempty(varargin{9})
        error('finfixed:mbsyield:invalidPrepayMatrix',['Please supply a prepayment (SMM)', sprintf('\n') ...
              'matrix when you do not use benchmarked prepayment'])
    else
        SMMRel = varargin{9};
    end
    
   % Call mbscfamounts to get the Amounts and Time the cash 
   % flows occuring when own prepayment is used
   [Price, Settle, Maturity, IssueDate, GrossRate, ...
            CouponRate, Delay] = ...
         finargsz(1,Price(:), Settle(:), Maturity(:), ...
            IssueDate(:), GrossRate(:), CouponRate(:), Delay(:));
   
   [CFlowAmounts dummy TFactor Factor] = ...
       mbscfamounts(Settle, Maturity, IssueDate, ...
         GrossRate, CouponRate, Delay, [], SMMRel);
else
        
    if nargin < 8 | isempty(varargin{8})
        Speed = 0;
    else
        Speed = varargin{8};
    end
    
    [Price, Settle, Maturity, IssueDate, GrossRate, ...
            CouponRate, Delay, Speed] = ...
         finargsz(1,Price(:), Settle(:), Maturity(:), IssueDate(:), ...
            GrossRate(:), CouponRate(:), Delay(:), Speed(:));
    
    % Call mbscfamounts to get the Amounts and Time the 
    % cash flows occuring when std benchmark used   
    [CFlowAmounts dummy TFactor Factor] = ...
        mbscfamounts(Settle, Maturity, IssueDate, ...
        GrossRate, CouponRate, Delay, Speed);   
 end

% Subtract clean/quoted Price into the accrued interest to get NPV = 0

x0 = 1./(1+CouponRate/12);

CFlowAmounts(:,1) = CFlowAmounts(:,1) - Price/100;
NumCF = size(CFlowAmounts, 2);


options1 = optimset('Display','off');
X = fsolve(@mbsintfun, x0, options1, CFlowAmounts, TFactor, NumCF);

varargout{1} = ( 1./X - 1 ).*12; % Mortgage Yield
varargout{2} = 2*((1+varargout{1}/12).^6 - 1); % BE Yield
varargout{3} = CFlowAmounts;
varargout{4} = TFactor;

function y = mbsintfun(x,CF,TF,b)
% This internal function computes the NPV
% of cash flows. The correct discount will
% sum dcf to zero.

dcf = CF .* x(:, ones(b,1)).^TF;
dcf(isnan(dcf))= 0;
y = sum(dcf,2);
