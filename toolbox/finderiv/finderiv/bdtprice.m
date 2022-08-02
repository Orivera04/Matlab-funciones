function [Price, PriceTree] = bdtprice(BDTTree, IVar, Options)
%BDTPRICE Price instruments off a BDT interest rate model.
%   Computes prices for instruments using an interest rate
%   tree created with BDTTREE.  
%
%   Price = bdtprice(BDTTree, InstSet)
%
%   Price = bdtprice(BDTTree, InstSet, Options)
%
%   [Price, PriceTree] = bdtprice(BDTTree, InstSet, Options)
%
% Inputs:
%   BDTTree - Black-Derman-Toy tree sampling an interest rate process.
%             Type "help bdttree" for information on creating the variable 
%             BDTTree.
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
%               the interest rate tree. If an instrument cannot be priced,  
%               a NaN is returned in that entry. 
%
%   PriceTree - Structure containing trees of vectors of instrument prices and 
%               accrued interest, and a vector of observation times for each
%               node. 
%
%               PriceTree.PTree contains the clean prices. 
%               PriceTree.AITree contains the accrued interest.
%               PriceTree.tObs contains the observation times.
%
% Notes:
%   BDTPRICE handles the following instrument types: 'Bond', 'CashFlow',
%   'OptBond', 'Fixed', 'Float', 'Cap', 'Floor', 'Swap'.  Type 
%   "help instadd" to construct defined types.
%
%   See single-type pricing functions to retrieve state-by-state pricing
%   tree information.  For example, type "help capbybdt".
%   bondbybdt    - Price a bond by a BDT tree.
%   swapbybdt    - Price a swap by a BDT tree.
%   capbybdt     - Price a cap by a BDT tree.
%   floorbybdt   - Price a floor by a BDT tree.
%   cfbybdt      - Price an arbitrary set of cash flows by a BDT tree.
%   fixedbybdt   - Price a fixed rate note by a BDT tree.
%   floatbybdt   - Price a floating rate note by a BDT tree.
%   optbndbybdt  - Price a bond option by a BDT tree.
%
% Example: 
%   load deriv
%   instdisp(BDTInstSet)
%   Price = bdtprice(BDTTree, BDTInstSet)
%
% See also BDTSENS, BDTTREE, INSTADD, INTENVPRICE, INTENVSENS.

%   Author(s): M. Reyes-Kattar 20-June-2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.2 $  $Date: 2002/04/14 16:39:01 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if (nargin<1) | ~isafin(BDTTree,'BDTFwdTree')
    error('The first argument must be a BDT tree created by BDTTREE');
end

if (nargin<2) | ~isafin(IVar,'Instruments')
    error('The second argument must be a Financial Instrument Variable')
end

% Extract pricing options
if nargin < 3
    Options = derivset;
end

BDTTree = checktree(BDTTree, IVar, Options);

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
    [NumLevels, NumPos] = treeshape(BDTTree.FwdTree);
    
    % make a new structure with the final times on the end (NumLevels+1)    
    PTree = mktree(NumLevels+1, NumInst, NaN, 1);

    % Accrued interest bush
    AITree = PTree;
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
            [TypePrice, TypeTree] = cfbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
        else
            TypePrice = cfbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = bondbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
            AITree    = treesubasgn(AITree, Index, TypeTree.AITree);
        else
            TypePrice = bondbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = fixedbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
            AITree    = treesubasgn(AITree, Index, TypeTree.AITree);
        else
            TypePrice = fixedbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = floatbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
            AITree    = treesubasgn(AITree, Index, TypeTree.AITree);
        else
            TypePrice = floatbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = capbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
        else
            TypePrice = capbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = floorbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
        else
            TypePrice = floorbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = swapbybdt(BDTTree, Data{2:end}, Options);
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
        else
            TypePrice = swapbybdt(BDTTree, Data{2:end}, Options);
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
            [TypePrice, TypeTree] = optbndbybdt(BDTTree, Data{3:end}, BondData{:},Options);
            
            % write the tree entries into the PTree
            PTree = treesubasgn(PTree, Index, TypeTree.PTree);
        else
            TypePrice = optbndbybdt(BDTTree, Data{3:end}, BondData{:}, Options);
        end
        
        % write the prices into the correct places
        Price(Index) = TypePrice;
        
        
    otherwise
        % leave NaN for these prices
        warning(['Cannot price instruments of type ' TypeList{jType}]);
    end
end

if TreeFlag
    PriceTree = classfin('BDTPriceTree');
    PriceTree.PTree = PTree;
    PriceTree.AITree = AITree;
    PriceTree.tObs = TypeTree.tObs;
end
return

%---------------------------------------------------------------------
function [TreeA] = treesubasgn(TreeA, Ind, TreeB)
%TREESUBSASGN Indexed assignment A(I) = B
%   Assigns contents of TreeB to indices in TreeA
%

NumLevels = treeshape(TreeA);
for iObs = 1:NumLevels,
    TreeA{iObs}(Ind,:) = TreeB{iObs}(:,:);
end
return 





