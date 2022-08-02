function TableChar = instdisp(Inst)
%INSTDISP Tabular display of instruments stored in a variable.
%   Creates a character array displaying the contents of an instrument
%   collection variable, InstSet.  If INSTDISP is called without output
%   arguments, the table is displayed to the command window.
%
%   CharTable = instdisp(InstSet);
%   instdisp(InstSet)
%
%   Input:
%     InstSet - Financial instrument collection variable. Type 
%     "help instaddfield" for examples constructing the variable.
%
%   Output:
%     CharTable - Character array with a table of instruments in InstSet.
%     For each instrument row, the Index and Type are printed along with the
%     field contents. Field headers are printed at the tops of the columns.   
%
%   Example:
%     Display the InstSet variable, ExampleInst, from a data file.  There are
%     3 types of instruments in the variable: 'Option', 'Futures', and 'TBill'.
%
%     load InstSetExamples.mat
%     instdisp(ExampleInst)
%
% 	  Index Type   Strike Price Opt  Contracts
% 	  1     Option  95    12.2  Call     0    
% 	  2     Option 100     9.2  Call     0    
% 	  3     Option 105     6.8  Call  1000    
%      
% 	  Index Type    Delivery       F     Contracts
% 	  4     Futures 01-Jul-1999    104.4 -1000    
%      
% 	  Index Type   Strike Price Opt  Contracts
% 	  5     Option 105     7.4  Put  -1000    
% 	  6     Option  95     2.9  Put      0    
%      
% 	  Index Type  Price Maturity       Contracts
% 	  7     TBill 99    01-Jul-1999    6        
%   
%
%   See also INSTGET, INSTADDFIELD, DATESTR, NUM2STR.

%   Author(s): J. Akao 9-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 21:40:02 $

%-----------------------------------------------------------------
% Checking the input arguments
%-----------------------------------------------------------------
if ( nargin<1 | isempty(Inst) )
  return
end

if ~isafin(Inst, 'Instruments')
  error('The input must be a financial instrument variable')
end

if nargout>0
  TableChar = char(zeros(0,1));
end

%------------------------------------------------------------------
% Convert data fields to string form
%------------------------------------------------------------------
NumType = length(Inst.Type);
for iType = 1:NumType
  NumField = length(Inst.FieldName{iType});
  for jField = 1:NumField,
    
    % convert every data field to string form
    switch Inst.FieldClass{iType}{jField}
     case {'dble', 'curr','index'}
      Inst.FieldData{iType}{jField} = ... 
          num2str( Inst.FieldData{iType}{jField} );
      
      % -----------------------------------------
      % If LegRate or LegReset for a SWAP, do a 
      % little more massaging (reduce number of blank
      % spaces, and add brackets.
      if (strcmpi('swap', Inst.Type{iType}) & ...
              ( strcmpi('LegRate', Inst.FieldName{iType}{jField}) | ...
                strcmpi('LegType', Inst.FieldName{iType}{jField}) | ...
                strcmpi('LegReset', Inst.FieldName{iType}{jField})))
            % reduce the number of blanks to two
            strData = Inst.FieldData{iType}{jField};
            blankPos = find(all(strData == ' ', 1));
            if length(blankPos) > 2
                blankPos = blankPos(3:end);
            else
                blankPos = [];
            end
            strData(:, blankPos) = [];

            % Add brackets to string matrix
            NStrings = size(strData,1);
            strData = [repmat('[', NStrings, 1), strData, repmat(']', NStrings, 1)];
            Inst.FieldData{iType}{jField} = strData;
      end
            
      case 'date'
       Inst.FieldData{iType}{jField} = ... 
           datedisp( Inst.FieldData{iType}{jField} );
    end
  end
end

%------------------------------------------------------------------
% Just read row-by-row for now
%------------------------------------------------------------------
NumInst = length( Inst.IndexTable.TypeI );

LastTypeI = 0;
for i=1:NumInst
  
  % find the location of the next instrument
  iType = Inst.IndexTable.TypeI(i);
  NumField = length(Inst.FieldName{iType});
  kRow = Inst.IndexTable.RowK(i);
  
  if iType~=LastTypeI
    % add a new header
    ColChar = cell(NumField+2,1);
    ColChar(1) = { 'Index' };
    ColChar(2) = { 'Type' };
    ColChar(3:end) = Inst.FieldName{iType};
  end
  
  % add the instrument to the current table
  ColChar{1} = finargcat(1, ColChar{1}, num2str(i));
  ColChar{2} = finargcat(1, ColChar{2}, Inst.Type{iType});
  for jField = 1:NumField,
    ColChar{2+jField} = finargcat(1, ColChar{2+jField}, ...
                                  Inst.FieldData{iType}{jField}(kRow,:) );
  end
    
  
  if ( (i==NumInst) | (iType~=Inst.IndexTable.TypeI(i+1)) )
    % Flush the columns
    
    % add a space (or tab?) to separate each column
    for j=1:length(ColChar)-1
      ColChar{j} = finargcat(2, ColChar{j}, sprintf(' '));
    end
    
    % pack the columns together
    TypeChar = cat(2, ColChar{:});
    
    % display or save
    if nargout>0
      TableChar = finargcat(1, TableChar, TypeChar, ' ' );
    else
      disp(TypeChar);
      disp(' ');
    end
    
  end
  
  LastTypeI = iType;
end

