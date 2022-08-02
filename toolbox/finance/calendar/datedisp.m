function outstringmat = datedisp(nmat, dateform)
%DATEDISP Display a matrix with serial date entries formatted as date strings.
%   Given a matrix with mixed numeric entries and serial date number
%   entries, DATEDISP displays the matrix with the serial dates formatted
%   as date strings.  Integers between datenum('01-Jan-1900') and
%   datenum('01-Jan-2200') are assumed to be serial date numbers, while all
%   other values are treated as numeric entries.
%
%   datedisp(NumMat)
%   datedisp(NumMat, DateForm)
%   CharMat = datedisp(NumMat, DateForm)
% 
%   Inputs:
%     NumMat   - Numeric matrix to be displayed.
%     DateForm - Optional date format.  Type "help datestr" for available
%                and default format flags.
% 
%   Outputs: 
%     CharMat  - Character array representing the matrix.  If no output
%     variable is assigned, the function prints the array to the display.
%
%   Example:
%     NumMat = [ 730730, 0.03 , 1200 730100;
%                730731, 0.05 , 1000 NaN ]
%     NumMat =
%         1.0e+05 *
%          7.3073    0.0000    0.0120    7.3010
%          7.3073    0.0000    0.0100       NaN
%
%     datedisp(NumMat)
%      01-Sep-2000   0.03   1200   11-Dec-1998   
%      02-Sep-2000   0.05   1000      NaN        
%
%   See also DATESTR.

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $ $Date: 2002/04/14 21:51:33 $

if (nargin<2)
  dateform = 1;
end

% lookup table for dateform field width
fwidths = [11 8  3  1  2  5  2  3  1  4  2  5  8  11  5  8  5  2];
fieldwidth = fwidths(dateform); % width of date format
fsep = 3; % minimum separation between columns

% find where the probable date entries are: integers between
% datenum('1-Jan-1900') and datenum('1-Jan-2200)
isint = round(nmat)==nmat;                       % mask for integers

mindt = datenum('01-Jan-1900');
maxdt = datenum('01-Jan-2200');
isrange = ( mindt <= nmat ) & ( nmat <= maxdt ); % mask for range

isdate = isint & isrange;                        % mask for date conversion

% process the columns
[Mrows, Ncols] = size(nmat);
strcols = cell(1,Ncols);
for j=1:Ncols,
  if all(isdate(:,j)),
    strcols{j} = datestr(nmat(:,j),dateform);
  else
    % convert the whole column to string of numbers
    strcols{j} = num2str(nmat(:,j));
    
    % overwrite any date entries
    if any(isdate(:,j))

      % pad with spaces to make room for strings if needed
      firstwidth = size(strcols{j},2);
      if ( firstwidth < fieldwidth )
        strcols{j} = [ strcols{j}, ... 
              char( ' '*ones(Mrows, fieldwidth-firstwidth))];
      end
      
      strcols{j}(isdate(:,j),1:fieldwidth) = ... 
          datestr(nmat(isdate(:,j),j), dateform);
    end
  end
  
  %pad the column with spaces
  strcols{j} = [ strcols{j}, char( ' '*ones(Mrows, fsep)) ];
end
            
% form the string matrix from the columns
stringmat = [ strcols{:} ];

if nargout > 0,
  outstringmat = stringmat;
else
  disp(stringmat);
end
    


