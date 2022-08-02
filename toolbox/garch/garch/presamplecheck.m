function [outputArray, messageStructure] = presamplecheck(outputArray, inputName, inputArray, nRows)
%PRESAMPLECHECK Check GARCH Toolbox user-specified pre-sample data for errors.
%   Given the required number of rows (observations) and columns (paths),
%   check user-specified pre-sample data arrays for errors. If errors are
%   found, format and return an error message structure. If no errors are 
%   found, then update the output pre-sample data array with the relevant 
%   pre-sample data and return an empty error string.
%
%   [OutputArray, MessageStructure] = presamplecheck(OutputArray, InputName, 
%     InputArray, nRows)
%
% Inputs:
%   OutputArray - A pre-allocated, pre-sample data matrix. This matrix will
%     have max(R,M,P,Q) rows and a number of columns equal to the number 
%     of sample paths.
%
%   InputName - A character string containing the name of the pre-sample
%     data array being checked for errors. This string is placed into the
%     output error message for additional information if necessary.
%
%   InputArray - The user-specified pre-sample data array to be checked.
%     This must be either a column vector or a matrix with the same 
%     number of columns as OutputArray. In either case, it must have at
%    least 'nRows' rows.
%
%   nRows - The required number of pre-sample observations (i.e., rows).
%
% Outputs:
%   OutputArray - If no errors occur, this will be an updated version of
%     the input array of the same name, in which case the last 'nRows' 
%     rows will contain the required pre-sample data. If an error occurs,
%     it is unchanged.
%
%   MessageStructure - A MATLAB message identifier structure with fields
%     'indentifier' and 'message'. If errors are found, this structure
%     will identify and summarize the error; if no errors are found, this 
%     will be an empty identifier structure.
%
% See also GARCHSIM, GARCHFIT, GARCHINFER.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.1.4.1 $   $Date: 2003/05/08 21:45:39 $

%
% Initialize the message structure.
%

messageStructure.message    = '';  
messageStructure.identifier = 'GARCH:presamplecheck:PreSampleDataError';

%
% Test for errors in the pre-sample data.
%

if size(inputArray,1) < nRows
   if nRows == 1
      messageStructure.message = [' ''' inputName ''' must have at least 1 row.'];
   else
      messageStructure.message = [' ''' inputName ''' must have at least ' int2str(nRows) ' rows.'];
   end
   return          % Exit with an error condition.
end

nColumns  =  size(outputArray,2);

if (size(inputArray,2) ~= 1) & (size(inputArray,2) ~= nColumns)
   if nColumns == 1
      messageStructure.message = [' ''' inputName ''' must be a column vector.'];
   else
      messageStructure.message = [' ''' inputName ''' must be a column vector or a matrix with ' int2str(nColumns) ' columns.'];
   end
   return          % Exit with an error condition.
end

%
% Re-format the error-free pre-sample data.
%

inputArray  =  inputArray((end - nRows + 1):end , :);  % Retain no more rows than necessary.

%
% If the user-specified input pre-sample array is a single 
% column vector, replicate it across all columns (i.e., paths).
%

if size(inputArray,2) == 1
   outputArray((end - nRows + 1):end , :)  =  repmat(inputArray , 1 , nColumns);
else
   outputArray((end - nRows + 1):end , :)  =  inputArray;
end        

%
% Return an empty message structure to indicate no error occurred.
%

messageStructure  =  messageStructure(zeros(0,1));