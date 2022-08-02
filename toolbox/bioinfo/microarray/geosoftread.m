function [outputStruct,vals]=geosoftread(geotext)
%GEOSOFTREAD reads in Gene Expression Omnibus SOFT format data files.
%
%   GEODATA = GEOSOFTREAD(FILE) reads in Gene Expression Omnibus (GEO) SOFT
%   format data from FILE and creates a structure GEODATA, containing the
%   following fields:
%       Scope
%       Accession
%       Header
%       ColumnDescriptions
%       ColumnNames
%       Data
%
%   FILE can also be a URL or a MATLAB character array that contains the
%   text of a GEO SOFT format file.
%
%   Example:
%
%       % Get a file from GEO and save it to a file.
%       geodata = getgeodata('GSM3258','TOFILE','GSM3258.txt')
%
%       % In subsequent MATLAB sessions you can use geosoftread to access the
%       % local copy from disk instead of accessing it from the GEO web site.
%       geodata = geosoftread('GSM3258.txt')
%
%   See also GALREAD, GETGEODATA, GPRREAD, SPTREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.8.6.3 $   $Date: 2004/01/24 09:18:21 $

if ~ischar(geotext) && ~iscellstr(gptext)
    error('Bioinfo:GEOSOFTREADInvalidStringInput',...
        'The input is not an array of characters or a cell array of strings.');
end

% If the input is a string of GenBank data then first character should be ^
isAstring = ischar(geotext) && ~isempty(geotext) && geotext(1) == '^';


if ~isAstring 
    if ~iscellstr(geotext)
        if (strfind(geotext, '://'))
            if (~usejava('jvm'))
                error('Bioinfo:NoJava','Reading from a URL requires Java.')
            end
            % must be a URL
            geotext = urlread(geotext);
            % clean up any &amp s
            geotext=strrep(geotext,'&amp;','&');
        else
            if exist(geotext) == 2
                % it is a file
                geotext = textread(geotext,'%s','delimiter','\n','whitespace','');
                
            elseif ~exist(geotext)
                error('Bioinfo:FileNotExist','The file %s does not exist.',geotext)
            end
        end
    else
        error('Bioinfo:InvalidSOFTFile','FILE is not a valid SOFT file.')
    end
else
    geotext = strread(geotext,'%s','delimiter','\n');
end


%line number
% ln = 1;

emptyLines = cellfun('isempty',geotext);
geotext(emptyLines) = [];
numLines = size(geotext,1);

% format as follows
% ^ start line with ID
% ! comment lines
% # column descriptions
% data values
try
    [outputStruct.Scope, outputStruct.Accession] = strtok(geotext{1},'='); 
    outputStruct.Scope = outputStruct.Scope(2:end);
    outputStruct.Accession = outputStruct.Accession(2:end);
    ln = 2;
    
    while geotext{ln}(1) == '!'
        geotext{ln}(1) = '';
        ln = ln+1;
    end
    outputStruct.Header.Type ='Gene Expression Omnibus'; 
    outputStruct.Header.Text = char(geotext(2:ln-1));
    
    colStart = ln;
    while geotext{ln}(1) == '#'
        geotext{ln}(1) = '';
        ln = ln+1;
    end
    outputStruct.ColumnDescriptions = geotext(colStart:ln-1);
   
    outputStruct.ColumnNames = strread(geotext{ln},'%s','delimiter','\t');
    numCols = numel(outputStruct.ColumnDescriptions);
    numRows = numLines-ln;
    geotext{ln+1} = strrep(geotext{ln+1},'Error','NaN');
    geotext{ln+1} = strrep(geotext{ln+1},'error','NaN');
    minusTab = sprintf('-\t');
    minusZeroTab = sprintf('-0\t');
    geotext{ln+1} = strrep(geotext{ln+1},minusTab,minusZeroTab);
    splitLine = strread(geotext{ln+1},'%s','delimiter','\t');
    isNumeric = true(1,numCols);
    for count = 1:numCols
        if isempty(splitLine{count}) || ~isempty(regexp(splitLine{count},'[^0-9.eE\-]','once')) && ~strcmp(splitLine{count},'NaN')
            isNumeric(count) = false;
        end
    end
    badDataWarning = false;
    if all(isNumeric)
        vals = zeros(numRows,numCols);
        for theLine = 1:numRows
            try
                vals(theLine,:) = strread(geotext{theLine+ln},'%f','delimiter','\t','emptyvalue',NaN)';
            catch
                geotext{theLine+ln} = strrep(geotext{theLine+ln},'Error','NaN');
                geotext{theLine+ln} = strrep(geotext{theLine+ln},'error','NaN');
                geotext{theLine+ln} = strrep(geotext{theLine+ln},minusTab,minusZeroTab);
                try
                    vals(theLine,:) = strread(geotext{theLine+ln},'%f','delimiter','\t','emptyvalue',NaN)';
                catch
                    vals(theLine,:) = nan(1,numCols);
                    
                    badDataWarning = true;
                end
            end
        end
    else
        vals = cell(numRows,numCols);
        percents = repmat('%',1,numCols);
        Fs = repmat('s',1,numCols);
        Fs(isNumeric) = 'f';
        formatString = reshape([percents;Fs],1,2*numCols);

        for theLine = 1:numRows
            %             if ~mod(theLine,100)
            %                 theLine
            %             end
            if isempty(geotext{theLine+ln})
                continue
            end
            try
                [vals{theLine,:}] = strread(geotext{theLine+ln},formatString,'delimiter','\t','emptyvalue',NaN);
            catch
                geotext{theLine+ln} = strrep(geotext{theLine+ln},'Error','NaN');
                geotext{theLine+ln} = strrep(geotext{theLine+ln},'error','NaN');
                geotext{theLine+ln} = strrep(geotext{theLine+ln},minusTab,minusZeroTab);
                try
                    [vals{theLine,:}] = strread(geotext{theLine+ln},formatString,'delimiter','\t','emptyvalue',NaN);
                catch
                    %      disp('here');
                    vals(theLine,:) = repmat({NaN},1,numCols);
                    badDataWarning = true;
                end
            end
            for cols = 1:numCols
                if ~isNumeric(cols)
                    vals{theLine,cols} = char(vals{theLine,cols});
                end
                
            end
        end
    end 
    if badDataWarning
        warning('Bioinfo:BadGEOData',...
            'Unable to read some lines of the file. Missing entries will be replaced with NaNs.');
    end
    outputStruct.Data = vals;
catch
    warning('Bioinfo:IncompleteGEOFile','Problems reading the GEO data. The structure may be incomplete.');
end
