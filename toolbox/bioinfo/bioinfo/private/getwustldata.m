function out=getwustldata(key,varargin)
%GETWUSTLDATA Retrieves sequence information from PFAM database at WUSTL.
%   OUT = GETWUSTLDATA(KEY) queries for data identified with KEY in the
%   Washington University in St.Louis PFAM databases, and returns a
%   structure containing information for the protein family. KEY may be a
%   number or a string containing the PFAM accession code.
%
%   GETWUSTLDATA(...,'DATABASE',DB) will search in the specified 
%   database, DB, for data.  The accepted values are: 'align' or 'hmm'.
%   Default is 'align'. 
%
%   GETWUSTLDATA(...,'TYPE',TYPE) returns the alignments accessed by KEY.
%   If TYPE='seed' only sequences used to generate the HMM model, and if
%   TYPE='full' all the sequences that hit the model are returned. Valid
%   only when database is 'align'. Default is 'full'.
%
%   GETWUSTLDATA(...,'MODE',MODE) returns the Hidden Markov Model
%   identified by KEY. Global alignment model when MODE='ls' and Local
%   alignment model when MODE='fs'. Valid only when database is 'hmm'.
%   Default is 'ls'.
%
%   GETWUSTLDATA(...,'TOFILE',FILENAME) saves the data returned from the
%   database in the file FILENAME.
%
%   Examples:
%      
%   To retrieve an hmm profile model for global alignment to the 7-transmembrane 
%   receptor, Secretin family. (pfam key = PF00002)
%      hmmmodel  = getwustldata(2,'database','hmm','mode','ls')
%   or
%      hmmmodel  = getwustldata('PF00002','database','hmm','mode','ls')
%
%   To retrieve the aligned sequences, which generated such model.
%      pfamalign = getwustldata(2,'database','align','type','seed')
%
%   To retrieve all other proteins aligned to this family. 
%      pfamalign = getwustldata(2,'database','align','type','full')
%
%   For more information:  http://pfam.wustl.edu/
%
%   See also GETHMMALIGNMENT, GETHMMPROF, GETHMMTREE

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $   $Date: 2004/03/09 16:15:25 $

% Stable links in the PFAM-WUSTL site are described in
% http://pfam.wustl.edu/help/stable_link.shtml

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end

% defaults
script   = 'getalignment';
type     = 'full' ;
mode     = 'ls';
tofile   = false;
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'database','type','mode','tofile','mirror'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameter',...
			'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameter',...
			'Ambiguous parameter name: %s.',pname) ;
        else
            switch(k)
                 case 1  % database
                     okdbs = {'align','hmm','tree'} ;
                     val = strmatch(lower(pval),okdbs);
                     if isempty(val)
                         error('Bioinfo:InvalidDatbase','Invalid database name.')
                     else
                         switch(val)
                             case 1 % query alignment
                                 script='getalignment';
                             case 2 % query model
                                 script='gethmm';
                             case 3 % query tree    
                                 error('Bioinfo:InvalidDatabase',...
                                 'Phylogenetic trees are not available in the PFAM-WUSTL site.')
                         end
                     end
                 case 2 % type
                     okdbs = {'full','seed'} ;
                     val = strmatch(lower(pval),okdbs);
                     if isempty(val)
                         error('Bioinfo:InvalidType','Invalid type.')
                     else
                         type=okdbs{val} ;
                     end
                 case 3 % mode
                     okdbs = {'ls','fs'};
                     val = strmatch(lower(pval),okdbs);
                     if isempty(val)
                         error('Bioinfo:InvalidMode','Invalid mode.')
                     else
                         mode = okdbs{val} ;
                     end
                 case 4  % tofile
                     if ischar(pval)
                         tofile = true;
                         filename = pval;
                     end
                 case 5 % mirror is a ok arg, but it was already used in the 
                       % wrapper function      
            end
        end
    end
end
% convert key to a string if it is a number
if isnumeric(key) 
    str = num2str(key) ;
    key = 'PF00000' ;
    key(8-length(str):end)= str;
end
% error if key isn't a string
if ~ischar(key)
    error('Bioinfo:NotString','Access Number is not a string.')
end
% create the url that is used
if strcmp(script,'getalignment')
    searchurl = ['http://pfam.wustl.edu/cgi-bin/' script '?acc=' key '&type=' type] ;
else
    searchurl = ['http://pfam.wustl.edu/cgi-bin/' script '?name=' key '&type=' mode] ;
end
% get the html file that is returned as a string
try
   s = urlread(searchurl);
catch
   error('Bioinfo:ErrorDownloadingURL',' Error downloading URL: %s', searchurl)
end
% replace the html version of &
s=regexprep(s,'&amp;','&');
% remove the html title tag
s=regexprep(s,'<title>[^>]+</title>','');
s=regexprep(s,'<TITLE>[^>]+</TITLE>','');
% remove any other html tag
s=regexprep(s,'<[^>]+>','');

% pass data to respective parser, to create structure
switch script
    case 'getalignment'
        % WUSTL gives the multiple alignment as a plain text with html tags,
        % at this point tags have been removed, therefore the string should
        % only contain headers and sequences
        [headers,sequences] = strread(s,'%s %s \n');
        % setting the output as an structure
        out = cell2struct([headers,sequences],{'Header','Sequence'},2);
        if tofile % prepare string for file writting (fasta formatted)
           all=[headers,sequences]';
           s = sprintf('>%s\n%s\n',all{:});
        end
    case 'gethmm'
        out = pfamhmmread(s) ;
end
%  write out file?
if tofile == true
    writefile = 'Yes';
    % check to see if file already exists
    if exist(filename,'file')
        % use dialog box to display options
          writefile=questdlg(sprintf('The file %s already exists.  Do you want to overwrite it?',filename), ...
             '','Yes','No','Yes') ;
    end
    switch writefile,
        case 'Yes'
             if exist(filename,'file')
                 disp(sprintf('File %s overwritten.',filename));
             end
             fid = fopen(filename,'wt') ;
             fprintf(fid,'%s',s) ;
             fclose(fid);
        case 'No'
            disp(sprintf('File %s not written.',filename));
    end
end
