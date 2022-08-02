function ConSet = portcons(varargin)
% PORTCONS Generates a matrix of constraints for a portfolio
%   of asset investments by using linear inequalities. The 
%   inequalities are of the type A*Wts' <= b, where Wts is the 
%   matrix of weights. The matrix ConSet is defined as 
%   ConSet = [A b].
%
%   ConSet = portcons('ConstType', Data1, ..., DataN) creates a matrix 
%   ConSet, based on the constraint type ConstType, and the constraint 
%   parameters Data1, ..., DataN. See below for a list of constraint 
%   types and their corresponding constraint parameters.
%   
%   ConSet = portcons('ConstType1', Data11, ..., Data1N, 'ConstType2', Data21, ..., Data2N, ...) 
%   creates a matrix ConSet, based on the on the constraint types ConstTypeN, 
%   and the corresponding constraint parameters DataN1, ..., DataNN. See 
%   below for a list of constraint types and their corresponding constraint 
%   parameters.
%
%   Constraint types and corresponding constraint data:
%
%     Constraint type: 'Default'
%     All allocations are >= 0; no short selling is allowed. The combined
%     value of the portfolio allocations is normalized to 1.
%
%     Constraint data: NumAssets (required)
%     NumAssets is a scalar representing the number of assets in the 
%     portfolio.
%
%
%     Constraint type: 'PortValue'
%     Require the total value of the portfolio to be fixed to PVal.
%
%     Constraint data: PVal (required), NumAssets(required)
%     PVal is a scalar representing the total value of the portfolio.
%     NumAssets is a scalar representing the number of assets in the portfolio.
%     See the function PCPVAL for more information.
%     
%
%     Constraint type: 'AssetLims'
%     Specify the minimum and maximum allocation per asset.
%
%     Constraint data: AssetMin (required), AssetMax (required), NumAssets (optional)
%     AssetMin is a scalar or vector of length NASSETS, specifying the  
%     minimum allocation per asset.
%     AssetMax is a scalar or vector of length NASSETS, specifying the  
%     maximum allocation per asset.
%     NumAssets is a scalar representing the number of assets in the portfolio.
%     See the function PCALIMS for more information.     
% 
%     
%     Constraint type: 'GroupLims'
%     Specify minimum and maximum allocations to groups of assets.
%
%     Constraint data: Groups (required), GroupMin (required), GroupMax (required)
%     Groups  is an NGROUPS by NASSETS matrix, specifying which assets 
%     belong to each group.
%     GroupMin is a scalar or a vector of length NGROUPS, specifying  
%     the minimum combined allocations in each group.
%     GroupMax is a scalar or a vector of length NGROUPS, specifying  
%     the maximum combined allocations in each group.
%     See the function PCGLIMS for more information.     
%
%
%     Constraint type: 'GroupComparison' 
%     Specify the asset group-to-group comparison constraints. 
%
%     Constraint data: GroupA (required), AtoBmin (required), AtoBmax (required), GroupB (required)
%     GroupA and GroupB are NGROUPS by NASSETS matrices, specifying the 
%     groups to compare.
%     AtoBmin is a scalar or a vector of length NGROUPS, specifying the  
%     minimum ratios of allocations in group A to allocations in group B.
%     AtoBmax is a scalar or a vector of length NGROUPS, specifying the  
%     maximum ratios of allocations in group A to allocations in group B.
%     See the function PCGCOMP for more information.
%
%
%     Constraint type: 'Custom'
%     Custom linear inequality constraints A*Wts' <= b.  
%
%     Constraint data: A (required), b (required)
%     A is an NCONSTRAINTS by NASSETS matrix, specifying the weights for 
%     each asset in each inequality equation.
%     b is a vector of length NCONSTRAINTS, specifying the right hand sides  
%     of the inequalities.
%
%
%   See also PORTOPT, PCPVAL, PCGLIMS, PCGCOMP, PCALIMS
%

%   Author(s): M. Reyes-Kattar, J. Akao,  03/22/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $   $ Date: 1998/01/30 13:45:34 $

% Find the types in the argument list
TypeIndex  = [];
for i=1:nargin
   if(ischar(varargin{i}))
      TypeIndex  = [TypeIndex i];  % Create a vector with the positions (indexes) of 
   end                             %the types within varargin
end

NumTypes = length(TypeIndex);
if(NumTypes == 0)
   error('No types found in the input list');
end


% TypeIndex contains the index (in varargin) to each type. Now, for each type, 
% check its value and call the appropriate function to generate its corresponding 
% ConSet. Then, concatenate as we move through the cell array.
ConSet=[];
for i=1:NumTypes
   
   % Find the number of data arguments passed for this type
   if(i == NumTypes)
      NumArgs = nargin - TypeIndex(i); % We are looking at the last type in varargin
   else
      NumArgs = TypeIndex(i+1) - TypeIndex(i) - 1;
   end
   
   switch(lower(varargin{TypeIndex(i)}))
   case 'default'
      % Make sure that one data argument is being passed in.
      if(NumArgs < 1)
         error('Type "Default" requires at least one data argument.')
      end      
      
      PcpvalConSet = pcpval(1, varargin{TypeIndex(i)+1});
   	PcalimsConSet = pcalims(0, NaN, varargin{TypeIndex(i)+1});
   
      % Make sure that the number of columns is adequate for concatenation.
		if(isempty(ConSet))   
         ConSet = [PcpvalConSet; PcalimsConSet];               
      else
         if(size(ConSet,2) == size(PcpvalConSet,2) & size(ConSet,2) == size(PcalimsConSet,2))
            ConSet = [ConSet; PcpvalConSet; PcalimsConSet];
         else
            error('Number of assets implied in type "Default" is not consistent.');
         end   
      end         
      
      
   case 'assetlims'
      % Make sure that at least one data argument is passed in.
      if(NumArgs < 1)
         error('Type "AssetLims" requires at least one data argument.')
      end
      
      if(NumArgs == 1)
         PcalimsConSet = pcalims(varargin{TypeIndex(i)+1});
      elseif(NumArgs == 2)
         PcalimsConSet = pcalims(varargin{TypeIndex(i)+1:TypeIndex(i)+2});
      elseif (NumArgs == 3)
         PcalimsConSet = pcalims(varargin{TypeIndex(i)+1:TypeIndex(i)+3});
      else
         warning('More than three data arguments passed to type "AssetLims".');
      end
      
 		% Make sure that the number of columns is adequate for concatenation. 
      if(isempty(ConSet))   
         ConSet = PcalimsConSet;               
      else
         if(size(ConSet,2) == size(PcalimsConSet,2))
            ConSet = [ConSet; PcalimsConSet];
         else
            error('Number of assets implied in type "AssetLims" is not consistent.');
         end   
      end  
      
      
   case 'portvalue'
      % Make sure that at least two data arguments are passed in.
      if(NumArgs < 2)
         error('Type "PortValue" requires two data arguments');
      end
      
      PcpvalConSet = pcpval(varargin{TypeIndex(i)+1:TypeIndex(i)+2});
      
 		% Make sure that the number of columns is adequate for concatenation. 
      if(isempty(ConSet))   
         ConSet = PcpvalConSet;               
      else
         if(size(ConSet,2) == size(PcpvalConSet,2))
            ConSet = [ConSet; PcpvalConSet];
         else
            error('Number of assets implied in type "PortValue" is not consistent.');
         end   
      end  
      
      
	case 'grouplims'
      % Make sure that at least three data arguments are passed in
      if(NumArgs < 3)
         error('Type "GroupLims" requires three data arguments.');
      end  
      
      PcglimsConSet = pcglims(varargin{TypeIndex(i)+1:TypeIndex(i)+3});
      
     	% Make sure that the number of columns is adequate for concatenation. 
      if(isempty(ConSet))   
         ConSet = PcglimsConSet;               
      else
         if(size(ConSet,2) == size(PcglimsConSet,2))
            ConSet = [ConSet; PcglimsConSet];
         else
            error('Number of assets implied in type "GroupLims" is not consistent.');
         end   
      end  
      
      
   case 'groupcomparison'
      % Make sure that at least four data arguments are passed in
      if(NumArgs < 4)
         error('Type "GroupComparison" requires four data arguments.');
      end   
      
      PcgcompConSet = pcgcomp(varargin{TypeIndex(i)+1:TypeIndex(i)+4});
      
      % Make sure that the number of columns is adequate for concatenation. 
      if(isempty(ConSet))   
         ConSet = PcgcompConSet;               
      else
         if(size(ConSet,2) == size(PcgcompConSet,2))
            ConSet = [ConSet; PcgcompConSet];
         else
            error('Number of assets implied in type "GroupComparison" is not consistent.');
         end   
      end  
      
      
   case 'custom'
      % Make sure that at least two data arguments are passed in
      if(NumArgs < 2)
         error('Type "Custom" requires two data arguments');
      end
      
      A = varargin{TypeIndex(i)+1};
      b = varargin{TypeIndex(i)+2};
      b = b(:);
      
      if(length(b) ~= size(A,1))
         error('Number of elements in b must correspond to number of rows in A.');
      end
      
      NewConSet = [A b];
      
      % Make sure that the number of columns is adequate for concatenation. 
      if(isempty(ConSet))   
         ConSet = NewConSet;               
      else
         if(size(ConSet,2) == size(NewConSet,2))
            ConSet = [ConSet; NewConSet];
         else
            error('Number of assets implied in type "Custom" is not consistent.');
         end   
      end  

                  
   otherwise
      warning(['Type "' varargin{TypeIndex(i)} '" not recognized. Ignoring it.']);
   end
end


