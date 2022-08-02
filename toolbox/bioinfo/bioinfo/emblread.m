function data=emblread(embltext,varargin)
%EMBLREAD read in EMBL-EBI format data files.
%
%   DATA = EMBLREAD(FILENAME) imports the EMBL-EBI format data from file
%   FILENAME and creates a structure DATA with fields corresponding to the
%   EMBL-EBI two-character line type code. Each line type code is stored as
%   a separate element of the structure.
%
%   FILENAME can also be a URL or a MATLAB character array that contains
%   the text of an EMBL format file.
%
%    DATA contains the following fields:
%       Identification
%       Accession
%       SequenceVersion
%       DateCreated
%       DateUpdated
%       Description
%       Keyword
%       OrganismSpecies
%       OrganismClassification
%       Organelle
%       Reference.Number
%       Reference.Comment
%       Reference.Position
%       Reference.MedLine
%       Reference.PubMed
%       Reference.Authors
%       Reference.Title
%       Reference.Location
%       DbCrossRef
%       Comments
%       Feature
%       BaseCount.BP
%       BaseCount.A
%       BaseCount.C
%       BaseCount.G
%       BaseCount.T
%       BaseCount.Other
%       Sequence
%
%     DATA = EMBLREAD('FILENAME.EXT','SEQUENCEONLY',true) reads only the
%     sequence information.
%
%   Examples:
%
%       % Get EMBL data and save it to a file.
%       emblout = getembl('X00558','TOFILE','X00558.ebi')
%
%       % In subsequent MATLAB sessions you can use pdbread to access the
%       % local copy from disk instead of accessing it from the EMBL site.
%       data = emblread('X00558.ebi')
%
%   See also FASTAREAD, GENBANKREAD, GETEMBL.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.14.4.4 $   $Date: 2004/01/24 09:17:21 $

% guess what type of input we have -- string, file or URL

% If it is a string then ID must be present in the string


if ~ischar(embltext)
    error('Bioinfo:EMBLReadInvalidInput','The input should be a filename or an EMBL format text string.');
end

if size(embltext,1)>1  % is padded string
    embltextCell = cell(size(embltext,1),1);
    for i=1:size(embltext,1)
        embltextCell(i)=strread(embltext(i,:),'%s','whitespace','');
        embltextCell{i}(find(~isspace(embltextCell{i}),1,'last')+1:end)=[];
    end
    embltext=embltextCell;
    clear embltextCell;
    % try then if it is an url
elseif (strfind(embltext(1:min(10,end)), '://'))
    % must be a URL
    if (~usejava('jvm'))
        error('Bioinfo:NoJava','Reading from a URL requires Java.')
    end
    try
        embltext = urlread(embltext);
    catch
        error('Bioinfo:CannotReadURL','Cannot read URL "%s".',embltext);
    end
    % clean up any &amp s
    embltext=strrep(embltext,'&amp;','&');
    % try then if it is a valid filename
elseif  (exist(embltext) == 2 || exist(fullfile(cd,embltext)) == 2)
    embltext = textread(embltext,'%s','delimiter','\n','whitespace','');
    embltext=char(embltext);
else % must be a string with '\n', convert to cell
    embltext = strread(embltext,'%s','delimiter','\n');
    embltext=char(embltext);
end

if isempty(strmatch('ID',embltext))
    error('Bioinfo:EMBLNotValid','Input is not a valid variable or EMBL file');
end

SeqOnly=false;
if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:NumberOfArgumentsIncorrect','Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'sequenceonly',''};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
				'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
				'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % sequence
                    SeqOnly = opttf(pval);
                    if isempty(SeqOnly)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
            end
        end
    end
end

%if input is a cell array
%concatenate vertically

if iscell(embltext)
    numelembltext=numel(embltext);
    embltemp='';
    for count=1:numelembltext,
        embltemp=strvcat(embltemp,embltext{count});  %#ok
    end
    embltext=embltemp;
end

refcount=0;

[embltext,commentsize]=blanklines(embltext);

ln=1;
recordcount=1;

while 1
    %CC-free text Comment
    data(recordcount).Comments=[]; %#ok
    j=1;
    while 1
        if j <= commentsize && matchstart(embltext(j,:),'CC')
            data(recordcount).Comments=strvcat(data(recordcount).Comments,deblank(embltext(j,6:end))); %#ok
            embltext(j,:)='';
        else
            j=j+1;
            if j>commentsize || matchstart(embltext(j,:),'//')
                break
            end
        end
    end

    %ID-Identification
    Identificationline=deblank(embltext(ln,6:end));
    [data(recordcount).Identification.EntryName,temp] = strtok(Identificationline);
    [data(recordcount).Identification.DataClass,temp] = strtok(temp,';'); temp = temp(3:end);
    data(recordcount).Identification.DataClass = strrep(data(recordcount).Identification.DataClass,' ','');
    [data(recordcount).Identification.Molecule,temp] = strtok(temp,';'); temp = temp(3:end);
    [data(recordcount).Identification.Division,temp] = strtok(temp,';'); temp = temp(3:end);
    data(recordcount).Identification.SequenceLength = strtok(temp,'.');
    ln=ln+1;

    %AC-Accession number
    data(recordcount).Accession=deblank(embltext(ln,6:end));
    data(recordcount).Accession = strrep(data(recordcount).Accession,';','');
    ln=ln+1;

    %SV-Sequence Version
    data(recordcount).SequenceVersion=deblank(embltext(ln,6:end));
    ln=ln+1;

    %DT-Date
    data(recordcount).DateCreated=deblank(embltext(ln,6:end));
    ln=ln+1;
    data(recordcount).DateUpdated=deblank(embltext(ln,6:end));
    ln=ln+1;

    %DE-Description
    data(recordcount).Description=[];
    while matchstart(embltext(ln,:),'DE')
        data(recordcount).Description=strvcat(data(recordcount).Description,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %KW-Keyword
    data(recordcount).Keyword=[];
    while matchstart(embltext(ln,:),'KW')
        data(recordcount).Keyword=strvcat(data(recordcount).Keyword,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %OS-Organism Species
    data(recordcount).OrganismSpecies=[];
    while matchstart(embltext(ln,:),'OS')
        data(recordcount).OrganismSpecies=strvcat(data(recordcount).OrganismSpecies,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %OC-Organism Classification
    data(recordcount).OrganismClassification=[];
    while matchstart(embltext(ln,:),'OC')
        data(recordcount).OrganismClassification=strvcat(data(recordcount).OrganismClassification,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %OG-Organelle
    data(recordcount).Organelle=[];
    while matchstart(embltext(ln,:),'OG')
        data(recordcount).Organelle=strvcat(data(recordcount).Organelle,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %Reference
    while matchstart(embltext(ln,:),'RN') %ref name
        refcount=refcount+1;

        %RN-Reference name
        data(recordcount).Reference{refcount}.Number=deblank(embltext(ln,6:end));
        ln=ln+1;

        %RC-Reference Comment
        data(recordcount).Reference{refcount}.Comment=[];
        while matchstart(embltext(ln,:),'RC')
            data(recordcount).Reference{refcount}.Comment=strvcat(data(recordcount).Reference{refcount}.Comment,deblank(embltext(ln,6:end))); %#ok
            ln=ln+1;
        end

        %RP-Reference Position
        data(recordcount).Reference{refcount}.Position=[];
        while matchstart(embltext(ln,:),'RP')
            data(recordcount).Reference{refcount}.Position=strvcat(data(recordcount).Reference{refcount}.Position,deblank(embltext(ln,6:end))); %#ok
            ln=ln+1;
        end

        %RX-Reference Database identifier
        data(recordcount).Reference{refcount}.MedLine = '';
        data(recordcount).Reference{refcount}.PubMed = '';
        databaseText = '';
        while matchstart(embltext(ln,:),'RX')
            databaseText=strvcat(databaseText,lower(deblank(embltext(ln,6:end)))); %#ok
            ln=ln+1;
        end
        medlineRow = strmatch('medline',databaseText);
        if medlineRow
            [junk, medlineText] = strtok(databaseText(medlineRow,:)); %#ok
            medlineText(medlineText == '.') = '';
            medlineText(medlineText == ' ') = '';
            data(recordcount).Reference{refcount}.MedLine = medlineText;
        end

        pubmedRow = strmatch('pubmed',databaseText);
        if pubmedRow
            [junk, pubmedText] = strtok(databaseText(pubmedRow,:)); %#ok
            pubmedText(pubmedText == '.') = '';
            pubmedText(pubmedText == ' ') = '';
            data(recordcount).Reference{refcount}.PubMed = pubmedText;
        end


        %RA-Reference Authors
        data(recordcount).Reference{refcount}.Authors=[];
        while matchstart(embltext(ln,:),'RA')
            data(recordcount).Reference{refcount}.Authors=strvcat(data(recordcount).Reference{refcount}.Authors,deblank(embltext(ln,6:end))); %#ok
            ln=ln+1;
        end

        %RT-Reference Title
        data(recordcount).Reference{refcount}.Title=[];
        while matchstart(embltext(ln,:),'RT')
            data(recordcount).Reference{refcount}.Title=strvcat(data(recordcount).Reference{refcount}.Title,deblank(embltext(ln,6:end))); %#ok
            ln=ln+1;
        end

        %RL-Reference Location
        data(recordcount).Reference{refcount}.Location=[];
        while matchstart(embltext(ln,:),'RL')
            data(recordcount).Reference{refcount}.Location=strvcat(data(recordcount).Reference{refcount}.Location,deblank(embltext(ln,6:end))); %#ok
            ln=ln+1;
        end

    end

    %DR-Database Cross Reference
    data(recordcount).DatabaseCrossReference=[];
    while matchstart(embltext(ln,:),'DR')
        data(recordcount).DatabaseCrossReference=strvcat(data(recordcount).DatabaseCrossReference,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %FH Features header
    data(recordcount).Feature=[];
    while matchstart(embltext(ln,:),'FH')
        data(recordcount).Feature=strvcat(data(recordcount).Feature,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end

    %FT Features text
    while matchstart(embltext(ln,:),'FT')
        data(recordcount).Feature=strvcat(data(recordcount).Feature,deblank(embltext(ln,6:end))); %#ok
        ln=ln+1;
    end
    oth = false;
    %SQ sequence header
    while matchstart(embltext(ln,:),'SQ')
        temp=embltext(ln,14:end);
        [numbp,temp]=strtok(temp,'BP'); temp= temp(3:end);
        [numa,temp]=strtok(temp,'A'); temp = temp(3:end);
        [numc,temp]=strtok(temp,'C'); temp = temp(3:end);
        [numg,temp]=strtok(temp,'G'); temp = temp(3:end);
        [numt,temp]=strtok(temp,'T');
        if strfind(temp,'other'),
            temp = embltext(ln,2:end);
            numo = strtok(temp,'o');
            oth = true;
        end

        data(recordcount).BaseCount.BP= str2double(numbp);
        data(recordcount).BaseCount.A = str2double(numa);
        data(recordcount).BaseCount.C = str2double(numc);
        data(recordcount).BaseCount.G = str2double(numg);
        data(recordcount).BaseCount.T = str2double(numt);
        data(recordcount).BaseCount.Other = [];
        if oth
            data(recordcount).BaseCount.Other = str2double(numo);
        end

        ln=ln+1;
    end

    %Read in sequence until end of entry, //
    data(recordcount).Sequence=[];
    while ~matchstart(embltext(ln,:),'//') && ~matchstart(embltext(ln,:),'ID')
        data(recordcount).Sequence=strcat(data(recordcount).Sequence,embltext(ln,6:72));
        ln=ln+1;
    end

    data(recordcount).Sequence=char(regexprep(data(recordcount).Sequence,' ',''));

    while  ln < size(embltext,1) && matchstart(embltext(ln,:),'ID')
        ln=ln+1;
    end

    if matchstart(embltext(ln,:),'ID') %see if line is part of next record
        recordcount = recordcount+1;
        continue
    else
        if SeqOnly == true
            data=data(recordcount).Sequence;
        else
            data=data;
        end
        return
    end
end

function [out,commentsize]=blanklines(in)
m = size(in,1);
numblanks=0;
numcomments=0;
%find Number of blank lines
for i=1:m
    if matchstart(in(i,:),'XX')
        numblanks=numblanks+1;
    end
    if matchstart(in(i,:),'CC')
        numcomments=numcomments+1;
    end
end

%remove blank lines
for i=1:m-numblanks
    if matchstart(in(i,:),'XX')
        in(i,:)='';
    end
end
out=in;
commentsize=m-numblanks-numcomments;

function tf = matchstart(string,pattern)
%MATCHES start of string with pattern

tf = ~isempty(regexp(string,['^',pattern],'once'));
