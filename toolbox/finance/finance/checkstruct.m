function SourceStructure = checkstruct(SourceStructure, StandFunctionName)
%CHECKSTRUCT Tested Input Structure from Input Structure
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author(s): C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.4 $   $Date: 2002/04/14 21:57:14 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 2)
     error('Too few input arguments!')
end

if (isempty(SourceStructure) & isempty(StandFunctionName))
     error('No empty input arguments to this function are allowed!')
end

if (~isa(SourceStructure, 'struct'))    
     error('SourceStructure must be a structure!')  
end

if (~ischar(StandFunctionName))
     error('StandFunctionName must be a character array!')
end

if (nargin > 2)
     error('Too many input arguments!')
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     
%Check to see if this input bond structure has already been checked; if it 
%has go on to the next structure
if (isfield(SourceStructure, 'CSCheckFlag'))
     if (SourceStructure.CSCheckFlag)
          return
     end
end    


%Make sure that the standard setting function specified is actually a 
%MATLAB function
if (exist(StandFunctionName) ~= 2)
     error(strcat('Specified function ', StandFunctionName,...
          'is not a MATLAB function!'))
else
     [CheckStructure, DefStructure] = feval(StandFunctionName);
end


%Note that the FIELDNAMES function returns a cell array

%Get the field names of the check structure
CheckFNames = fieldnames(CheckStructure);
CharCheckFNames = char(CheckFNames);

%Get the field names from the default structure
DefFNames = fieldnames(DefStructure);

%Get the field names of the input source structure
SourceFNames = fieldnames(SourceStructure);
CharSourceFNames = char(SourceFNames);

%Get the number of field names in the standard structures
NumCheckFNames = length(CheckFNames);
NumDefFNames = length(DefFNames);


%Make sure that both the default and check structures have the same number
%of field names
if (NumCheckFNames ~= NumDefFNames)
     error('Both standard structures must have the same number of field names!')
end


%Loop through all the fields in the CheckStructure structure
for (i = 1 : NumCheckFNames)
     
     %Check to see there is a default value; if there is assign it
     %to the field in SourceStructure
     DefStructContents = getfield(DefStructure, CharCheckFNames(i, :));
     
     %Check to see if each field contained CheckStructure also exists in 
     %SourceStructure
     if (~isfield(SourceStructure, CheckFNames(i, :)))
          
          %If the field doesn't exist in SourceStructure create it and
          %set its value equal to any default specified in DefStructure
          SourceStructure = setfield(SourceStructure , ...
               CharCheckFNames(i, :), DefStructContents);     
     end
     
     %Get the contents of the field in the source structure
     SourceContents = getfield(SourceStructure, CharCheckFNames(i, :));    
          
     %Make sure that there are no nested structures within the source
     %structure
     if (isa(SourceContents, 'struct'))
          error('Input source structure cannot contain nested structures!')
     end
     
     %Check to see if the field in source structure which exists is empty
     if (isempty(SourceContents))
                   
          SourceStructure = setfield(SourceStructure, ...
               CharCheckFNames(i, :), DefStructContents);
          
     end
     
     %See if there are any values contained in the field in CheckStructure
     CheckStructContents = getfield(CheckStructure, CharCheckFNames(i, :));
     
     %CharCheckStructContents = char(CheckStructContents);
     
     
     %Check to see if contents are numeric
     if (isempty(CheckStructContents))
          
          %Break out of loop and go on to next field
          % break
          
     elseif (isa(CheckStructContents , 'double'))
          
          %Check the source contents for a matching type
          if (~isempty(SourceContents) & ~isa(SourceContents, 'double'))
               error(strcat(CharCheckFNames(i, :),...
                    ' field in input structure contains an ',...
                    'illegal value!'))
          end
          
          %Do any numerical argument checking
          
          %Check to see how many elements are contained in the field
          NumElements = length(CheckStructContents);
          
          %If there are three elements and the first element is -inf, then
          %the second two values represent a range
          if ((NumElements == 3) & (CheckStructContents(1) == -inf))
               
               %Set the limits for checking
               LowerLimit = CheckStructContents(2);
               UpperLimit = CheckStructContents(3);
               
               %Check the values in the field against the limits and report
               %any errors
               Ind = any((SourceContents < LowerLimit) |...
                    (SourceContents > UpperLimit));
               if (Ind & ~isempty(SourceContents))
                    
                    error(strcat(CharCheckFNames(i, :),...
                         ' field in input structure contains an ',...
                         'illegal value!'))
               end
               
          %The values represent a discrete list possible values     
          else
               %Check to see if the values in the source structure
               %match any discrete lists of variables contained in
               %the check structure; report any errors
               Ind = setdiff(SourceContents, CheckStructContents);
               if (~isempty(Ind) & ~isempty(CheckStructContents))
                    
                    error(strcat(CharCheckFNames(i, :),...
                         ' field in input structure contains an ', ...
                         'illegal value!'))
               end
                
          end
          
     elseif (isa(CheckStructContents , 'cell') |...
               isa(CheckStructContents, 'char'))
          
          %Check the source contents for a matching type
          if (~isa(SourceContents, 'cell') & ~isa(SourceContents, 'char'))
               error(strcat(CharCheckFNames(i, :),...
                    ' field in input structure contains an ',...
                    'illegal value!'))
          end
          
          %Do string-based argument checking
          
          %Check to see if an infinite number of values is specified
          SourceCell = cellstr(SourceContents);
          CheckCell = cellstr(CheckStructContents);
          
          if ~(strmatch(SourceCell, CheckCell, 'exact'))         
               %See if the value in this field matches and strings in the
               %corresponding field in the CheckStructure structure         
               if (strmatch(SourceContents, CheckStructContents,...
                         'exact'))
                    error(strcat(CharCheckFNames(i, :), 'field', ...
                         ' contains an illegal value!'))
               end
          end
     
          
     else
          
          error('Check structure contains an illegal data type!')
     end
               
end %end FOR loop over all fields in this structure

SourceStructure.CSCheckFlag = 1;


