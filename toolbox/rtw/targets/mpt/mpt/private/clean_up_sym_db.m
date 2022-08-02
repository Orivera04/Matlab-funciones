function clean_up_sym_db
%CLEAN_UP_SYM_DB will checks and eliminate duplicate symbol names for a file. 
%
%   CLEAN_UP_SYMBOL_DB()
%   This function cleans up the global symbol database, by checking and
%   eliminating any duplicate symbol names for a given chart file.  
%
%   INPUTS:
%         none
%  
%   OUTPUTS:
%         none


%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.12.4.2 $
%   $Date: 2004/03/21 22:57:56 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');

%for each chart file and for each symbol definition
%  check for a duplicate name of an object.
%  
for i=1:length(ecac.file)
    for j=1:length(ecac.file{i}.sinfo)
        if isempty(ecac.file{i}.sinfo{j}.symbolName) == 0
            switch(ecac.file{i}.sinfo{j}.symbolName)
            case {'ExternalCalibrationScalar','ExternalCalibrationLookup1D','ExternalCalibrationLookup2D',...
                  'ExternalVariableScalar','ExternalVariableFlag','ExternalVariableTimer',...
                  'GlobalCalibrationScalar','GlobalCalibrationLookup1D','GlobalCalibrationLookup2D',...
                  'GlobalVariableScalar','GlobalVariableFlag','GlobalVariableTimer',...
                  'FilescopeCalibrationScalar','FilescopeCalibrationLookup1D','FilescopeCalibrationLookup2D',...
                  'FilescopeVariableScalar','FilescopeVariableFlag','FilescopeVariableTimer','StatemachineConstants'}
                name = [];
                
                % Get a list of all names of all objects
                for k=1:length(ecac.file{i}.sinfo{j}.objects)  
                    if isempty(ecac.file{i}.sinfo{j}.objects{k}.name) == 0,
                        name{end+1}=ecac.file{i}.sinfo{j}.objects{k}.name;
                    end
                end
                if ~isempty(name)
                    [namex, IA, IB] = union(name,[]);  %sort, no dups            
                    newObject=[];
                    % Get list of objects that do not have any duplicates.
                    for m=1:length(IA)
                        newObject{m} = ecac.file{i}.sinfo{j}.objects{IA(m)};
                    end
                    ecac.file{i}.sinfo{j}.objects = newObject;
                end
            otherwise
            end
        end
    end
end
rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
