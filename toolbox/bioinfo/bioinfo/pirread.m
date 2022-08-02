function data = pirread(pirtext)
%PIRREAD reads PIR/CODATA format files.
%
%   PIRSTRUCT = PIRREAD(FILENAME) reads PIR format file FILENAME into
%   structure PIRSTRUCT.
%
%   PIRREAD(STR) attempts to retrieve PIR information from the string STR.
%
%   Example:
%
%       pirstruct = pirread('cchu.pir')
%
%   For more information on PIR, see http://pir.georgetown.edu .
%
%   See also GENPEPTREAD, GETPIR, PDBREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.4.4 $   $Date: 2004/01/24 09:17:56 $



if nargin < 1
    error('Bioinfo:InvalidInput','One input required.');
end

if isempty(pirtext)
    error('Bioinfo:EmptyInput','Input is empty.');
end

if ~ischar(pirtext)
    error('Bioinfo:PIRReadInvalidInput','The input should be a filename or an PIR format text string.');
end

if size(pirtext,1)>1  % is padded string
    pirtextCell = cell(size(pirtext,1),1);
    for i=1:size(pirtext,1)
        pirtextCell(i)=strread(pirtext(i,:),'%s','whitespace','');
        pirtextCell{i}(find(~isspace(pirtextCell{i}),1,'last')+1:end)=[];
    end
    pirtext=pirtextCell;
    clear pirtextCell;
    % try then if it is an url
elseif (strfind(pirtext(1:min(10,end)), '://'))
    % must be a URL
    if (~usejava('jvm'))
        error('Bioinfo:NoJava','Reading from a URL requires Java.')
    end
    try
        pirtext = urlread(pirtext);
    catch
        error('Bioinfo:CannotReadURL','Cannot read URL "%s".',pirtext);
    end
    % clean up any &amp s
    pirtext=strrep(pirtext,'&amp;','&');
    % try then if it is a valid filename
elseif  (exist(pirtext) == 2 || exist(fullfile(cd,pirtext)) == 2)
    pirtext = textread(pirtext,'%s','delimiter','\n','whitespace','');
    pirtext=char(pirtext);
else % must be a string with '\n', convert to cell
    pirtext = strread(pirtext,'%s','delimiter','\n');
    if numel(pirtext) == 1
        error('Bioinfo:CannotReadPIRFile','Cannot open file "%s".',char(pirtext));
    end
    pirtext=char(pirtext);
end


%line number
ln = 1;

while ln < size(pirtext,2),
    % check for end of data
    if ln >= size(pirtext,1)
        break
    end

    %ENTRY
    typestart = regexp(pirtext(ln,:),'#type');
    data.Entry = removeblanks(pirtext(ln,6:(typestart-1)));

    [typenamestart typenamefinish] = regexp(pirtext(ln,:),'(complete|fragments|fragment)');
    data.EntryType = pirtext(ln,typenamestart:typenamefinish);
    ln = ln+1;

    % check for end of data
    if ln >= size(pirtext,1)
        break
    end


    %TITLE
    data.Title = removeblanks(pirtext(ln,6:end));
    ln = ln+1;

    % check for end of data
    if ln >= size(pirtext,1)
        break
    end


    while ~matchstart(pirtext(ln,:),'(ALTERNATE_NAMES|CONTAINS|ORGANISM)')
        data.Entry = [data.Entry removeblanks(pirtext(ln,1:end))];
        ln = ln+1;
    end

    %ALTERNATE_NAMES
    if matchstart(pirtext(ln,:),'ALTERNATE_NAMES')
        data.AlternateNames = removeblanks(pirtext(ln,16:(typestart-1)));
        ln = ln+1;
        while ~matchstart(pirtext(ln,:),'(CONTAINS|ORGANISM)')
            data.AlternateNames = [data.AlternateNames removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end
    end

    %CONTAINS
    if matchstart(pirtext(ln,:),'CONTAINS')
        data.Contains = removeblanks(pirtext(ln,9:end));
        ln = ln+1;
        while ~matchstart(pirtext(ln,:),'ORGANISM')
            data.Contains = [data.Contains removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end
    end


    %ORGANISM
    orgText = removeblanks(pirtext(ln,9:end));
    ln = ln+1;

    while ~matchstart(pirtext(ln,:),'(PLACEMENT|DATE)')
        orgText = [orgText ' ' removeblanks(pirtext(ln,1:end))];
        ln = ln+1;
    end

    [orgfieldstart orgfieldfinish] = regexp(orgText,'\#[-\w]*');

    for n = 1:(numel(orgfieldstart)-1)
        fieldname = orgText(orgfieldstart(n)+1:orgfieldfinish(n));
        fieldname(~isletter(fieldname)) = '_';
        data.Organism.(fieldname) = removeblanks(orgText(orgfieldfinish(n)+1:orgfieldstart(n+1)-1));
    end
    if n > 1,
        fieldname = orgText(orgfieldstart(n+1)+1:orgfieldfinish(n+1));
        fieldname(~isletter(fieldname)) = '_';
        data.Organism.(fieldname) = removeblanks(orgText(orgfieldfinish(n+1)+1:end));
    end


    %PLACEMENT
    if matchstart(pirtext(ln,:),'PLACEMENT')
        data.Placement = removeblanks(pirtext(ln,9:(typestart-1)));
        ln = ln+1;
        while ~matchstart(pirtext(ln,:),'DATA')
            data.Placement = [data.Placement removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end
    end

    %DATE
    dateText = removeblanks(pirtext(ln,5:end));
    ln = ln+1;

    while ~matchstart(pirtext(ln,:),'ACCESSIONS')
        dateText = [dateText ' ' removeblanks(pirtext(ln,1:end))];
        ln = ln+1;
    end

    [data.Date.Created,dateText] = strtok(dateText);

    [datefieldstart datefieldfinish] = regexp(dateText,'\#[-\w]*');

    for n = 1:(numel(datefieldstart)-1)
        fieldname = dateText(datefieldstart(n)+1:datefieldfinish(n));
        fieldname(~isletter(fieldname)) = '_';
        data.Date.(fieldname) = removeblanks(dateText(datefieldfinish(n)+1:datefieldstart(n+1)-1));
    end
    if numel(datefieldstart) > 1,
        fieldname = dateText(datefieldstart(n+1)+1:datefieldfinish(n+1));
        fieldname(~isletter(fieldname)) = '_';
        data.Date.(fieldname) = removeblanks(dateText(datefieldfinish(n+1)+1:end));
    end



    %ACCESSIONS
    data.Accessions = removeblanks(pirtext(ln,11:end));
    ln = ln + 1;

    %REFERENCE
    refcount = 0;

    while 1
        refcount = refcount + 1;
        if ~matchstart(pirtext(ln,:),'REFERENCE')
            break
        end

        %REFERENCE number
        data.Reference{refcount}.number = removeblanks(pirtext(ln,10:end));
        ln = ln+1;
        refText = [' ' removeblanks(pirtext(ln,1:end))];
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(REFERENCE|GENETICS|COMPLEX|FUNCTION|CLASSIFICATION|KEYWORDS)')
            refText = [refText ' ' removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end

        [reffieldstart reffieldfinish] = regexp(refText,' \#[-\w]+');


        for n = 1:(numel(reffieldstart)-1)
            fieldname = refText(reffieldstart(n)+2:reffieldfinish(n));
            fieldname(~isletter(fieldname)) = '_';
            if strcmp(fieldname,'accession')
                data.Reference{refcount}.(fieldname).number = removeblanks(refText(reffieldfinish(n)+1:reffieldstart(n+1)-1));
            else
                data.Reference{refcount}.(fieldname) = removeblanks(refText(reffieldfinish(n)+1:reffieldstart(n+1)-1));
            end
        end
        if numel(reffieldstart) > 1,
            fieldname = refText(reffieldstart(n+1)+2:reffieldfinish(n+1));
            fieldname(~isletter(fieldname)) = '_';
            if strcmp(fieldname,'accession')
                data.Reference{refcount}.(fieldname).number = ...
                    removeblanks(refText(reffieldfinish(n+1)+1:min(regexp(refText,'\#\#')-1,end)));
            else
                data.Reference{refcount}.(fieldname) = removeblanks(refText(reffieldfinish(n+1)+1:end));
            end
        end

        %subfields
        [subreffieldstart subreffieldfinish] = regexp(refText,' \#\#[-\w]+');
        if ~isempty(subreffieldstart)
            for n = 1:(numel(subreffieldstart)-1)
                fieldname = refText(subreffieldstart(n)+3:subreffieldfinish(n));
                fieldname(~isletter(fieldname)) = '_';
                mainfieldnameindex = find(reffieldstart < subreffieldstart(n),1,'last');
                mainfieldname = refText(reffieldstart(mainfieldnameindex)+2:reffieldfinish(mainfieldnameindex));
                mainfieldname(~isletter(mainfieldname)) = '_';
                data.Reference{refcount}.(mainfieldname).(fieldname) = removeblanks(refText(subreffieldfinish(n)+1:subreffieldstart(n+1)-1));
            end
            if numel(subreffieldstart) > 1,
                fieldname = refText(subreffieldstart(n+1)+3:subreffieldfinish(n+1));
                fieldname(~isletter(fieldname)) = '_';
                data.Reference{refcount}.(mainfieldname).(fieldname) = removeblanks(refText(subreffieldfinish(n+1)+1:end));
            end
        end
    end

    %GENETICS
    gencount = 0;

    while 1
        gencount = gencount + 1;
        if ~matchstart(pirtext(ln,:),'GENETICS')
            break
        end

        ln = ln+1;

        genText = [' ' removeblanks(pirtext(ln,1:end))];
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(COMPLEX|FUNCTION|CLASSIFICATION|KEYWORDS)')
            genText = [genText ' ' removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end

        [genfieldstart genfieldfinish] = regexp(genText,' \#[-\w]+');

        if numel(genfieldstart) > 1,
            for n = 1:(numel(genfieldstart)-1)
                fieldname = genText(genfieldstart(n)+2:genfieldfinish(n));
                fieldname(~isletter(fieldname)) = '_';
                if strcmp(fieldname,'introns')
                    data.Genetics{gencount}.(fieldname).locations = removeblanks(genText(genfieldfinish(n)+1:genfieldstart(n+1)-1));
                else
                    data.Genetics{gencount}.(fieldname) = removeblanks(genText(genfieldfinish(n)+1:genfieldstart(n+1)-1));
                end
            end

            fieldname = genText(genfieldstart(n+1)+2:genfieldfinish(n+1));
            fieldname(~isletter(fieldname)) = '_';
            if strcmp(fieldname,'introns')
                data.Genetics{gencount}.(fieldname).locations = ...
                    removeblanks(genText(genfieldfinish(n+1)+1:end));
            else
                data.Genetics{gencount}.(fieldname) = removeblanks(genText(genfieldfinish(n+1)+1:end));
            end
        else
            fieldname = genText(genfieldstart+2:genfieldfinish);
            fieldname(~isletter(fieldname)) = '_';
            if strcmp(fieldname,'introns')
                data.Genetics{gencount}.(fieldname).locations = ...
                    removeblanks(genText(genfieldfinish+1:end));
            else
                data.Genetics{gencount}.(fieldname) = removeblanks(genText(genfieldfinish+1:end));
            end

        end

        [subgenfieldstart subgenfieldfinish] = regexp(genText,' \#\#[-\w]+');
        if ~isempty(subgenfieldstart)
            for n = 1:(numel(subgenfieldstart)-1)
                fieldname = genText(subgenfieldstart(n)+3:subgenfieldfinish(n));
                fieldname(~isletter(fieldname)) = '_';
                mainfieldnameindex = find(genfieldstart < subgenfieldstart(n),1,'last');
                mainfieldname = genText(genfieldstart(mainfieldnameindex)+2:genfieldfinish(mainfieldnameindex));
                mainfieldname(~isletter(mainfieldname)) = '_';
                data.Genetics{gencount}.(mainfieldname).(fieldname) = removeblanks(genText(subgenfieldfinish(n)+1:subgenfieldstart(n+1)-1));
            end
            if numel(subgenfieldstart) > 1,
                fieldname = genText(subgenfieldstart(n+1)+3:subgenfieldfinish(n+1));
                fieldname(~isletter(fieldname)) = '_';
                data.Genetics{gencount}.introns.(fieldname) = removeblanks(genText(subgenfieldfinish(n+1)+1:end));
            end
        end
    end

    %COMPLEX
    if matchstart(pirtext(ln,:),'COMPLEX')
        data.Complex = removeblanks(pirtext(ln,8:end));
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(FUNCTION|CLASSIFICATION|KEYWORDS|FEATURE)')
            data.Complex = [data.Complex ' ' removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end
    end

    %FUNCTION
    if matchstart(pirtext(ln,:),'FUNCTION')
        fcnText = removeblanks(pirtext(ln,9:end));
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(CLASSIFICATION|KEYWORDS|FEATURE)')
            fcnText = [fcnText ' ' removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end

        [fcnfieldstart fcnfieldfinish] = regexp(fcnText,' \#[-\w]+');

        if numel(fcnfieldstart) > 1,
            for n = 1:(numel(fcnfieldstart)-1)
                fieldname = fcnText(fcnfieldstart(n)+2:fcnfieldfinish(n));
                fieldname(~isletter(fieldname)) = '_';
                data.Function.(fieldname) = removeblanks(fcnText(fcnfieldfinish(n)+1:fcnfieldstart(n+1)-1));

            end

            fieldname = fcnText(fcnfieldstart(n+1)+2:fcnfieldfinish(n+1));
            fieldname(~isletter(fieldname)) = '_';
            data.Function.(fieldname) = removeblanks(fcnText(fcnfieldfinish(n+1)+1:end));

        else
            fieldname = fcnText(fcnfieldstart+2:fcnfieldfinish);
            fieldname(~isletter(fieldname)) = '_';
            data.Function.(fieldname) = removeblanks(fcnText(fcnfieldfinish+1:end));
        end

    end

    %CLASSIFICATION
    if matchstart(pirtext(ln,:),'CLASSIFICATION')
        classText = removeblanks(pirtext(ln,9:end));
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(KEYWORDS|FEATURE)')
            classText = [classText ' ' removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end

        [classfieldstart classfieldfinish] = regexp(classText,' \#[-\w]+');

        if numel(classfieldstart) > 1,
            for n = 1:(numel(classfieldstart)-1)
                fieldname = classText(classfieldstart(n)+2:classfieldfinish(n));
                fieldname(~isletter(fieldname)) = '_';
                data.Classification.(fieldname) = removeblanks(classText(classfieldfinish(n)+1:classfieldstart(n+1)-1));

            end

            fieldname = classText(classfieldstart(n+1)+2:classfieldfinish(n+1));
            fieldname(~isletter(fieldname)) = '_';
            data.Classification.(fieldname) = removeblanks(classText(classfieldfinish(n+1)+1:end));

        else
            fieldname = classText(classfieldstart+2:classfieldfinish);
            fieldname(~isletter(fieldname)) = '_';
            data.Classification.(fieldname) = removeblanks(classText(classfieldfinish+1:end));
        end

    end

    %KEYWORDS
    if matchstart(pirtext(ln,:),'KEYWORDS')
        data.Keywords = removeblanks(pirtext(ln,9:end));
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(FEATURE)')
            data.Keywords = [data.Keywords ' ' removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end
    end

    %FEATURE
    if matchstart(pirtext(ln,:),'FEATURE')
        featText = removeblanks(pirtext(ln,8:end));
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(SUMMARY|SEQUENCE)')
            featText = [featText removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end
        bslash = [find(featText == '\') length(featText)];
        start = 1;
        for n = 1:length(bslash),
            sectionText = featText(start:bslash(n));
            start = bslash(n)+1;
            [data.Feature{n}.location,sectionText] = strtok(sectionText,' ');
            sectionText = [' ' removeblanks(sectionText)];

            if sectionText(end) == '\';
                sectionText(end) = '';
            end

            [sectionfieldstart sectionfieldfinish] = regexp(sectionText,' \#[-\w]+');

            if numel(sectionfieldstart) > 1,
                for s = 1:(numel(sectionfieldstart)-1)
                    fieldname = sectionText(sectionfieldstart(s)+2:sectionfieldfinish(s));
                    fieldname(~isletter(fieldname)) = '_';
                    data.Feature{n}.(fieldname) = removeblanks(sectionText(sectionfieldfinish(s)+1:sectionfieldstart(s+1)-1));

                end

                fieldname = sectionText(sectionfieldstart(s+1)+2:sectionfieldfinish(s+1));
                fieldname(~isletter(fieldname)) = '_';
                data.Feature{n}.(fieldname) = removeblanks(sectionText(sectionfieldfinish(s+1)+1:end));

            else
                fieldname = sectionText(sectionfieldstart+2:sectionfieldfinish);
                fieldname(~isletter(fieldname)) = '_';
                data.Feature{n}.(fieldname) = removeblanks(sectionText(sectionfieldfinish+1:end));
            end
        end
    end


    %SUMMARY
    if matchstart(pirtext(ln,:),'SUMMARY')
        sumText = [' ' removeblanks(pirtext(ln,8:end))];
        ln = ln+1;

        while ~matchstart(pirtext(ln,:),'(SEQUENCE)')
            sumText = [sumText removeblanks(pirtext(ln,1:end))];
            ln = ln+1;
        end

        [sumfieldstart sumfieldfinish] = regexp(sumText,' \#[-\w]+');

        if numel(sumfieldstart) > 1,
            for n = 1:(numel(sumfieldstart)-1)
                fieldname = sumText(sumfieldstart(n)+2:sumfieldfinish(n));
                fieldname(~isletter(fieldname)) = '_';
                data.Summary.(fieldname) = removeblanks(sumText(sumfieldfinish(n)+1:sumfieldstart(n+1)-1));

            end

            fieldname = sumText(sumfieldstart(s+1)+2:sumfieldfinish(s+1));
            fieldname(~isletter(fieldname)) = '_';
            data.Summary.(fieldname) = removeblanks(sumText(sumfieldfinish(s+1)+1:end));
        else
            fieldname = sumText(sumfieldstart+2:sumfieldfinish);
            fieldname(~isletter(fieldname)) = '_';
            data.Summary.(fieldname) = removeblanks(sumText(sumfieldfinish+1:end));
        end
    end

    %SEQUENCE
    ln = ln +1;
    seqText = pirtext(ln,:);

    while ln < size(pirtext,1)
        ln = ln+1;
        seqText = [seqText pirtext(ln,:)];
    end

    data.Sequence = seqText(isletter(seqText));

    if ln >= size(pirtext,1)
        break
    end

end






function out = removeblanks(in)
% REMOVEBLANKS removes both leading and trailing blanks
c = find(~isspace(in)) ;
if isempty(c),
    out = in([]);
else
    out = in(:,c(1):c(end));
end

function tf = matchstart(string,pattern)
%MATCHSTART matches start of string with pattern, ignoring spaces
tf = ~isempty(regexp(string,['^(\s)*?',pattern],'once'));
