function data = getblast(rid,varargin)
%GETBLAST retrieves BLAST report files from NCBI.
%
%   GETBLAST parses NCBI BLAST reports, including BLASTN, BLASTP, BLASTX,
%   TBLASTN, TBLASTX and PSI-BLAST. BLAST reports offer a fast and 
%   powerful comparative analysis of interesting protein and nucleotide
%   sequences against known structures in existing on-line databases.
%
%   DATA = GETBLAST(RID) reads a BLAST report RID, returning the data in
%   the report as a structure, DATA. The NCBI Request ID (RID) must be a
%   recently generated report - NCBI purges reports after 24 hours. 
%
%   DATA = GETBLAST(..., 'DESCRIPTIONS', NUM_DESC) includes the specified
%   number of descriptions in the report. Acceptable values are 1-100, and
%   the default is 100.
%
%   DATA = GETBLAST(..., 'ALIGNMENTS', NUM_ALGNMNTS) includes the specified
%   number of alignments in the report. Acceptable values are 1-100, and
%   the default is 50.
%
%   DATA = GETBLAST(..., 'TOFILE', FILENAME) saves the data returned from
%   the NCBI BLAST report in a file, FILENAME. The default format for the
%   file is text, but you can specify HTML with the FILEFORMAT argument.
%
%   DATA = GETBLAST(..., 'FILEFORMAT', FORMAT) returns the report in the
%   specified format, FORMAT.  Acceptable values are 'TEXT' and 'HTML'.
%
%   Examples:
%
%       % Run a BLAST search with an NCBI accession number.
%       RID = blastncbi('AAA59174','blastp','expect',1e-10)
%
%       % Then pass the RID to GETBLAST to parse the report, load it into
%       % a MATLAB structure, and save a copy as a text file.
%       report = getblast(RID,'TOFILE','Report.txt')
%
%   For more information about reading and interpreting BLAST reports, see
%   http://www.ncbi.nlm.nih.gov/Education/BLASTinfo/Blast_output.html.
%
%   See also BLASTNCBI, BLASTREAD.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.8.3 $  $Date: 2004/04/04 03:23:46 $

%   Reference: Altschul, Stephen F., Thomas L. Madden, Alejandro A.
%   Schaffer, Jinghui Zhang, Zheng Zhang, Webb Miller, and David J. Lipman
%   (1997), "Gapped BLAST and PSI-BLAST: a new generation of protein
%   database search programs",  Nucleic Acids Res. 25:3389-3402.

% verify java is available
if (~usejava('jvm'))
    error('Bioinfo:NoJava','Reading from a URL requires Java.')
end

% Set default parameters to retrieve the BLAST report
site = 'http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&RID=';
alignview = '&ALIGNMENT_VIEW=Pairwise';
desc = '&DESCRIPTIONS=100';
align = '&ALIGNMENTS=50';
showgi = '&NCBI_GI=on';
format = '&FORMAT_TYPE=text';
tofile = false;
filename = '';
fileformat = 'text';

% Check optional input arguments
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'descriptions','alignments','tofile','fileformat'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs); %#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % descriptions
                    if (isnumeric(pval) && (ismember(pval,1:100)))
                        align = ['&DESCRIPTIONS=' int2str(pval)];
                    else
                        error('Bioinfo:BadReportParam',...
                            'The number of descriptions must be between 1 and 100.');
                    end
                case 2  % alignments
                    if (isnumeric(pval) && (ismember(pval,1:100)))
                        align = ['&ALIGNMENTS=' int2str(pval)];
                    else
                        error('Bioinfo:BadReportParam',...
                            'The number of alignments must be between 1 and 100.');
                    end
                case 3  % tofile
                    if ischar(pval)
                        tofile = true;
                        filename = pval;
                    end
                case 4 % fileformat
                    okformats = {'text','html'};
                    val = strmatch(lower(pval),okformats); %#ok
                    if length(val) == 1
                        fileformat = okformats{val};
                    else
                        if isempty(val)
                            error('Bioinfo:badformat','Invalid file format.  Valid formats are "text", and "html"');
                        else
                            error('Bioinfo:ambiguousfileformat','Ambiguous file format: %s',pval);
                        end
                    end
            end
        end
    end
end

% Check for a valid RID type and format
if iscellstr(rid)
    rid=char(rid);
end
if regexpi(rid,'\d+-\d+-\d+\.BLASTQ\d')
    htmlurl = [site rid alignview desc align showgi];
    texturl = [htmlurl format];
else
    error('Bioinfo:InvalidRID','Invalid RID "%s".',rid);
end

% Verify valid report results
blasttext = urlread(texturl);

% Find first line of the QBlast Info
start = regexp(blasttext,'QBlastInfoBegin\n');
RID=regexpi(blasttext,'\d+-\d+-\d+\.BLASTQ\d','match','once');

% search for error message
blasterror = regexp(blasttext,'ERROR:[^<]*','match','once');
if isempty(blasterror) && isempty(start)
    error('Bioinfo:BlastSearchUnknownError',...
        'Unknown problem submitting BLAST search request: %s.',RID);
end

if ~isempty(blasterror)
    blasterror = regexprep(blasterror,'ERROR: ','');
    error('Bioinfo:BlastSearchError','%s.',blasterror);
end

if regexp(blasttext,'WAITING') % search for waiting message
    wait=regexp(blasttext,'\d*?(?=</b> seconds)','match','once');
    if isempty(wait)
        error('Bioinfo:BlastSearchWaiting',...
            'BLAST %s is unavailable - try later.',RID);
    else            
        error('Bioinfo:BlastSearchWaiting',...
            'BLAST %s is unavailable - try again in %s seconds.',RID,wait);
    end
elseif regexp(blasttext,'No significant similarity found') % search for no similarity
    error('Bioinfo:BlastNoSimilarity',...
        '%s: No results - no significant similarity found.',RID);
end

%  Write out file?
if tofile == true
    fout = filename;
    if strcmpi(fileformat,'html')
        savedata(fout,htmlurl);
        fout = tempname;
    end
else
    fout = tempname;
end
fpath = savedata(fout,texturl); % text file output is used for parsing
fid = fopen(fpath);
blasttext = fread(fid,'*char')';
fclose(fid);

% Parse the text file output
data = blastread(blasttext);

% Delete the temp file
if ~strcmp(filename, fout)
    delete(fout);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fpath = savedata(filename,retrieveurl)
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
                [fpath,fstatus] = urlwrite(retrieveurl,filename);
                if fstatus == 0
                    if regexpi(lasterr,'memory')
                        error('Bioinfo:FileTooBig','The BLAST report is too large: %s',...
                        lasterr);
                    else
                        error('Bioinfo:CannotGetURL','Cannot get the URL: %s',...
                        lasterr);
                    end
                end
        case 'No',
            disp(sprintf('File %s not written.',filename));
    end
