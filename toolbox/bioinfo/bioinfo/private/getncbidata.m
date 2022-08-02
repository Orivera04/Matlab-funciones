function gbout=getncbidata(accessnum,varargin)
% GETNCBIDATA retrieves sequence information from the NCBI databases.
%   GBOUT = GETNCBIDATA(ACCESSNUM)  searches for the Accession number in
%   the GenBank or GenPept database, and returns a structure containing
%   information for the sequence.
%
%   GBOUT = GETNCBIDATA(...,'DATABASE',DB) will search in the specified
%   database, DB, for data.  The accepted values are: 'nucleotide' or 'protein'.
%
%   GBOUT = GETNCBIDATA(...,'TOFILE',FILENAME) saves the data returned from
%   the database in the file FILENAME.
%
%   GBOUT = GETNCBIDATA(...,'FILEFORMAT',FORMAT) retrieves the data in the
%   specified format.  The accepted values are 'GenBank','GenPept',and 'FASTA'.
%
%   GBOUT = GETNCBIDATA(...,'SEQUENCEONLY',TF) returns just the sequence as
%   a character array.
%
%   Example:
%
%       nt = getncbidata('M10051','database','nucleotide')
%
%       aa = getncbidata('AAA59174','database','protein')
%
%   This retrieves the sequence from chromosome 19 that codes for the
%   Human insulin receptor and stores it in structure S.
%
%   Please see: http://www.ncbi.nlm.nih.gov/About/disclaimer.html
%
%   See also GENBANKREAD, GENPEPTREAD, GETGENBANK, GETGENPEPT.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.15.4.6 $   $Date: 2004/04/14 23:57:18 $

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end
% default to 'nucleotide'
db = 'nucleotide';
dbfrm = '';
tofile = false;
seqonly = false;
fileformat = 'GenBank';

if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'database','tofile','sequenceonly','fileformat'};
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
                case 1  % database
                    okdbs = {'nucleotide','protein'};
                    val = strmatch(lower(pval),okdbs);
                    if length(val) == 1
                        dbfrs = {'GenBank','GenPept'};
                        db = okdbs{val};
                        dbfrm = dbfrs{val};
                    else
                        if isempty(val)
                            error('Bioinfo:baddb','Invalid database name. Valid databases are ''nucleotide'', ''protein''. ')
                        else
                            error('Bioinfo:ambiguousdb','Ambiguous database name: %s.',pval);
                        end
                    end
                case 2  % tofile
                    if ischar(pval)
                        tofile = true;
                        filename = pval;
                    end
                case 3  % sequenceonly
                    seqonly = opttf(pval);
                    if isempty(seqonly)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 4 % fileformat
                    okformats = {'GenBank','GenPept','FASTA'};
                    val = strmatch(lower(pval),lower(okformats));
                    if length(val) == 1
                        fileformat = okformats{val};
                        dbfrm = '';
                    else
                        if isempty(val)
                            error('Bioinfo:badformat','Invalid file format.  Valid formats are "GenBank","GenPept", and "FASTA"');
                        else
                            error('Bioinfo:ambiguousfileformat','Ambiguous file format: %s',pval);
                        end
                    end
            end
        end
    end
end

% if a fileformat was specified as an input, then dbfrm should now be empty.  Use the
% specified format
if isempty(dbfrm)
    dbfrm = fileformat;
end

% convert accessnum to a string if it is a number
if isnumeric(accessnum)
    accessnum = num2str(accessnum);
end

% error if accessnum isn't a string
if ~ischar(accessnum)
    error('Bioinfo:NotString','Access Number is not a string.')
end

% create the url that is used
% see
%    http://www.ncbi.nlm.nih.gov/entrez/query/static/linking.html
% for more information
searchurl = ['http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Search&db=' db '&term=' accessnum '&dopt=' dbfrm '&mode=file'];

% get the html file that is returned as a string
s=urlread(searchurl);

% replace the html version of &
s=strrep(s,'&amp;','&');

% search for text indicating that the incorrect database is being used
difdbstr = 'The following term(s) refer to a different DB:';
difdbloc = strfind(s,difdbstr);

if ~isempty(strfind(s,'No items found.')) && ~isempty(difdbloc)
    switch db
        case 'nucleotide'
            error('Bioinfo:IncorrectDatabase','Use getgenpept(''%s'') to retrieve the protein record that was found.',accessnum)
        case 'protein'
            error('Bioinfo:IncorrectDatabase','Use getgenbank(''%s'') to retrieve the nucleotide record that was found.',accessnum)
    end
end

%search for text indicating that there weren't any files found
if strfind(s,'No items found')
    error('Bioinfo:NoItemsFound','The key %s was not found in the database.',accessnum) ;
end

% find first occcurrence of <a href="http://www.ncbi.nlm.nih.gov:80/entrez/query.fcgi?cmd=Retrieve&db='db'&,
% the uid(s), which identify the hits returned by the search command
basequery = ['<a href="/entrez/viewer.fcgi?db=' db];
loc=strfind(s,basequery);

if isempty(loc)
    error('Bioinfo:NCBIcorrupted','Can not interpret NCBI url data.') ;
end

% loc can be unique or have multiple links, look for labels and uid(s)
uids = regexp(s((loc(1)+length(basequery)):end),['(?<=&val=)\d*?(?=">)'],'match');
labs = regexp(s((loc(1)+length(basequery)):end),['(?<=&val=\d*?">)\w*?(?=</a>)'],'match');

% if loc is not unique then compare labels to select one
if numel(loc)>1
    sel=strmatch(lower(accessnum),lower(labs));
    if numel(sel) == 1  % found a unique label, great continue
        uids=uids(sel);
        labs=labs(sel);
    elseif isempty(sel) % could not identify which one is
        error('Bioinfo:MultipleNonRecognizedLinks','NCBI search returned several entries, but none can be identified with %s',accessnum)
    else % found multiple labels matching the accessnum, return first one
        uids=uids(sel(1));
        labs=labs(sel(1));
    end
end

% check to see if there is more than one uid listed separated by commas
uids=strread(uids{1},'%s','delimiter',',');
% now uids can have again multiple entries, but all will belong to the same
% accessnum (or label)

% multiple records returned, loop through, create a cell for each uid
genbankdata={};
retrieveurls = cell(size(uids,1),1);
for i=1:size(uids,1),
    % create url to retrieve record as text
    retrieveurls{i} = ['http://www.ncbi.nlm.nih.gov:80/entrez/query.fcgi?cmd=Text&db=' db '&uid=' uids{i} '&dopt=' dbfrm];
    temp=urlread(retrieveurls{i});
    % make each line a separate row in a string array
    templine = char(strread(temp,'%s','delimiter','\n','whitespace',''));
    genbankdata{i}=templine;
end

while isempty(deblank(genbankdata(end,:)))
    genbankdata(end,:) = [];
end

% pass data to GENBANKREAD, to create structure
try
    switch dbfrm
        case 'GenBank'
            gbout = genbankread(char(genbankdata));
        case 'GenPept'
            gbout = genpeptread(char(genbankdata));
        case 'FASTA'
            fastadata = char(genbankdata);
            % check for spaces in last
            if all(isspace(fastadata(end,:)))
                fastadata(end,:) = '';
            end
            gbout = fastaread(fastadata);
    end
catch
    error('Bioinfo:URLreturnedIncorrectData','URL did not return valid NCBI data')
    % this error is random, depends on the reliability of the Internet connection
end

%  write out file?
if tofile == true
    writefile = 'Yes';
    % check to see if file already exists
    if exist(filename,'file')
        % use dialog box to display options
        writefile=questdlg(sprintf('The file %s already exists.  Do you want to overwrite it?',filename), ...
            '', ...
            'Yes','No','Yes');
    end

    switch writefile,
        case 'Yes',
            if exist(filename,'file')
                disp(sprintf('File %s overwritten.',filename));
            end
            savedata(filename,char(genbankdata));
        case 'No',
            disp(sprintf('File %s not written.',filename));
    end

end

if seqonly == true
    gbout = gbout.Sequence;
else % add URLs
    if ~ strcmpi(fileformat,'FASTA')
        for n = 1:numel(gbout)
            gbout(n).SearchURL = searchurl;
            gbout(n).RetrieveURL = retrieveurls{i};
        end
    end
end


function savedata(filename,gbtext)

fid=fopen(filename,'wt');
rows = size(gbtext,1);
for rcount=1:rows-1
    fprintf(fid,'%s\n',gbtext(rcount,:));
end
fprintf(fid,'%s',gbtext(rows,:));
fclose(fid);
