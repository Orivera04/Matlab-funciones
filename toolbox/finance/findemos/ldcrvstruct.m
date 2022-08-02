function OutputCurve = ldcrvstruct(CurveName, CurveType, FileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 0000/00/00 00:00:00

%Check the number of arguments in
if (nargin < 3)
     error('Too few input arguments specified!')
end

if (isempty(CurveName) | isempty(CurveType) | isempty(FileName))
     error('CurveName, CurveType and FileName cannot be empty!')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                ************* GENERATE OUTPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Make sure that file name is an existing file
if (~exist(FileName))
     error('File does not exist!')
     return
end

%Load the specified file
SourceStruct = load(FileName);

StructFieldNames = fieldnames(SourceStruct);
CharFieldNames = char(StructFieldNames);

if ~(strmatch(CurveName, StructFieldNames, 'exact'))
     error('Structure with the curve name specified does not exist in file!')
end

NumFields = length(StructFieldNames);

ExtractCheck = zeros(NumFields, 1);

for (i = 1 : NumFields)
     
     if (strcmp(CharFieldNames(i,:), CurveName))
          
          %Extract the structure from the source structure
          OutputCurve = deal(getfield(SourceStruct, CharFieldNames(i,:)));
          
          ExtractCheck(i) = 1;

     end
end %end for loop

%Check to see if the sought structure was found
if (~any(ExtractCheck == 1))
     error('Specified structure not found!')
end

%Check the curve
switch (CurveType)
case 'zerocurve'
         
     %Call check function for zero curves
     OutputCurve = checkzerocrv(OutputCurve);
     
case 'volatilitycurve'
     
     %Call check function for volatility curves
     OutputCurve = checkvolcrv(OutputCurve);
     
case 'creditcurve'
     
     %Call check function for credit curves
     OutputCurve = checkcreditcrv(OutputCurve);
     
otherwise
     
     error('Unknown curve type specified!')
end

%end of LDCRVSTRUCT function
