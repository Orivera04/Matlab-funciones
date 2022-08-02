function varargout = finargdate(varargin)
%FINARGDATE Format an argument into a matrix of serial dates
%   Creates an NROWS by MAXCOLS matrix of serial dates in which unequal
%   length rows are padded with the entry NaN.  The date entries can be
%   input in serial date or character form.  The output rows are taken
%   from the rows of an input matrix, or from the entries of an input
%   cell array. 
%   
%   [DateNums] = finargdate(DateNumArg)
%   [DateNums] = finargdate(DateStrArg)
%   [DateNums] = finargdate(CellArg)
%
%   Inputs:
%     DateNumArg - NROWSxMAXCOLS matrix of serial date numbers.
%
%     DateStrArg - NROWSxNCHAR character array of date strings.  For a
%     description of possible date formats, type "help datestr".  Formats
%     which include the time are not supported.  A row may contain
%     several dates which will be placed into separate columns.  Strings
%     which are not recognized as dates are represented by NaN.
%
%     CellArg - NROWSx1 cell array containing serial date or character
%     matrices.  Each cell is processed as a single row.  Multiple
%     entries in the cell are laid out into separate columns.  Empty cells
%     or unrecognized date strings are represented by NaN.
%
%   Outputs:
%     DateNums - NROWSxMAXCOLS matrix of serial date numbers.  MAXCOLS is
%     the maximum number of dates found in any row.  Shorter rows are
%     padded with NaN's to fill the matrix.  An empty input creates a
%     single NaN output, while an unrecognized type creates an empty
%     output.  Type "datedisp(DateNums)" to view the output as strings.
%
%   Examples:
%     DateNumArg = [
%        730135      730316      730500
%        730166      730347         NaN ]
%     DateNums = finargdate(DateNumArg)
%       DateNums =
%           730135      730316      730500
%           730166      730347         NaN
%
%     DateStrArg = ['10/22/99'; '        '; '03/15/01']
%     DateNums = finargdate(DateStrArg)
%       DateNums =
%           730415
%              NaN
%           730925
%
%     CellArg = { 730135 ; 'NULL' ; '10/22/99  03/15/01' }
%     DateNums = finargdate(CellArg)
%        DateNums =
%            730135         NaN
%               NaN         NaN
%            730415      730925
%
%   See also DATENUM, DATESTR, DATEDISP, FINARGCHAR, FINARGDBLE.

%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $  $Date: 2002/04/14 21:38:58 $

%   Right now, datenum does not parse out bad characters

varargout = cell(1,nargin);

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
    
    try
      % Try to parse straight with datenum
      varargout{iArg} = datenum(varargin{iArg});
      
      % Flag to skip finargcat processing
      ArgCells = [];
      
    catch
      % Break into cells for further processing

      % Clear indicies
      IndDble = [];
      IndChar = [];
      
      % Make character cell arguments
      N = size(varargin{iArg},1);
      IndChar = (1:N)';
      ArgChar = cellstr( varargin{iArg} );
      
      % Create space for the output
      ArgCells = cell(N,1);
      ArgCells(:) = {NaN};
      
    end
    
  elseif isa( varargin{iArg} ,'cell')

    % Parse into character and double arguments 
    % Return IndDble, ArgDble, IndChar, ArgChar
    
    % Clear indicies
    IndDble = [];
    IndChar = [];
    
    % change to a column of cells
    varargin{iArg} = varargin{iArg}(:);
    N = length(varargin{iArg});
    
    % Create space for the output
    ArgCells = cell(N,1);
    ArgCells(:) = {NaN};
    
    % parse characters 
    IndChar = find( cellfun('isclass', varargin{iArg}, 'char') );
    ArgChar = varargin{iArg}(IndChar);
    
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
    
  else
    % unrecognized input argument type
    varargout{iArg} = [];
    
    % Flag to skip finargcat processing
    ArgCells = [];
        
  end % parsing which could have created cells
    
  if ~isempty(ArgCells)
    
    if ~isempty(IndChar)
      % parse out empty cell entries now: they map to a NaN row
      MaskCharDone = cellfun('isempty', ArgChar);
      IndChar(MaskCharDone) = [];
      ArgChar(MaskCharDone) = [];
    end
  
    if ~isempty(IndChar)
      
      try
        % try to translate single dates per string cell
        % change to character array for datevec revision: 1.20
        % ditch char() for datevec revision: 1.21
        % rely on all-blank row causing an error
        ArgDNum = datenum( char(ArgChar) );
        ArgCells(IndChar) = num2cell(ArgDNum);
        
      catch
        % try to parse the entries 1 row cell at a time
        MaskCharDone = false(size(IndChar));
        for i = 1:length(IndChar)
          try
            % try to translate the row with a single call to datenum
            ArgCells{IndChar(i)} = datenum( ArgChar{i} );

            % enforce row shape in the date number
            ArgCells{IndChar(i)} = ArgCells{IndChar(i)}(:)';

            MaskCharDone(i) = true;
          end
        end
        
        % try to tokenize the remaining cells
        IndChar(MaskCharDone) = [];
        ArgChar(MaskCharDone) = [];
        for i = 1:length(IndChar)
          
          % Accumulate tokens over the rows into a row vector
          ArgDNum = [];
          for j = 1:size(ArgChar{i},1)
          
            [Token, Remains] = strtok( ArgChar{i}(j,:) );
            while ~isempty(Token)
              try
                ArgDNum = [ArgDNum, datenum( Token )];
              catch
                ArgDNum = [ArgDNum, NaN];
              end
              [Token, Remains] = strtok( Remains );
            end
              
          end % loop over rows of the character argument
          
          if isempty(ArgDNum)
            % make the row entry a single NaN if all whitespace
            ArgDNum = NaN;
          end
          
          % Assign the row to the cell
          ArgCells{IndChar(i)} = ArgDNum;
            
        end % loop over non-single-date cells
        
      end % catch of any non-single-date cells
    end % character processing
    
    % pad with NaN's and pack into a matrix
    varargout{iArg} = finargcat(1, ArgCells{:});
  end
    
end % argument loop

        
    
  
    
