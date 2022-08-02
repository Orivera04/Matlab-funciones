function varargout = finargdble(varargin)
%FINARGDBLE Format an argument into a double array of NaN padded rows.
%   Creates an NROWS by MAXCOLS matrix of numbers in which unequal
%   length rows are padded with the entry NaN.  The numbers can be
%   input as doubles or parsed from character strings.  The output rows
%   are taken from the rows of an input matrix, or from the entries of an
%   input cell array. 
%
%   [DbleMat] = finargdble(NumericArg)
%   [DbleMat] = finargdble(StringArg)
%   [DbleMat] = finargdble(CellArg)
%
%   Inputs:
%     NumericArg - NROWSxMAXCOLS class double array of numbers.
%
%     StringArg - NROWSxSTRLEN character array of numbers.  Individual
%     numbers are parsed by STR2DOUBLE.  Numbers containing spaces are
%     not supported.  A row may contain several numbers which will be
%     placed into separate columns.  Invalid values are represented by
%     NaN. 
%
%     CellArg - NROWSx1 cell array containing double or character
%     matrices.  Each cell is processed as a single row.  Multiple
%     entries in the cell are laid out into separate columns.  Empty
%     cells or invalid strings are represented by NaN.
%
%   Outputs:
%     DbleMat - NROWSxMAXCOLS class double array of numbers.  MAXCOLS is
%     the maximum number of numbers found in any row.  Shorter rows are
%     padded with NaN's to fill the matrix.  An empty input creates a
%     single NaN output, while an unrecognized type creates an empty
%     output.  
%
%   Examples:
%     Arg = { 38, 'NULL', 45, NaN, 27, [], 58 }
%     Darg = finargdble(Arg)
%     Darg =
%         38
%        NaN
%         45
%        NaN
%         27
%        NaN
%         58
%
%     Arg = { '14.5', '1e2', '28' }
%     Darg = finargdble(Arg)
%     Darg =
%        14.5000
%       100.0000
%        28.0000
%
%     Arg = { [1 2], [1], [1 2 3] }    
%     Darg = finargdble(Arg)
%     Darg =
%          1     2   NaN
%          1   NaN   NaN
%          1     2     3
%          
%   See also FINARGCAT, STR2DOUBLE, NUM2STR, NUM2CELL, FINARGDATE, FINARGCHAR.

%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:39:01 $

varargout = cell(1,nargin);

%  ArgDNum [N x 1]     output serial date number vector
%  IndDble [NDble x 1] locations in outputs of double inputs
%  ArgDble [NDble x 1] cells of double input values
%  IndChar [NChar x 1] locations in outputs of character inputs
%  ArgChar [NChar x NC] cells of values of character inputs

for iArg = 1:nargin,

  if isempty( varargin{iArg} )
    % change a pure emtpy to a single NaN
    varargout{iArg} = NaN;
    
    % Flag to skip finargcat processing
    ArgCells = [];
        
  elseif isa( varargin{iArg} ,'double')
    % Pass double arrays straight through
    varargout{iArg} = varargin{iArg};
    
    % Flag to skip finargcat processing
    ArgCells = [];
        
  elseif isa( varargin{iArg} ,'char')

    % change rows to a set of cells
    varargin{iArg} = cellstr( varargin{iArg} );

    % parse numbers contained in the rows
    DbleArr = str2double( varargin{iArg} );
    
    if ~any( isnan(DbleArr) )
      % Every row was converted
      varargout{iArg} = DbleArr;
      
      % Flag to skip cell processing
      ArgCells = [];
    else
      % Some rows were not converted
      % Put converted rows and NaN's into a cell array
      ArgCells = num2cell(DbleArr);
        
      % save off strings for more processing
      IndChar = find(isnan(DbleArr));
      ArgChar = varargin{iArg}(IndChar);
      
    end
    
  elseif isa( varargin{iArg} ,'cell')
    % Parse into cell string and cell double arguments
  
    % change to a column of cells
    varargin{iArg} = varargin{iArg}(:);
    N = length(varargin{iArg});
    
    % Create space for the output
    ArgCells = cell(N,1);
    ArgCells(:) = {NaN};
  
    % parse row vectors into cells
    IndDble  = find( cellfun('isclass', varargin{iArg}, 'double') & ...
        ( cellfun('prodofsize', varargin{iArg} ) >= 1 ) );
    ArgCells(IndDble) = varargin{iArg}(IndDble);
    
    % make every entry into a row shape
    for Ind = IndDble(:)'
      if ( size(ArgCells{Ind},1) > 1 )
        ArgCells{Ind} = ArgCells{Ind}(:)';
      end
    end
    
    % parse characters 
    IndChar = find( cellfun('isclass', varargin{iArg}, 'char') );
    ArgChar = varargin{iArg}(IndChar);
    
    % make sure matrices are delimited along the rows
    for i = 1:length(ArgChar)
      M = size(ArgChar{i},1);
      if ( M > 1 )
        ArgChar{i}(:,end+1) = ' '*ones(M,1);
        ArgChar{i} = ArgChar{i}';
        ArgChar{i} = ArgChar{i}(:)';
      end
    end

  else
    % unrecognized input argument type
    varargout{iArg} = [];
    
    % Flag to skip finargcat processing
    ArgCells = [];
    
  end % parsing which could have created cells
  
  if ~isempty(ArgCells)
    
    if ~isempty(IndChar)
      
      % Try to translate any single cells
      DbleArr = str2double( ArgChar );
      
      % Assign any translated cells (or NaN if not translated)
      ArgCells( IndChar ) = num2cell(DbleArr);
      
      % Find which characters were not translated
      IndChar = IndChar(isnan(DbleArr));
      ArgChar = ArgChar(isnan(DbleArr));
      
      % Try to tokenize remaining cells
      for i = 1:length(IndChar)
        
        % Accumulate tokens over the rows into a row vector
        DbleArr = [];
        for j = 1:size(ArgChar{i},1)
          
          [Token, Remains] = strtok( ArgChar{i}(j,:) );
          while ~isempty(Token)
            DbleArr = [DbleArr, str2double(Token)];
            [Token, Remains] = strtok( Remains );
          end
        end % loop over rows of the character argument
        
        if isempty(DbleArr)
          % make the row entry a single NaN if all whitespace
          DbleArr = NaN;
        end
        
        % Assign the row to the cell
        ArgCells{IndChar(i)} = DbleArr;
              
      end % loop over tokenized character cells
      
    end % character cell processing  
    
    % pad with NaN's and pack into a matrix
    varargout{iArg} = finargcat(1,ArgCells{:});
    
  end % cell processing
  
end % input argument loop

