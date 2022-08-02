function [MP] = pUpdateToValidNames(MP)
%PUPDATETOVALIDNAMES function to update an mdevproject variable names
%
%  MP = PUPDATETOVALIDNAMES(MP)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/02/09 08:03:45 $ 

% Get the list of data from the project
pSSF = MP.Datalist;
% Does the project have any data that needs changing?
if ~isempty(pSSF)
    % Create an array to hold all the name maps
    nameMaps = cell(size(pSSF));
    % Get all the sweepset pointers
    pOriginalSS = pveceval(pSSF, @dataptr);
    
    pOriginalSS = [pOriginalSS{:}];
    % Make the array unique
    pSS = unique(pOriginalSS);
    % Create a holder for all theses base nameMaps
    ssNameMaps = cell(size(pSS));
    % First update the sweepsets
    [updatedSS, lSSChanged, ssNameMaps] = pveceval(pSS, @pUpdateToValidNames);
    % Then copy into the old locations
    passign(pSS, updatedSS);
    
    % Get the index of the ssNameMap to use for a given ssf
    nameMapIndex = findptrs(pOriginalSS, pSS)';
    % Now update the sweepsetfilters
    [updatedSSF, lSSFChanged, ssfNameMaps] = pvecinputeval(pSSF, @pUpdateToValidNames, ssNameMaps(nameMapIndex));
    % Then copy into the old locations
    passign(pSSF, updatedSSF);
else
    % Define a default namemap with no changes
    ssfNameMaps = {};
end
    
% Lets call the testplan update stuff
pSSFfromTP = children(MP, @DataLinkPtr);
% Arrange these as a pointer array
pSSFfromTP = [pSSFfromTP{:}];
% Get the testplan pointers
pTP = children(MP);
% Are there any testplans that need updateing
if ~isempty(pTP)
    % Remove invalid pointers
    validPtrs = isvalid(pSSFfromTP);
    pTP = pTP(validPtrs);
    pSSFfromTP = pSSFfromTP(validPtrs);
    
    % Get the index order of nameMaps for the testplans
    nameMapIndex = findptrs(pSSFfromTP, pSSF);
    % % Only update where the name map isn't empty
    % lNotEmpty = ~cellfun('isempty', ssfNameMaps(nameMapIndex));
    global DEBUG_MBC_NAMEMAPS;
    if ~isempty(DEBUG_MBC_NAMEMAPS)
        disp('Using the following name maps');
        for i = 1:numel(ssfNameMaps)
            nameMap = ssfNameMaps{i}
        end
    else
        clear('global', 'DEBUG_MBC_NAMEMAPS');        
    end
    % Update the testplans where the name maps aren't empty
    [dummy] = pvecinputeval(pTP, @pUpdateToValidNames, ssfNameMaps(nameMapIndex));
end