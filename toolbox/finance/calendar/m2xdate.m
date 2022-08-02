function DateNumber = m2xdate(MATLABDateNumber, Convention)
%M2XDATE MATLAB Serial Date Number Form to Excel Serial Date Number Form
%
%   DateNumber = m2xdate(MATLABDateNumber, Convention)
%
%   Summary: This function converts serial date numbers from the MATLAB
%            serial date number format to the Excel serial date number format.
%
%   Inputs: MATLABDateNumber - Nx1 or 1xN vector of serial date numbers in
%           MATLAB serial date number form
%           Convention - Nx1 or 1xN vector or scalar flag value indicating
%           which Excel serial date number convention should be used when
%           converting from MATLAB serial date numbers; possible values are:         
%           a) Convention = 0 - 1900 date system in which a serial date
%                number of one corresponds to the date 31-Dec-1899 (default)
%           b) Convention = 1 - 1904 date system in which a serial date
%                number of zero corresponds to the date 1-Jan-1904
%
%   Outputs: Nx1 or 1xN vector of serial date numbers in Excel serial date
%            number form
% 
%   Example: StartDate = 729706
%            Convention = 0;
%
%            EndDate = m2xdate(StartDate, Convention);
%
%            returns:
%
%            EndDate = 35746
%
%   See also M2XDATE.


%Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.8 $   $Date: 2002/04/14 21:49:08 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Convert date strings to serial date numbers if necessary
if (any(ischar(MATLABDateNumber)))
     MATLABDateNumber = datenum(MATLABDateNumber);
end


%Check the number of arguments in and set defaults
if (nargin < 2)
     Convention = zeros(size(MATLABDateNumber));
end


%Make sure input date numbers are positive
if ((MATLABDateNumber <= 0))
     error('Numeric inputs must be positive!')
end


%Do any needed scalar expansion on the the convention flag and parse
if ((size(Convention) ~= size(MATLABDateNumber)) & (max(size(Convention)) ~= 1))
     error('Convention flag must be the same size as date number vector or scalar!')
elseif (length(Convention(:)) == 1)
     Convention = Convention * ones(size(MATLABDateNumber));
end

if (any(Convention ~= 0 & Convention ~= 1))
     error('Invalid convention flag specified!')
end


%Get the shape of the input for later reshaping of the output
[RowSize, ColumnSize] = size(MATLABDateNumber);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set conversion factor for both date systems
%1900 date system
X2MATLAB1900 = 693960;


%1904 date system
X2MATLAB1904 = 695422;


%Convert to the MATLAB serial datenumber format
X1900Ind = find(Convention == 0);
if (~isempty(X1900Ind))
     Temp(X1900Ind) = MATLABDateNumber(X1900Ind) - X2MATLAB1900;
end

X1904Ind = find(Convention == 1);
if (~isempty(X1904Ind))
     Temp(X1904Ind) = MATLABDateNumber(X1904Ind) - X2MATLAB1904;
end


%Reshape the output
DateNumber = reshape(Temp, RowSize, ColumnSize);

%end of MDATE2XDATE function

