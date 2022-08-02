function [Price, PriceTree] = bintreeprice(BinStockTree, IVar, o)
%BINTREEPRICE Engine function for crrprice and eqpprice.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-May-2003
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2003/09/22 19:13:58 $

%----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------

% find out how many instruments are contained
NumInst = instlength(IVar);

[IVar, Idx] = checkbintree(BinStockTree, IVar);

if nargout>1
    TreeFlag = 1;
else
    TreeFlag = 0;
end

% find which types are represented in the instrument
TypeList = insttypes(IVar);

% price type-by-type
Price = NaN*ones(NumInst,1);


if TreeFlag
    % Create a price tree with a place for every instrument
    [NumLevels, NumPos] = treeshape(BinStockTree.STree);
    
    % make a new structure with the final times on the end (NumLevels+1)    
    PTree = mktree(NumLevels, NumInst);

end

for jType = 1:length(TypeList)
    switch TypeList{jType}
    case 'Barrier'
        % get the required computational field names
        FieldList = instbarrier;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            if nargin>2
                [TypePrice, TypeTree] = barrierbybintree(BinStockTree, Data{2:end}, o);
            else
                [TypePrice, TypeTree] = barrierbybintree(BinStockTree, Data{2:end});
            end
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Idx(Index), TypeTree.PTree);
        else
            if nargin>2
                TypePrice = barrierbybintree(BinStockTree, Data{2:end}, o);
            else
                TypePrice = barrierbybintree(BinStockTree, Data{2:end});
            end
        end
        
        % write the prices into the correct places
        Price(Idx(Index)) = TypePrice;
        
    case 'Lookback'
        % get the required computational field names
        FieldList = instlookback;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = lookbackbybintree(BinStockTree, Data{2:end});
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Idx(Index), TypeTree.PTree);
        else
            TypePrice = lookbackbybintree(BinStockTree, Data{2:end});
        end
        
        % write the prices into the correct places
        Price(Idx(Index)) = TypePrice;
        
    case 'Compound'
        % get the required computational field names
        FieldList = instcompound;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = compoundbybintree(BinStockTree, Data{2:end});
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Idx(Index), TypeTree.PTree);
        else
            TypePrice = compoundbybintree(BinStockTree, Data{2:end});
        end
        
        % write the prices into the correct places
        Price(Idx(Index)) = TypePrice;
        
    case 'Asian'
        % get the required computational field names
        FieldList = instasian;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = asianbybintree(BinStockTree, Data{2:end});
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Idx(Index), TypeTree.PTree);
        else
            TypePrice = asianbybintree(BinStockTree, Data{2:end});
        end
        
        % write the prices into the correct places
        Price(Idx(Index)) = TypePrice;
        
        
    case 'OptStock'
        % get the required computational field names
        FieldList = instoptstock;
        
        % add a request for the index
        FieldList = [ {'Index'} ; FieldList ];
        
        % get the data values
        Data = instgetcell(IVar, 'Type', TypeList{jType}, 'FieldName', FieldList);
        
        % find where the instruments are in the entire portfolio
        Index = Data{1};
        
        % perform the pricing on Data{2:end}
        if TreeFlag
            [TypePrice, TypeTree] = optstockbybintree(BinStockTree, Data{2:end});
            
            % write the tree entries into the PriceTree
            PTree = treesubasgn(PTree, Idx(Index), TypeTree.PTree);
        else
            TypePrice = optstockbybintree(BinStockTree, Data{2:end});
        end
        
        % write the prices into the correct places
        Price(Idx(Index)) = TypePrice;
        
    otherwise
        % leave NaN for these prices
        warning('finderiv:bintreeprice:InvalidInstrument',['Cannot price instruments of type ' TypeList{jType}]);
    end
end

if TreeFlag
    PriceTree = classfin('BinPriceTree');
    PriceTree.PTree = PTree;
    PriceTree.tObs  = TypeTree.tObs;
    PriceTree.dObs  = TypeTree.dObs;
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

% ----------------------------------------------------------------------
function [IVarClean, Idx] = checkbintree(BinStockTree, IVar)
% Initialize variables

NaNIdx = [];
Idx = [];
% Verify that all instrument date parameters aling with tree nodes

% find which types are represented in the instrument
NInst = instlength(IVar);

for jInst = 1:NInst    
    switch instget(IVar, 'Index', jInst, 'FieldName', {'Type'})
        case {'Barrier', 'Lookback', 'Asian', 'OptStock'}
            % ExerciseDates are the only dates we need to ensure fall on
            % tree nodes
            EDates = instget(IVar, 'Index', jInst, 'FieldName', {'ExerciseDates'});
            
        case 'Compound'
            [UEDates, CEDates] = instget(IVar, 'Index', jInst, 'FieldName', {'UExerciseDates', 'CExerciseDates'});           
            EDates = [UEDates(:) CEDates(:)];
    end
    
    if any( ~ismember(EDates, BinStockTree.dObs(:)))
        % Some exercise dates for this instrument are not aligned with the
        % tree. We have to take it off line after throwing a warning.
        Msg = ['Not all exercise dates of instrument indexed ''%d'' are\n', ...
              'aligned with the dates of the tree. The price for this\n', ...
              'instrument cannot be calculated and it''s corresponding\n', ...
              'row in the Price vectors will be substituted with NaNs.\n', ...
              'Examine the StockTree''s ''dObs'' field to observe the tree\n', ...
              'dates.'];
        warning(sprintf(Msg, jInst));
        
        % Keep score of the original index where the offending stock was:
        NaNIdx = [NaNIdx; jInst];
    else
        Idx = [Idx; jInst];
    end    
end

if ~isempty(NaNIdx)
    IVarClean = instdelete(IVar, 'Index', NaNIdx);
else
    IVarClean = IVar;
end
