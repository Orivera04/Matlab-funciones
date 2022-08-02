function Price = intenvprice(RateSpec, IVar)
%INTENVPRICE Price fixed income instruments against a set of zero curve(s).
%   Computes prices for instruments against a set of zero coupon bond
%   rate curve(s). 
%
%   Price = intenvprice(RateSpec, InstSet)
%
%   Inputs:
%     RateSpec - The annualized zero rate term structure for valuation. The 
%     'Rates' field of RateSpec is an NPOINTS x NUMCURVES array of annualized 
%     zero rates.  Type "help intenvset" for information on creating the term 
%     structure.
%
%     InstSet - Variable containing a collection of NINST instruments.
%     Instruments are broken down by type and each type can have
%     different data fields.  
%
%   Outputs:
%     Price - NINST x NUMCURVES matrix of prices of each instrument.  If an 
%     instrument cannot be priced, a NaN is returned in that entry. 
%
%   Notes:
%     INTENVPRICE handles the following instrument types: 'Bond', 'CashFlow',
%     'Fixed', 'Float', 'Swap'.  Type "help instadd" to construct defined types.
%
%     See single-type pricing functions to retrieve pricing information.
%     For example, type "help swapbyzero".
%
%     bondbyzero   - Price bonds by a set of zero curves.
%     cfbyzero     - Price arbitrary cash flows by a set of zero curves.
%     fixedbyzero  - Fixed rate note prices by a set of zero curves.
%     floatbyzero  - Floating rate note prices by a set of zero curves.
%     swapbyzero   - Swap prices by a set of zero curves.
%
%
%   Example:	
%     load deriv
%     instdisp(ZeroInstSet)
%     Price = intenvprice(ZeroRateSpec,ZeroInstSet)
%
%   See also INTENVSENS, INTENVSET, INSTADD, HJMPRICE, HJMSENS.

%   Author(s): P. N. Secakusuma, M. Reyes-Kattar, 3-Jan-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/14 21:40:59 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if (nargin<1) | ~isafin(RateSpec,'RateSpec')
   error('The first argument must be a term structure created using INTENVSET');
end

if (nargin<2) | ~isafin(IVar,'Instruments')
   error('The second argument must be a Financial Instrument Variable')
end

% Find out how many instruments are contained
NumInst = instlength(IVar);

% Find which types are represented in the instrument
TypeList = insttypes(IVar);

% Find number of rate curves:
[NumPts, NCurves] = size(intenvget(RateSpec, 'Rates'));

% Price type-by-type
Price = NaN*ones(NumInst,NCurves);

%-----------------------------------------
% Pricing instruments in portfolio.
%-----------------------------------------
for jType = 1:length(TypeList)
    
   switch TypeList{jType}
   case 'CashFlow'
      % get the required computational field names
      FieldList = instcf;
    
      % add a request for the index
      FieldList = [ {'Index'} ; FieldList ];
  
      % get the data values
      Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
    
      % find where the instruments are in the entire portfolio
      Index = Data{1};
    
      % perform the pricing on Data{2:end}
      TypePrice = cfbyzero(RateSpec, Data{2:end});
    
      % write the prices into the correct places
      Price(Index,:) = TypePrice;
    
   case 'Bond'
      % get the required computational field names
      FieldList = instbond;
    
      % add a request for the index
      FieldList = [ {'Index'} ; FieldList ];
  
      % get the data values
      Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
    
      % find where the instruments are in the entire portfolio
      Index = Data{1};
    
      % perform the pricing on Data{2:end}
      TypePrice = bondbyzero(RateSpec, Data{2:end});
    
      % write the prices into the correct places
      Price(Index, :) = TypePrice;
    
    
   case 'Fixed'
      % get the required computational field names
      FieldList = instfixed;
    
      % add a request for the index
      FieldList = [ {'Index'} ; FieldList ];
  
      % get the data values
      Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
    
      % find where the instruments are in the entire portfolio
      Index = Data{1};
    
      % perform the pricing on Data{2:end}
      TypePrice = fixedbyzero(RateSpec, Data{2:end});
    
      % write the prices into the correct places
      Price(Index, :) = TypePrice;

    
   case 'Float'
      % get the required computational field names
      FieldList = instfloat;
    
      % add a request for the index
      FieldList = [ {'Index'} ; FieldList ];
  
      % get the data values
      Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
    
      % find where the instruments are in the entire portfolio
      Index = Data{1};
    
      % perform the pricing on Data{2:end}
      TypePrice = floatbyzero(RateSpec, Data{2:end});
    
      % write the prices into the correct places
      Price(Index, :) = TypePrice;
    

   case 'Swap'
      % get the required computational field names
      FieldList = instswap;
    
      % add a request for the index
      FieldList = [ {'Index'} ; FieldList ];
  
      % get the data values
      Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
    
      % find where the instruments are in the entire portfolio
      Index = Data{1};
    
      % perform the pricing on Data{2:end}
      TypePrice = swapbyzero(RateSpec, Data{2:end});
    
      % write the prices into the correct places
      Price(Index, :) = TypePrice;
    
    
   otherwise
      % leave NaN for these prices
      warning(['Cannot price instruments of type ' TypeList{jType}]);
   end
   
end

return
