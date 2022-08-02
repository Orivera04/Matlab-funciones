function out=getsangerdata(key,varargin)
%GETSANGERDATA Retrieves sequence information from the PFAM database at the Sanger Institute.
%   OUT = GETSANGERDATA(KEY) queries for data identified with KEY in the
%   Sanger Institute databases, and returns a structure containing
%   information  for the protein family. Key may be a number or a string
%   containing the PFAM accession code.
%
%   GETSANGERDATA(...,'DATABASE',DB) will search in the specified 
%   database, DB, for data.  The accepted values are: 'align', 'hmm' or
%   'tree'. Default is 'align'.
%
%   GETSANGERDATA(...,'TYPE',TYPE) returns the alignments or phylogenetic
%   trees accessed by KEY. If TYPE='seed' only sequences used to generate
%   the HMM model, and if TYPE='full' all the sequences that hit the model
%   are returned. Valid only when database is 'align' or 'tree'. Default is
%   'full'.
%
%   GETSANGERDATA(...,'MODE',MODE) returns the Hidden Markov Model
%   identified by KEY. Global alignment model when MODE='ls' and Local
%   alignment model when MODE='fs'. Valid only when database is 'hmm'.
%   Default is 'ls'.
%
%   GETSANGERDATA(...,'TOFILE',FILENAME) saves the data returned from the
%   database in the file FILENAME.
%
%   Examples:
%      
%   To retrieve an hmm profile model for global alignment to the 7-transmembrane 
%   receptor, Secretin family. (pfam key = PF00002)
%      hmmmodel  = getsangerdata(2,'database','hmm','mode','ls')
%   or
%      hmmmodel  = getsangerdata('PF00002','database','hmm','mode','ls')
%
%   To retrieve the aligned sequences, which generated such model.
%      pfamalign = getsangerdata(2,'database','align','type','seed')
%
%   To retrieve all other proteins aligned to this family. 
%      pfamalign = getsangerdata(2,'database','align','type','full')
%
%   For more information:  http://www.sanger.ac.uk/Software/Pfam/
%
%   See also GETHMMALIGNMENT, GETHMMPROF, GETHMMTREE

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.4.4 $   $Date: 2004/01/24 09:18:35 $

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end

% defaults
database = 'Pfam';
script   = 'getalignment.pl';
type     = 'full' ;
mode     = 'ls';
tofile   = false;
download_model_not_tree = true;
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
                         error('Bioinfo:InvalidDatabase','Invalid database name.')
                     else
                         switch(val)
                             case 1 % query alignment
                                 database='Pfam';
                                 script='getalignment.pl';
                             case 2 % query model
                                 database='Pfam';
                                 script='download_hmm.pl';
                                 download_model_not_tree = true;
                             case 3 % query tree    
                                 database='Pfam';
                                 script='download_hmm.pl';
                                 download_model_not_tree = false;
                         end
                     end
                 case 2 % type
                     okdbs = {'full','seed'} ;
                     val = strmatch(lower(pval),okdbs);
                     if isempty(val)
                         error('Bioinfo:InvalidType','Invalid type.')
                     else
                         type = okdbs{val} ;
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
if strcmp(script,'getalignment.pl')
    searchurl = ['http://www.sanger.ac.uk/cgi-bin/' database '/' script '?acc=' key '&type=' type '&format=fal'] ;
elseif download_model_not_tree
    searchurl = ['http://www.sanger.ac.uk/cgi-bin/' database '/' script '?id=' key '&mode=' mode] ;
else
    searchurl = ['http://www.sanger.ac.uk/cgi-bin/' database '/' script '?acc=' key '&tree=tree&type=' type];
end
% get the html file that is returned as a string
try
   s = urlread(searchurl) ;
catch
   error('Bioinfo:ErrorDownloadingURL',' Error downloading URL: %s', searchurl)
end
% replace the html version of &
s=strrep(s,'&amp;','&');
% remove the start/end html markers
s=strrep(s,'<pre>','');
s=strrep(s,'</pre>', ' ' ) ;
s=strrep(s,'<PRE>','');
s=strrep(s,'</PRE>', ' ' ) ;
% pass data to respective parser, to create structure
switch script
    case 'getalignment.pl'
        out = fastaread(s);
    case 'download_hmm.pl'
        if download_model_not_tree
            out = pfamhmmread(s) ;
        else
            out = phytreeread(s) ;
        end
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
             fid=fopen(filename,'wt') ;
             fprintf(fid,'%s',s) ;
             fclose(fid) ;
        case 'No'
            disp(sprintf('File %s not written.',filename));
    end
end
