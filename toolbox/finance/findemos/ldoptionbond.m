function IBond = ldoptionbond()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 0000/00/00 00:00:00


%Set the output variable initially to an empty matrix
IBond = [];

ErrorFlag = 0;

%Make sure that no error message is displayed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
EditErrorMsgHandle = findobj(gcbf, 'Tag', 'EditBondErrorMessage');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
ErrorMessage = '';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
set(EditErrorMsgHandle, 'String', ErrorMessage);
drawnow;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
%Get the file location, name and the name of the bond                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
FileLocHandle = findobj(gcbf, 'Tag', 'EditBondFileLocation');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
FileLocString = get(FileLocHandle, 'String');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
FileNameHandle = findobj(gcbf, 'Tag',  'EditBondFileName');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
FileNameString = get(FileNameHandle, 'String');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
BondNameHandle = findobj(gcbf, 'Tag', 'EditBondName');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
BondNameString = get(BondNameHandle, 'String');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
%Build the absolute file name from the data                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
AbsFileName = strcat(FileLocString, FileNameString);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
%Set the bond type explicity                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
BondType = 'optionbond';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

%Build the main command string                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
CommandString = [ 'IBond = ldinststruct(BondNameString,' ...                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ' BondType, AbsFileName);'];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
%Set a new error message in case of a failure                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
ErrorMessage = 'File not found or bond invalid!';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
CatchString = ['ErrorFlag = 1;'];
eval(CommandString, CatchString);

if (ErrorFlag)
     set(EditErrorMsgHandle, 'String', ErrorMessage);
     drawnow;
else
     %Close the GUI
     close(gcbf);
end


function OutputInstrument = ldinststruct(InstrumentName, InstrumentType, ...
     FileName)

%Check the number of arguments in
if (nargin < 3)
     error('Too few input arguments specified!')
end

if (isempty(InstrumentName) | isempty(InstrumentType) | isempty(FileName))
     error('InstrumentName, InstrumentType and FileName cannot be empty!')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                ************* GENERATE OUTPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Make sure that file name is an existing file
if (~exist('FileName'))
     error('File does not exist!')
     return
end



%Load the specified file
SourceStruct = load(FileName);

StructFieldNames = fieldnames(SourceStruct);
CharFieldNames = char(StructFieldNames);

if ~(strmatch(InstrumentName, StructFieldNames, 'exact'))
     error('Structure with the curve name specified does not exist in file!')
end

NumFields = length(StructFieldNames);

ExtractCheck = zeros(NumFields, 1);

for (i = 1 : NumFields)
     
     if (strcmp(CharFieldNames(i,:), InstrumentName))
          
          %Extract the structure from the source structure
          OutputInstrument = deal(getfield(SourceStruct, CharFieldNames(i,:)));
          
          ExtractCheck(i) = 1;

     end
end

%Check to see if the sought structure was found
Ind = find(ExtractCheck == 1);
if (isempty(Ind))
     error('Specified structure not found!')
end


%Check the insturment
switch (InstrumentType)
case 'optionbond'
         
     %Call check function for zero curves
     OutputInstrument = checkbond(OutputInstrument);
     
otherwise
          
     error('Unknown instrument type specified!')
end


%end of LDINSTSTRUCT function
