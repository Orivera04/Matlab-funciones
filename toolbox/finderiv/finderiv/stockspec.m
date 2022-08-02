function StockSpec = stockspec(Sigma, So, DivType, DivAmounts, ExDates)
%STOCKSPEC Specify stock structure.
%
%   [StockSpec] = stockspec(Sigma, AssetPrice)
%   [StockSpec] = stockspec(Sigma, AssetPrice, DividendType, DividendAmounts,...
%                           ExDividendDates)
%
% Inputs:
%   Sigma           - Decimal annual price volatility of underlying security.
%   AssetPrice      - Scalar underlying asset price value at time 0.
%
% Optional Inputs:
%   DividendType      - String. Dividend type must be either "cash" for actual
%                       dollar dividends, "constant" for constant dividend
%                       yield, or "continuous" for continuous dividend yield. 
%                       This function does not handle stock option
%                       dividends.
%   DividendAmounts   - NDIV x 1 vector of cash dividends or constant annualized 
%                       dividend yields, or a scalar representing a continuous 
%                       annualized dividend yield. 
%   ExDividendDates   - NDIV x 1 vector of ex-dividend dates for "cash" and
%                       "constant" dividend types. For "continuous" dividend type 
%                       this argument should be ignored.
%
%  Output:
%     StockSpec - Structure encapsulating the properties of a stock structure.
%                 
% See also INTENVSET, CRRPRICE, CRRTREE

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:50 $

%-------------------------------------
%Checking input arguments
%-------------------------------------

if nargin < 2
    error('finderiv:stockspec:InvalidInputs','Sigma and AssetPrice are required input arguments.')
end

% if nargin < 2
%     AssetPrice = 100;
% end

if nargin < 3
    DivType = [];
    DivAmounts = 0;
    ExDates = [];
end

if nargin == 3
    error('finderiv:stockspec:InvalidInputs','If DividendType is entered, at least DividendAmounts must be entered.')
end


% -------------------------------------------------------------
% Verify Sigma and AssetPrice
if ndims(Sigma) > 2 | length(Sigma)>1 | ~isreal(Sigma) | Sigma > 1 | Sigma < 0
    error('finderiv:stockspec:InvalidSigma','Sigma must be a real number between 0 and 1.')
end

if (ndims(So) > 2 | length(So)>1 | ~isreal(So) | So < 0)
    error('finderiv:stockspec:InvalidAssetPrice','AssetPrice must be a real number greater than zero.')
end        

if nargin > 2 & ~isempty(DivType) % If Dividends were specified
        
    
    % -------------------------------------------
    % Verify Dividend Input Arguments
    DivType  = lower(DivType);    
    DimDivAmounts = size(DivAmounts);
    
    switch DivType
        case 'constant'
            
            if nargin < 5
                error('finderiv:stockspec:MissingDividendInputs',['When DividendType is ' DivType ', DividendAmounts and ExDividendDates must be entered.'])
            end
            
            if(any(DivAmounts < 0))
                error('finderiv:stockspec:InvalidDividendAmounts',['When DividendType is ' DivType ', all dividends in DividendAmounts must be positive.'])
            end
            
            % Turn to serial dates if necessary
            ExDates = finargdate(ExDates);
            
            % Check dimentions
            [NDateRows, NDatesCols] = size(ExDates);
            [NDivRows, NDivCols] = size(DivAmounts);
            
            if(NDatesCols ~= 1)
                error('finderiv:stockspec:InvalidExDividendDates','ExDividendDates must be a scalar or a column vector');
            end
            
            if(NDivCols ~= 1)
                error('finderiv:stockspec:InvalidDividendAmounts','DividendAmounts must be a scalar or a column vector');
            end
            
            % Make sure that there are no more div payments than dates
            if(NDivRows>NDateRows)
                error('finderiv:stockspec:InvalidInputs','There cannot me more dividend payments than dividend payment dates')
            end
            
            % Expand DivAmounts if necessary
            [DivAmounts, ExDates] = finargsz(1, DivAmounts, ExDates);
            
             % Sort by date
            [ExDates, iDx] = sort(ExDates,1);
            DivAmounts = DivAmounts(iDx);
            
        case 'cash'
            
            if nargin < 5
                error('finderiv:stockspec:MissingDividendInputs',['When DividendType is ' DivType ', DividendAmounts and ExDividendDates must be entered.'])
            end
            
            ExDates = finargdate(ExDates);
            DimExDates = size(ExDates);
            
            if length(DimExDates)>2 | length(DimDivAmounts)>2 | ...         % Must be two-dimensional
                    min(DimExDates)~=1 | min(DimDivAmounts) ~= 1         % Must be vectors
                error('finderiv:stockspec:InvalidInputs',['When DividendType is ' DivType ', ExDividendDates and DividendAmounts must be vectors.'])
            end                
            
            if(any(DivAmounts < 0))
                error('finderiv:stockspec:InvalidDividendAmounts',['When DividendType is ' DivType ', all dividends in DividendAmounts must be positive.'])
            end
            
            ExDates = ExDates(:);
            DivAmounts = DivAmounts(:);
            [ExDates, DivAmounts] = finargsz(1, ExDates, DivAmounts);
            
            % Sort by date
            [ExDates, iDx] = sort(ExDates,1);
            DivAmounts = DivAmounts(iDx);

            
        case 'continuous'
            
            if length(DimDivAmounts)>2 | max(DimDivAmounts)~=1  % Must be scalar
                error('finderiv:stockspec:InvalidDividendAmounts',['When DividendType is ' DivType ', DividendAmounts must be a scalar.'])            
            end
            
            if(DivAmounts < 0 | DivAmounts > 1)
                error('finderiv:stockspec:InvalidDividendAmounts','DividendAmounts must be a number between 0 and 1.')
            end
            
            if nargin > 4
                error('finderiv:stockspec:InvalidExDividendDates',['When DividendType is ' DivType ', ExDividendDates must not be entered.'])
            end
            
            ExDates = [];
            
        otherwise
            
            error('finderiv:stockspec:InvalidDividendType','DividendType must be one of ''Continuous'', ''Constant'', or ''Cash''.')
    end                   
end


% Save verified data
StockSpec                = classfin('StockSpec');
StockSpec.Sigma          = Sigma;
StockSpec.AssetPrice     = So;
StockSpec.DividendType   = DivType;
StockSpec.DividendAmounts = DivAmounts;
StockSpec.ExDividendDates   = ExDates;
