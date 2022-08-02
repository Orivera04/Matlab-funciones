function ftsno = ftsnew2old(fts) 
%@FINTS/FTSNEW2OLD converts an FTS object from the Finanacial Time Series
%   Toolbox Version 2.0 to an object compatible with any Finanacial Time
%   Series Toolbox Version 1.0 and 1.1.
%
%   FTSNO = FTSNEW2OLD(FTS) converts the FTS object from a Finanacial Time
%   Series Toolbox Version 2.0 object to an object compatible with version
%   1.0 and 1.1.
%
%   See also @FINTS/FTSOLD@NEW.

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.2 $   $Date: 2002/01/18 21:50:46 $

% NOTE: No need to check for repeated dates or monotonically increasing dates
% due to the fact that these warnings would have been displayed and/or corrected
% if the user chose to do so already. FTS version 2.0 will display these warnings. 

% Check version of the FTS object. If it is = ver 2, convert it to
% a ver 1.0/1.1 object.
[ftsVersion,timeData] = fintsver(fts);

if ftsVersion == 2
    if timeData ~= 0
        % If times exist, cannot convert object
        error('Ftseries:ftsnew2old:CanNotConvertObjectsWithTime', ...
            sprintf(['Objects that contain time information cannot be converted\n', ...
                'to be used with older versions of the Finanacial Time\n', ...
                'Series Toolbox.']));
    else
        % Manually set up partially an old FINTS object (b/c @FINTS/FINTS
        % creates a FTS version 2.0 FINTS object)
        ftsno.names = {'descrip', 'freq', 'dates'};
        ftsno.data  = {'', 0, [], []};
        ftsno.datacount = 0;
        ftsno.serscount = 0;
        
        % Create new object
        ftsno = class(ftsno, 'fints');
        
        % Get/fill series names
        serNames = [fts(:).names];
        serNames(find(getnameidx({'desc', 'freq', 'dates','times'}, serNames))) = '';
        ftsno.names = [ftsno.names serNames];
        
        % Fill the data (all but fts.data{5}, time data)
        for idx = 1:4
            ftsno.data{idx} = fts.data{idx};
        end
        
        ftsno.datacount = fts.datacount;
        ftsno.serscount = fts.serscount;
    end
else
    % Do not convert if its already version 1.0/1.1
    error('Ftseries:ftsnew2old:ObjectIsAlreadyVersion1', ...
        sprintf(['Object is already compatible with any version less than\n', ...
            'Finanacial Time Series Toolbox Version 2.0']));
end

% [EOF]