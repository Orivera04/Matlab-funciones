function data=genpeptread(gptext)
%GENPEPTREAD reads GenPept format data files.
%
%   DATA = GENPEPTREAD(FILE) reads in the GenPept formatted sequence from
%   FILE and creates a structure DATA containing fields corresponding to
%   the GenPept keywords. If the file contains information about multiple
%   sequences, then the information will be stored in an array of
%   structures. 
%
%   DATA contains these fields:
%       LocusName
%       LocusSequenceLength
%       LocusMoleculeType
%       LocusGenBankDivision
%       LocusModificationDate
%       Definition
%       Accession
%       PID
%       Version
%       GI
%       DBSource
%       Keywords
%       Source
% 		SourceDatabase
%       SourceOrganism
%       Reference.Number
%       Reference.Authors
%       Reference.Title
%       Reference.Journal
%       Reference.MedLine
%       Reference.PubMed
%       Reference.Remark
%       Comment
%       Features
%       Weight
%       Length
%       Sequence
%
%   FILE can also be a URL or a MATLAB character array that contains the
%   text of a GenPept format file.
%
%   Based on version 134.0 of GenBank
%
%   Examples:
%
%       % Download a GenPept file to your local drive.
%       getgenpept('AAA59174', 'TOFILE', 'HGENPEPTAAA59174.GPT')
%
%       % Then bring it into a MATLAB sequence.
%       data = genpeptread('HGENPEPTAAA59174.GPT')
%
%   See also FASTAREAD, GENBANKREAD, GETGENPEPT, PDBREAD, PIRREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.16.4.6 $   $Date: 2004/03/14 15:31:20 $


if ~ischar(gptext) && ~iscellstr(gptext)
    error('Bioinfo:InvalidInput',...
        'The input is not an array of characters or a cell array of strings.');
end

if iscellstr(gptext)
    % do not mess with it, just put it to char and try to decipher in the try-catch trap
    gptext=char(gptext);
else %it is char, lets check if it has an url or a file before try to decipher it
    if size(gptext,1)==1 && ~isempty(strfind(gptext(1:min(10,end)), '://'))
        % must be a URL
        if (~usejava('jvm'))
            error('Bioinfo:NoJava','Reading from a URL requires Java.')
        end
        try
            gptext = urlread(gptext);
        catch
            error('Bioinfo:CannotReadURL','Cannot read URL "%s".',gptext);
        end
        % clean up any &amp s
        gptext=strrep(gptext,'&amp;','&');
    elseif size(gptext,1)==1 && (exist(gptext) == 2 || exist(fullfile(cd,gptext)) == 2)
        % the file exists
        gptext = char(textread(gptext,'%s','delimiter','\n','whitespace',''));
    end
end

% If the input is a string of GenBank data then words LOCUS and DEFINITION must be present
if size(gptext,1)==1 || isempty(strfind(gptext(1,:),'LOCUS')) || isempty(strfind(gptext(2,:),'DEFINITION'));
    error('Bioinfo:NonMinimumRequiredFields','FILE is not a valid GenPept file or url.')
end

%line number
ln = 1;

%multiple records possible in one record
record_count=1;

numLines = size(gptext,1);
try
    while 1,

        %LOCUS - Mandatory
        data(record_count).LocusName = strtrim(gptext(ln,13:28));  %#ok
        data(record_count).LocusSequenceLength =strtrim(gptext(ln,30:40));
        data(record_count).LocusNumberofStrands = strtrim(gptext(ln,45:47));
        data(record_count).LocusTopology = strtrim(gptext(ln,56:63));
        data(record_count).LocusMoleculeType = strtrim(gptext(ln,48:53));
        data(record_count).LocusGenBankDivision = strtrim(gptext(ln,65:67));
        data(record_count).LocusModificationDate = strtrim(gptext(ln,69:79));

        ln=ln+1;

        %DEFINITION - Mandatory
        [s,f,t] = regexp(gptext(ln,:),'DEFINITION\s+(\w|\W)+'); %#ok
        data(record_count).Definition = strtrim(gptext(ln,t{1}(1):t{1}(2)));

        ln=ln+1;

        while ~matchstart(gptext(ln,:),'ACCESSION')
            data(record_count).Definition = [data(record_count).Definition,' ', strtrim(gptext(ln,:))];
            ln = ln+1;
        end

        %ACCESSION - Mandatory
        [s,f,t] = regexp(gptext(ln,:),'ACCESSION\s+(\w|\W)+');  %#ok
        data(record_count).Accession = strtrim(gptext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
        while ~matchstart(gptext(ln,:),'VERSION')
            data(record_count).Accession=[data(record_count).Accession ' ' strtrim(gptext(ln,:))];
            ln=ln+1;
        end


        %VERSION - Mandatory
        [s,f,t] = regexp(gptext(ln,:),'VERSION\s+(\w|\W)+');  %#ok
        rmdr = gptext(ln,t{1}(1):t{1}(2));
        [data(record_count).Version, rmdr] = strtok(rmdr,'GI:');
        data(record_count).Version = strtrim(data(record_count).Version);

        %GI - Mandatory (part of version)
        data(record_count).GI = deblank(rmdr(4:end));

        ln=ln+1;

        %DBSOURCE
        [s,f,t] = regexp(gptext(ln,:),'DBSOURCE\s+(\w|\W)+');  %#ok
        data(record_count).DBSource = strtrim(gptext(ln,t{1}(1):t{1}(2)));

        ln = ln + 1;
        while ~matchstart(gptext(ln,:),'KEYWORDS')
            data(record_count).DBSource = [data(record_count).DBSource ' ' strtrim(gptext(ln,:))];
            ln=ln+1;
        end

        %KEYWORDS - Mandatory for all annotated records.
        data(record_count).Keywords=[];
        [s,f,t] = regexp(gptext(ln,:),'KEYWORDS\s+(\w|\W)+');  %#ok
        if ~isempty(s)
            data(record_count).Keywords=deblank(gptext(ln,t{1}(1):t{1}(2)));
            ln=ln+1;
        end
        while ~isempty(s) && ~matchstart(gptext(ln,:),'SOURCE')
            data(record_count).Keywords=strvcat(data(record_count).Keywords, strtrim(gptext(ln,:)));  %#ok
            ln=ln+1;
        end
        if all(~isletter(data(record_count).Keywords)),
            data(record_count).Keywords = '';
        end

        %SOURCE - Mandatory for all annotated records.
        [s,f,t] = regexp(gptext(ln,:),'SOURCE\s+(\w|\W)+');  %#ok
        data(record_count).Source = deblank(gptext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
        while ~matchstart(gptext(ln,:),'ORGANISM') && ~matchstart(gptext(ln,:),'FEATURES') && ~matchstart(gptext(ln,:),'COMMENT') && ~matchstart(gptext(ln,:),'BASE COUNT')
            data(record_count).Source = [data(record_count).Source ' ' strtrim(gptext(ln,:))];
            ln=ln+1;
        end

        %ORGANISM - Mandatory for all annotated records.
        data(record_count).SourceOrganism = [];
        [s,f,t] = regexp(gptext(ln,:),'ORGANISM\s+(\w|\W)+');  %#ok
        if ~isempty(s)
            data(record_count).SourceOrganism = strtrim(gptext(ln,t{1}(1):t{1}(2)));
            %entry ends with a period
            while isempty(strfind(data(record_count).SourceOrganism(end,:),'.'))
                ln=ln+1;
                data(record_count).SourceOrganism = strvcat(data(record_count).SourceOrganism, strtrim(gptext(ln,:)));  %#ok
            end
        end

        ln=ln+1;

        %REFERENCE
        [data,gptext,ln] = referenceparse(data,gptext,ln,record_count);

        %COMMENT - Optional
        data(record_count).Comment = [];
        [s,f,t] = regexp(gptext(ln,:),'COMMENT\s+(\w|\W)+');  %#ok
        if ~isempty(s)
            data(record_count).Comment = strtrim(gptext(ln,t{1}(1):t{1}(2)));
            ln=ln+1;
            while ~matchstart(gptext(ln,:),'FEATURES')
                data(record_count).Comment=strvcat(data(record_count).Comment, strtrim(gptext(ln,:))); %#ok
                ln=ln+1;
            end
        end

        %FEATURES - Optional
        data(record_count).Features = [];
        if matchstart(gptext(ln,:),'FEATURES')
            feats = cell(numLines-ln,1);
            ln=ln+1;
            featCount = 1;
            feats{featCount} = gptext(ln,1:end);
            ln=ln+1;
            while ~matchstart(gptext(ln,:),'ORIGIN')
                featCount = featCount+1;
                feats{featCount} = gptext(ln,1:end);
                ln=ln+1;
            end
            data(record_count).Features = strtrim(strvcat(feats(1:featCount)));  %#ok
        end

        %ORIGIN - Mandatory
        if matchstart(gptext(ln,:),'ORIGIN')
            ln=ln+1;
        end

        temp=gptext(ln,:);
        temp(~isletter(temp)) = '';
        data(record_count).Sequence = temp;
        ln=ln+1;
        while ~matchstart(gptext(ln,:),'//') && ~matchstart(gptext(ln,:),'LOCUS')
            temp=gptext(ln,:);
            temp(~isletter(temp)) = '';
            data(record_count).Sequence = [data(record_count).Sequence, temp];
            ln=ln+1;
        end

        if matchstart(gptext(ln,:),'//') && ln < numLines
            while ln < numLines
                ln=ln+1;
                % another record ?
                if matchstart(gptext(ln,:),'LOCUS')
                    record_count = record_count+1;
                    break
                end
            end
        end

        if ln == numLines
            %end of file
            return
        end

    end
catch
    warning('Bioinfo:GenPeptIncomplete',...
        'Problems reading the GenPept data. The structure may be incomplete.');
end

function [data,gptext,ln] = referenceparse(data,gptext,ln,record_count)
%REFERENCEPARSE is used to parse out the reference entries of GenBank files

ref_count=1;
while ~matchstart(gptext(ln,:),'FEATURES') && ~matchstart(gptext(ln,:),'COMMENT') && ~matchstart(gptext(ln,:),'ORIGIN')

    %REFERENCE - Mandatory
    [s,f,t] = regexp(gptext(ln,:),'REFERENCE\s+(\w|\W)+');  %#ok
    data(record_count).Reference{ref_count}.Number = strtrim(gptext(ln,t{1}(1):t{1}(2)));
    ln=ln+1;

    %AUTHORS - Mandatory
    [s,f,t] = regexp(gptext(ln,:),'AUTHORS\s+(\w|\W)+');  %#ok
    data(record_count).Reference{ref_count}.Authors = strtrim(gptext(ln,t{1}(1):t{1}(2)));
    ln=ln+1;


    while ~matchstart(gptext(ln,:),'TITLE') && ~matchstart(gptext(ln,:),'JOURNAL')
        data(record_count).Reference{ref_count}.Authors=strvcat(data(record_count).Reference{ref_count}.Authors, strtrim(gptext(ln,:))); %#ok
        ln=ln+1;
    end

    %TITLE - Optional
    data(record_count).Reference{ref_count}.Title = [];
    [s,f,t] = regexp(gptext(ln,:),'TITLE\s+(\w|\W)+');  %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.Title = strtrim(gptext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
    end
    while ~matchstart(gptext(ln,:),'JOURNAL')
        data(record_count).Reference{ref_count}.Title=strvcat(data(record_count).Reference{ref_count}.Title, strtrim(gptext(ln,:))); %#ok
        ln=ln+1;
    end

    %JOURNAL - Mandatory
    [s,f,t] = regexp(gptext(ln,:),'JOURNAL\s+(\w|\W)+');  %#ok
    data(record_count).Reference{ref_count}.Journal = strtrim(gptext(ln,t{1}(1):t{1}(2)));
    ln=ln+1;

    if matchstart(gptext(ln,:),'REFERENCE')
        ref_count=ref_count+1;
        % next reference
        continue
    end

    if matchstart(gptext(ln,:),'COMMENT') || matchstart(gptext(ln,:),'FEATURES') || matchstart(gptext(ln,:),'BASE COUNT')
        % done with references
        break
    end

    while ~matchstart(gptext(ln,:),'MEDLINE') && ~matchstart(gptext(ln,:),'PUBMED') && ~matchstart(gptext(ln,:),'REMARK')
        data(record_count).Reference{ref_count}.Journal=strvcat(data(record_count).Reference{ref_count}.Journal, strtrim(gptext(ln,:))); %#ok
        ln=ln+1;
        if matchstart(gptext(ln,:),'COMMENT') || matchstart(gptext(ln,:),'FEATURES') || matchstart(gptext(ln,:),'BASE COUNT')
            % done with references
            break
        end
    end

    %MEDLINE - Optional
    data(record_count).Reference{ref_count}.MedLine = [];
    [s,f,t] = regexp(gptext(ln,:),'MEDLINE\s+(\d)+');  %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.MedLine = gptext(ln,t{1}(1):t{1}(2));
        ln=ln+1;
    end

    %PUBMED - Optional
    data(record_count).Reference{ref_count}.PubMed = [];
    [s,f,t] = regexp(gptext(ln,:),'PUBMED\s+(\d+)');  %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.PubMed = gptext(ln,t{1}(1):t{1}(2));
        ln=ln+1;
    end

    %REMARK - Optional
    data(record_count).Reference{ref_count}.Remark = [];
    [s,f,t] = regexp(gptext(ln,:),'REMARK\s+(\w|\W)+');  %#ok
    if ~isempty(s)
        data(record_count).Reference{ref_count}.Remark = strtrim(gptext(ln,t{1}(1):t{1}(2)));
        ln=ln+1;
    end
    while ~isempty(s) && ~matchstart(gptext(ln,:),'COMMENT') && ~matchstart(gptext(ln,:),'FEATURES') && ~matchstart(gptext(ln,:),'BASE COUNT') && ~matchstart(gptext(ln,:),'REFERENCE')
        data(record_count).Reference{ref_count}.Journal=strvcat(data(record_count).Reference{ref_count}.Journal, strtrim(gptext(ln,t{1}(1):t{1}(2)))); %#ok
        ln=ln+1;
        if matchstart(gptext(ln,:),'COMMENT') || matchstart(gptext(ln,:),'FEATURES') || matchstart(gptext(ln,:),'BASE COUNT'), break, end
    end

    % next reference
    ref_count=ref_count+1;
end

function tf = matchstart(string,pattern)
%MATCHSTART matches start of string with pattern, ignoring spaces
tf = ~isempty(regexp(string,['^(\s)*?',pattern],'once'));
