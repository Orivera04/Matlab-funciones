function varargout = finargchar(varargin)
%FINARGCHAR Format an argument into a character array.
%   Creates an NROWS by STRLEN character array from an input cell array,
%   numeric ASCII array, or character array.  Any entry which cannot be
%   processed as a string is returned as a row of blanks.  The output
%   rows are taken from the rows of an input matrix, or from the entries
%   of an input cell array.
%
%   [CharMat] = finargchar(StringArg)
%   [CharMat] = finargchar(AsciiArg)
%   [CharMat] = finargchar(CellArg)
%
%   Inputs:
%     StringArg - NROWSxSTRLEN character array.
%
%     AsciiArg - NROWSxSTRLEN class double array of ASCII values.
%
%     CellArg - NROWSx1 cell array containing character or ASCII matrices.
%     Each cell is processed as a single row.  Matrix cells are laid out
%     as a single row delimited by blanks.  Empty cells create a row of blanks. 
%     
%   Output:
%     CharMat - NROWSxSTRLEN character array.  An empty input creates a
%     single blank output, and an invalid type creates an empty output.
%
%   See also CHAR, CELLSTR, DOUBLE, FINARGDATE, FINARGDBLE.

%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:38:53 $

varargout = cell(1,nargin);

%  ArgDNum [N x 1]     output serial date number vector
%  IndDble [NDble x 1] locations in outputs of double inputs
%  ArgDble [NDble x 1] cells of double input values
%  IndChar [NChar x 1] locations in outputs of character inputs
%  ArgChar [NChar x NC] cells of values of character inputs

for iArg = 1:nargin,

  if isa( varargin{iArg} ,'char')
    % Pass character arrays straight through
    varargout{iArg} = varargin{iArg};
    
  else 
    
    % Parse into cell string and cell double arguments 
    % Return IndDble, ArgDble, IndChar, ArgChar
    IndDble = [];
    IndChar = [];
  
    if isa( varargin{iArg} ,'cell')

      % change to a column of cells
      varargin{iArg} = varargin{iArg}(:);
      N = length(varargin{iArg});
    
      % parse characters 
      IndChar = find( cellfun('isclass', varargin{iArg}, 'char') );
      ArgChar = varargin{iArg}(IndChar);
    
      % make every entry into a row shape delimited by blanks
      for i = 1:length(IndChar)
        M = size(ArgChar{i},1);
        if ( M > 1 )
          ArgChar{i}(:,end+1) = ' '*ones(M,1);
          ArgChar{i} = ArgChar{i}';
          ArgChar{i} = ArgChar{i}(:)';
        end
      end
        
      % parse non-empty numbers as cell
      IndDble  = find( cellfun('isclass', varargin{iArg}, 'double') & ...
          ( cellfun('prodofsize', varargin{iArg} ) >= 1 ) );
      ArgDble  = varargin{iArg}(IndDble);
    
      % make every entry into a row shape
      for i = 1:length(IndDble)
        M = size(ArgDble{i},1);
        if ( M > 1 )
          ArgDble{i}(:,end+1) = ' '*ones(M,1);
          ArgDble{i} = ArgDble{i}';
          ArgDble{i} = ArgDble{i}(:)';
        end
      end
        
    elseif isa( varargin{iArg} ,'double')

      % change rows to a set of cells
      varargin{iArg} = num2cell( varargin{iArg} , 2);
      N = length(varargin{iArg});

      IndDble = (1:N)';
      ArgDble = varargin{iArg};
    
    end
    
    % Create space for the output
    ArgCells = cell(N,1);
    ArgCells(:) = {''};
  
    % Assign char entries
    if ~isempty(IndChar)
      ArgCells(IndChar) = ArgChar;
    end
    
    % Convert and assign double entries
    if ~isempty(IndDble)
      for i = 1:length(IndDble)
        % squeeze out NaN's
        ArgDble{i}( isnan(ArgDble{i}) ) = [];
        
        % change ASCII values to characters
        % Allow warnings through
        ArgCells{IndDble(i)} = char(ArgDble{i});
      end
    end
    
    % Convert the cell array of strings to character
    varargout{iArg} = char(ArgCells);
    
  end
end

