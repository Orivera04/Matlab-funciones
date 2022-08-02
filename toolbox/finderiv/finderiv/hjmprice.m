function [Price, PriceTree] = hjmprice(HJMTree, IVar, Options)
%HJMPRICE Price instruments off an HJM interest rate model.
%   Computes arbitrage free prices for instruments using an interest rate
%   tree created with HJMTREE.  
%
%   Price = hjmprice(HJMTree, InstSet)
%
%   Price = hjmprice(HJMTree, InstSet, Options)
%
%   [Price, PriceTree] = hjmprice(HJMTree, InstSet, Options)
%
% Inputs:
%   HJMTree - Heath-Jarrow-Morton tree sampling a forward rate process.
%             Type "help hjmtree" for information on creating the variable 
%             HJMTree.
%
%   InstSet - Variable containing a collection of NINST instruments.
%             Instruments are broken down by type and each type can have
%             different data fields.
%
%   Options	- Structure created with derivset containing derivatives 
%             pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINST x 1 vector of prices of each instrument at time 0.  
%               The prices are computed by backward dynamic programming on 
%               the interest  rate tree. If an instrument cannot be priced,  
%               a NaN is returned in that entry. 
%
%   PriceTree - Structure containing trees of vectors of instrument prices and 
%               accrued interest, and a vector of observation times for each
%               node. 
%
%               PriceTree.PBush contains the clean prices. 
%               PriceTree.AIBush contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%
% Notes:
%   HJMPRICE handles the following instrument types: 'Bond', 'CashFlow',
%   'OptBond', 'Fixed', 'Float', 'Cap', 'Floor', 'Swap'.  Type 
%   "help instadd" to construct defined types.
%
%   See single-type pricing functions to retrieve state-by-state pricing
%   tree information.  For example, type "help capbyhjm".
%   bondbyhjm    - Price a bond by a hjm tree.
%   swapbyhjm    - Price a swap by a hjm tree.
%   capbyhjm     - Price a cap by a hjm tree.
%   floorbyhjm   - Price a floor by a hjm tree.
%   cfbyhjm      - Price an arbitrary set of cash flows by a hjm tree.
%   fixedbyhjm   - Price a fixed rate note by a hjm tree.
%   floatbyhjm   - Price a floating rate note by a hjm tree.
%   optbndbyhjm  - Price a bond option by a hjm tree.
%
% Example: 
%   load deriv
%   instdisp(HJMInstSet)
%   Price = hjmprice(HJMTree, HJMInstSet)
%
% See also HJMSENS, HJMTREE, INSTADD, INTENVPRICE, INTENVSENS.

%   Author(s): J. Akao, M. Reyes-Kattar 9-Mar-1999
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.16 $  $Date: 2002/04/14 16:37:41 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if (nargin<1) | ~isafin(HJMTree,'HJMFwdTree')
    error('The first argument must be an HJM tree created by HJMTREE');
end

if (nargin<2) | ~isafin(IVar,'Instruments')
    error('The second argument must be a Financial Instrument Variable')
end

% Extract pricing options
if nargin < 3
    Options = derivset;
end

HJMTree = checktree(HJMTree, IVar, Options);

% If any warnings were to come out, they would come from inside
% checktree. Turn off warnings for the rest of the function.
Options = derivset(Options, 'Warnings', 'off');

if nargout>1
    TreeFlag = 1;
else
    TreeFlag = 0;
end

% find out how many instruments are contained
NumInst = instlength(IVar);

% find which types are represented in the instrument
TypeList = insttypes(IVar);

% price type-by-type
Price = NaN*ones(NumInst,1);


if TreeFlag
    % Create a price tree with a place for every instrument
    [NumLevels, NumChild, NumPos, NumStates] = bushshape(HJMTree.FwdTree);
    
    % make a new structure with the final times on the end (NumLevels+1)
    NumPChild = [NumChild(1:end-1), 1, 0];
    NumPStates = [NumStates, NumStates(end)];
    
    PriceBush = mkbush(NumLevels+1, NumPChild, ...
        NumInst*ones(1,NumLevels+1));

    % Accrued interest bush
    AIBush = PriceBush;
end

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
        if TreeFlag
            [TypePrice, TypeTree] = cfbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
        else
            TypePrice = cfbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
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
        if TreeFlag
            [TypePrice, TypeTree] = bondbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
            AIBush    = bushsubasgn(AIBush, Index, TypeTree.AIBush);
        else
            TypePrice = bondbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
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
        if TreeFlag
            [TypePrice, TypeTree] = fixedbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
            AIBush    = bushsubasgn(AIBush, Index, TypeTree.AIBush);
        else
            TypePrice = fixedbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
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
        if TreeFlag
            [TypePrice, TypeTree] = floatbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
            AIBush    = bushsubasgn(AIBush, Index, TypeTree.AIBush);
        else
            TypePrice = floatbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
        
    case 'Cap'
        % get the required computational field names
        FieldList = instcap;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = capbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
        else
            TypePrice = capbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
        
    case 'Floor'
        % get the required computational field names
        FieldList = instfloor;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = floorbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
        else
            TypePrice = floorbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
        
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
        if TreeFlag
            [TypePrice, TypeTree] = swapbyhjm(HJMTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
        else
            TypePrice = swapbyhjm(HJMTree, Data{2:end}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
        
    case 'OptBond'
        % get the required option field names
        % I know that the first field is the underlier reference
        FieldList = instoptbnd;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the option data values
        % Index is 1st
        % Underlier index is 2nd
        Data = instgetcell(IVar, 'Type',TypeList{jType}, 'FieldName',FieldList);
        Index = Data{1};
        
        UnderInd = Data{2};
        if any(isnan(UnderInd))
            % only price where the underlier exists
            warning(['Underlier bond not found for options: ', ...
                    num2str( Index(isnan(UnderInd)) )])
            
            % Throw away data rows for unpriceable options
            for jField = 1:length(Data)
                Data{jField}(isnan(UnderInd),:) = [];
            end
            
            % Throw away unusable index values
            Index(isnan(UnderInd)) = [];
            UnderInd(isnan(UnderInd)) = [];
        end
        
        % get the underlier information for the type 'Bond'
        FieldList = instbond;
        BondData = instgetcell(IVar, 'Index',UnderInd, 'FieldName',FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = optbndbyhjm(HJMTree, Data{3:end}, BondData{:},Options);
            
            % write the tree entries into the PriceBush
            PriceBush = bushsubasgn(PriceBush, Index, TypeTree.PBush);
        else
            TypePrice = optbndbyhjm(HJMTree, Data{3:end}, BondData{:}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
        
    otherwise
        % leave NaN for these prices
        warning(['Cannot price instruments of type ' TypeList{jType}]);
    end
end

if TreeFlag
    PriceTree = classfin('HJMPriceTree');
    PriceTree.PBush = PriceBush;
    PriceTree.AIBush = AIBush;
    PriceTree.tObs = TypeTree.tObs;
end
return

%---------------------------------------------------------------------
function [BushA] = bushsubasgn(BushA, Ind, BushB)
%BUSHSUBSASGN Indexed assignment A(I) = B
%   Assigns contents of BushB to indices in BushA
%

NumLevels = bushshape(BushA);
for iObs = 1:NumLevels,
    BushA{iObs}(Ind,:) = BushB{iObs}(:,:);
end
return 





