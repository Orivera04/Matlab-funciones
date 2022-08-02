function model = checkhmmprof(model)
%CHECKHMMPROF Validates a HMM profile model.
%   
%   CHECKHMMPROF(STRUCTURE) returns a valid HMM profile model or errors out 
%   if the model can not be validated.
%
%   The function actualizes a HMM profile model saved on R13 into R14 valid 
%   models by initializing the fields LoopX and NullX to their default
%   values if they are not present in the input structure.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/01 15:58:52 $

% model must be an structure
if ~isstruct(model)
    error('Bioinfo:ModelIsNotAStructure','HMM must be a structure')
end

% not allowing arrays of structures
if numel(model)>1
    model=model(1);
    warning('Bioinfo:NoMultipleModels', ...
            ['The input structure contains multiple models.\n',...
             '%s will only work with the first model'],...
             upper(evalin('caller','mfilename')))
end    

% look for the minimum required fields
fieldKeys = {'ModelLength','Alphabet','MatchEmission','InsertEmission',...
             'NullEmission','BeginX','MatchX','InsertX','DeleteX',...
             'FlankingInsertX','LoopX','NullX'};
missingFields = ~ismember(fieldKeys,fieldnames(model));
if any(missingFields(1:10))
    error('Bioinfo:NoValidModel',...
          'Not valid structure, some required fields are missing.')
end

% checking missing fields not used in R13 and initializing to defaults
if missingFields(11)
    warning('Bioinfo:LoopXMissingInModel',...
        'LoopX field missing in the model, initializing to default values.')
    model.LoopX = [0.5 0.01; 0.5 0.99];
end
if missingFields(12)
    warning('Bioinfo:NullXMissingInModel',...
        'NullX field missing in the model, initializing to default values.')
    model.NullX = [0.01; 0.99];
end
