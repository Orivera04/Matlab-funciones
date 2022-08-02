function data=genbankread(gbtext)
%GENBANKREAD reads GenBank format data files.
%
%   DATA = GENBANKREAD(FILE) reads in a GenBank formatted sequence from
%   FILE and creates a structure DATA containing fields corresponding to
%   the GenBank keywords. If the file contains information about multiple
%   sequences, then the information will be stored in an array of
%   structures.
%
%   FILE can also be a URL or a MATLAB character array that contains the
%   text of a GenBank format file.
%
%   Based on version 134.0 of GenBank
%
%   Examples:
%
%       % Download a GenBank file to your local drive.
%       getgenbank('M10051', 'TOFILE', 'HGENBANKM10051.GBK')
%
%       % Then bring it into a MATLAB sequence.
%       data = genbankread('HGENBANKM10051.GBK')
%
%   See also EMBLREAD, FASTAREAD, GENPEPTREAD, GETGENBANK, SCFREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.16.4.8 $   $Date: 2004/03/14 15:31:18 $


if ~ischar(gbtext) && ~iscellstr(gbtext)
    error('Bioinfo:InvalidInput','The input is not an array of characters or a cell array of strings.');
end

if iscellstr(gbtext)
    % do not mess with it, just put it to char and try to decipher in the try-catch trap
    gbtext=char(gbtext);
else %it is char, lets check if it has an url or a file before try to decipher it
    if size(gbtext,1)==1 && ~isempty(strfind(gbtext(1:min(10,end)), '://'))
        % must be a URL
        if (~usejava('jvm'))
            error('Bioinfo:NoJava','Reading from a URL requires Java.')
        end
        try
            gbtext = urlread(gbtext);
        catch
            error('Bioinfo:CannotReadURL','Cannot read URL "%s".',gbtext);
        end
        % clean up any &amp s
        gbtext=strrep(gbtext,'&amp;','&');
    elseif size(gbtext,1)==1 && (exist(gbtext) == 2 || exist(fullfile(cd,gbtext)) == 2)
        % the file exists
        gbtext = char(textread(gbtext,'%s','delimiter','\n','whitespace',''));
    end
end

% If the input is a string of GenBank data then words LOCUS and DEFINITION must be present
if size(gbtext,1)==1 || isempty(strfind(gbtext(1,:),'LOCUS')) || isempty(strfind(gbtext(2,:),'DEFINITION'));
    error('Bioinfo:NonMinimumRequiredFields','FILE is not a valid GenBank file or url.')
end

%line number
ln = 1;

%multiple records possible in one record
record_count=1;

numLines = size(gbtext,1);
try
    while 1,

        %LOCUS - Mandatory
        data(record_count).LocusName = strtrim(gbtext(ln,13:28));  %#ok
        data(record_count).LocusSequenceLength =strtrim(gbtext(ln,30:40));
        data(record_count).LocusNumberofStrands = strtrim(gbtext(ln,45:47));
        data(record_count).LocusTopology = strtrim(gbtext(ln,56:63));
        data(record_count).LocusMoleculeType = strtrim(gbtext(ln,48:53));
        data(record_count).LocusGenBankDivision = strtrim(gbtext(ln,65:67));
        data(record_count).LocusModificationDate = strtrim(gbtext(ln,69:79));

        ln=ln+1;

        %DEFINITION - Mandatory
        [s,f,t] = regexp(gbtext(ln,:),'DEFINITION\s+(\w|\W)+'); %#ok
        data(record_count).Definition = strtrim(gbtext(ln,t{1}(1):t{1}(2)));

        ln=ln+1;

        while ~matchstart(gbtext(ln,:),'ACCESSION')
            data(record_count).Definition = [data(record_count).Definition,' ', strtrim(gbtext(ln,:))];
            ln = ln+1;
        end

        %ACCESSION - Mandatory
        [s,f,t] = regexp(gbtext(ln,:),'ACCESSION\s+(\w|\W)+'); %#ok
        data(record_count).Accession = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;

        while ~matchstart(gbtext(ln,:),'VERSION')
            data(record_count).Accession=[data(record_count).Accession ' ' strtrim(gbtext(ln,:))];
            ln=ln+1;
        end

        %VERSION - Mandatory
        [s,f,t] = regexp(gbtext(ln,:),'VERSION\s+(\w|\W)+'); %#ok
        rmdr = gbtext(ln,t{1}(1):t{1}(2));
        [data(record_count).Version, rmdr] = strtok(rmdr,'GI:');
        data(record_count).Version = strtrim(data(record_count).Version);

        %GI - Mandatory (part of version)
        data(record_count).GI = deblank(rmdr(4:end));

        ln=ln+1;

        %KEYWORDS - Mandatory for all annotated records.
        data(record_count).Keywords=[];
        [s,f,t] = regexp(gbtext(ln,:),'KEYWORDS\s+(\w|\W)+'); %#ok
        if ~isempty(s)
            data(record_count).Keywords=deblank(gbtext(ln,t{1}(1):t{1}(2)));
            ln=ln+1;
        end
        while ~isempty(s) && ~matchstart(gbtext(ln,:),'SEGMENT') && ~matchstart(gbtext(ln,:),'SOURCE') %#ok
            data(record_count).Keywords=strvcat(data(record_count).Keywords, deblank(gbtext(ln,:)));
            ln=ln+1;
        end
        if all(~isletter(data(record_count).Keywords)),
            data(record_count).Keywords = [];
        end


        %SEGMENT - Optional, only used for segmented records
        data(record_count).Segment=[];
        [s,f,t] = regexp(gbtext(ln,:),'SEGMENT\s+(\w|\W)+'); %#ok
        if ~isempty(s)
            data(record_count).Segment=gbtext(ln,t{1}(1):t{1}(2));
            ln=ln+1;
        end


        %SOURCE - Mandatory for all annotated records.
        [s,f,t] = regexp(gbtext(ln,:),'SOURCE\s+(\w|\W)+'); %#ok
        data(record_count).Source = deblank(gbtext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
        while ~matchstart(gbtext(ln,:),'ORGANISM') && ~matchstart(gbtext(ln,:),'FEATURES') && ~matchstart(gbtext(ln,:),'COMMENT') && ~matchstart(gbtext(ln,:),'BASE COUNT')
            data(record_count).Source = [data(record_count).Source ' ' deblank(gbtext(ln,t{1}(1):t{1}(2)))];
            ln=ln+1;
        end


        %ORGANISM - Mandatory for all annotated records.
        data(record_count).SourceOrganism = [];
        [s,f,t] = regexp(gbtext(ln,:),'ORGANISM\s+(\w|\W)+'); %#ok
        if ~isempty(s)
            data(record_count).SourceOrganism = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
            %entry ends with a period
            while isempty(regexp(gbtext(ln+1,:),'REFERENCE\s+(\w|\W)+','once'))
                ln=ln+1;
                data(record_count).SourceOrganism = strvcat(data(record_count).SourceOrganism, strtrim(gbtext(ln,:))); %#ok
            end
        end

        ln=ln+1;

        %REFERENCE
        [data,gbtext,ln] = referenceparse(data,gbtext,ln,record_count);

        %COMMENT - Optional
        data(record_count).Comment = [];
        [s,f,t] = regexp(gbtext(ln,:),'COMMENT\s+(\w|\W)+'); %#ok
        if ~isempty(s)
            data(record_count).Comment = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
            ln=ln+1;
            while ~matchstart(gbtext(ln,:),'FEATURES') && ~matchstart(gbtext(ln,:),'BASE COUNT')...
                    && ~matchstart(gbtext(ln,:),'ORIGIN')
                data(record_count).Comment=strvcat(data(record_count).Comment, strtrim(gbtext(ln,t{1}(1):t{1}(2)))); %#ok
                ln=ln+1;
            end
        end

        %FEATURES - Optional
        data(record_count).Features = [];
        if matchstart(gbtext(ln,:),'FEATURES')
            feats = cell(numLines-ln,1);
            ln=ln+1;
            featCount = 1;
            feats{featCount} = gbtext(ln,1:end);
            ln=ln+1;
            while ~matchstart(gbtext(ln,:),'ORIGIN')
                featCount = featCount+1;
                feats{featCount} = gbtext(ln,1:end);
                ln=ln+1;
            end
            data(record_count).Features = strtrim(strvcat(feats(1:featCount))); %#ok
            try
                cdschar = data(record_count).Features(strmatch('CDS',cellstr(data(record_count).Features)),:);
                if ~isempty(cdschar)
                    cds = cellstr(cdschar);
                    cdCount = numel(cds);
                    cdMaxLength = 2* max(cellfun('prodofsize',strfind(cds,'..')));
                    data(record_count).CDS = zeros(cdCount,cdMaxLength);
                    for cdloop = 1:cdCount
                        theCD = strtrim(strrep(cds{cdloop},'CDS',''));
                        theCD = strrep(theCD,'.',' ');
                        theCD = regexprep(theCD,'[\(\)<>]','');
                        if strfind(theCD,'complement')
                            complementFlag = true;
                            theCD = strrep(theCD,'complement','');
                        else
                            complementFlag = false;
                        end
                        if strfind(theCD,'join')
                            joinFlag = true;
                            theCD = strrep(theCD,'join','');
                        else
                            joinFlag = false;
                        end
                        cdVals = str2num(theCD); %#ok want arrays to be handled
                        if complementFlag
                            cdVals = fliplr(cdVals);
                        end
                        data(record_count).CDS(cdloop,1:numel(cdVals)) = cdVals;
                    end
                end
            catch
                if isfield(data(record_count),'CDS')
                    data(record_count).CDS = [];
                end
                 warning('Bioinfo:getgenbank:BADCDS',...
                     'Problem extracting CDS.');
            end
        end

        %ORIGIN - Mandatory
        if matchstart(gbtext(ln,:),'ORIGIN')
            ln=ln+1;
        end

        temp=gbtext(ln,:);
        temp(~isletter(temp)) = '';
        data(record_count).Sequence = temp;
        ln=ln+1;
        while ~matchstart(gbtext(ln,:),'//') && ~matchstart(gbtext(ln,:),'LOCUS')
            temp=gbtext(ln,:);
            temp(~isletter(temp)) = '';
            data(record_count).Sequence = [data(record_count).Sequence, temp];
            ln=ln+1;
        end

        if ln < numLines && matchstart(gbtext(ln,:),'//')
            while ln<numLines
                ln=ln+1;
                % another record ?
                if matchstart(gbtext(ln,:),'LOCUS')
                    record_count = record_count+1;
                    break
                end
            end
        end
        if ln == numLines
            return
        end
    end
catch
    warning('Bioinfo:incompleteGenBankData','Problems reading the GenBank data. The structure may be incomplete.');
end

function [data,gbtext,ln] = referenceparse(data,gbtext,ln,record_count)
%REFERENCEPARSE is used to parse out the reference entries of GenBank files

ref_count=1;
while ~matchstart(gbtext(ln,:),'FEATURES') && ~matchstart(gbtext(ln,:),'COMMENT') && ~matchstart(gbtext(ln,:),'ORIGIN')

    %REFERENCE - Mandatory
    [s,f,t] = regexp(gbtext(ln,:),'REFERENCE\s+(\w|\W)+'); %#ok
    data(record_count).Reference{ref_count}.Number = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
    ln=ln+1;

    %AUTHORS - Mandatory
    [s,f,t] = regexp(gbtext(ln,:),'AUTHORS\s+(\w|\W)+'); %#ok
    data(record_count).Reference{ref_count}.Authors = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
    ln=ln+1;


    while ~matchstart(gbtext(ln,:),'TITLE') && ~matchstart(gbtext(ln,:),'JOURNAL')
        data(record_count).Reference{ref_count}.Authors=strvcat(data(record_count).Reference{ref_count}.Authors, strtrim(gbtext(ln,:))); %#ok
        ln=ln+1;
    end

    %TITLE - Optional
    data(record_count).Reference{ref_count}.Title = [];
    [s,f,t] = regexp(gbtext(ln,:),'TITLE\s+(\w|\W)+'); %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.Title = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
    end
    while ~matchstart(gbtext(ln,:),'JOURNAL')
        data(record_count).Reference{ref_count}.Title=strvcat(data(record_count).Reference{ref_count}.Title, strtrim(gbtext(ln,:))); %#ok
        ln=ln+1;
    end

    %JOURNAL - Mandatory
    [s,f,t] = regexp(gbtext(ln,:),'JOURNAL\s+(\w|\W)+'); %#ok
    data(record_count).Reference{ref_count}.Journal = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
    ln=ln+1;

    if matchstart(gbtext(ln,:),'REFERENCE')
        ref_count=ref_count+1;
        % next reference
        continue
    end

    if matchstart(gbtext(ln,:),'COMMENT') || matchstart(gbtext(ln,:),'FEATURES') || matchstart(gbtext(ln,:),'BASE COUNT')
        % done with references
        break
    end

    while ~matchstart(gbtext(ln,:),'MEDLINE') && ~matchstart(gbtext(ln,:),'PUBMED') && ~matchstart(gbtext(ln,:),'REMARK')
        data(record_count).Reference{ref_count}.Journal=strvcat(data(record_count).Reference{ref_count}.Journal, strtrim(gbtext(ln,:))); %#ok
        ln=ln+1;
        if matchstart(gbtext(ln,:),'COMMENT') || matchstart(gbtext(ln,:),'FEATURES') || matchstart(gbtext(ln,:),'BASE COUNT')
            % done with references
            break
        end
    end

    %MEDLINE - Optional
    data(record_count).Reference{ref_count}.MedLine = [];
    [s,f,t] = regexp(gbtext(ln,:),'MEDLINE\s+(\d)+'); %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.MedLine = gbtext(ln,t{1}(1):t{1}(2));
        ln=ln+1;
    end

    %PUBMED - Optional
    data(record_count).Reference{ref_count}.PubMed = [];
    [s,f,t] = regexp(gbtext(ln,:),'PUBMED\s+(\d+)'); %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.PubMed = gbtext(ln,t{1}(1):t{1}(2));
        ln=ln+1;
    end

    %REMARK - Optional
    data(record_count).Reference{ref_count}.Remark = [];
    [s,f,t] = regexp(gbtext(ln,:),'REMARK\s+(\w|\W)+'); %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.Remark = strtrim(gbtext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
    end
    while ~isempty(s) && ~matchstart(gbtext(ln,:),'COMMENT') && ~matchstart(gbtext(ln,:),'FEATURES') && ~matchstart(gbtext(ln,:),'BASE COUNT') && ~matchstart(gbtext(ln,:),'REFERENCE')
        data(record_count).Reference{ref_count}.Journal=strvcat(data(record_count).Reference{ref_count}.Journal, strtrim(gbtext(ln,t{1}(1):t{1}(2)))); %#ok
        ln=ln+1;
        if matchstart(gbtext(ln,:),'COMMENT') || matchstart(gbtext(ln,:),'FEATURES') || matchstart(gbtext(ln,:),'BASE COUNT'), break, end
    end

    % next reference
    ref_count=ref_count+1;
end

function tf = matchstart(string,pattern)
%MATCHSTART matches start of string with pattern, ignoring spaces
tf = ~isempty(regexp(string,['^(\s)*?',pattern],'once'));
