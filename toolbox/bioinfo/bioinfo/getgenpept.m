function gbout=getgenpept(accessnum,varargin)
%GETGENPEPT Retrieves sequence information from the NCBI GenPept database.
%
%   GBOUT = GETGENPEPT(ACCESSNUM) searches for the Accession number in the
%   GenPept database, and returns a structure containing information for
%   the sequence.
%
%   GBOUT = GETGENPEPT(...,'TOFILE',FILENAME) saves the data returned from
%   GenPept in the file FILENAME.
%
%   GBOUT = GETGENPEPT(...,'SEQUENCEONLY',true) returns only the sequence
%   for the GenPept entry as a character array.
%
%   GBOUT = GETGENPEPT(...,'FILEFORMAT',FMT) returns the sequence in the
%   specified format, FMT.  Acceptable values are 'GenPept' and 'FASTA'.
%
%   GETGENPEPT(...) will display the information to the screen without returning data
%   to a variable.  The displayed information will include hyperlinks to the URLS used to
%   search for and retrieve the data.
%
%   When the SEQUENCEONLY and TOFILE options are used together, the output file
%   is in the FASTA format.
%
%   If an error occurs while retrieving the GenPept-formatted information, then an attempt
%   is made to retrieve the FASTA-format data.
%
%   Example:
%
%       S = getgenpept('AAA59174')
%
%   This retrieves the sequence for the human insulin receptor and stores
%   it in structure S.
%
%   See http://www.ncbi.nlm.nih.gov/About/disclaimer.html for more
%   information on GenPept data.
%
%   See also GENPEPTREAD, GETEMBL, GETGENBANK, GETPDB, GETPIR.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.7 $   $Date: 2004/03/14 15:31:23 $

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end

num_argin = length(varargin);
onlySequence = false;

for n = 1:2:num_argin
    arg = lower(varargin{n});
    if strmatch(arg,'sequenceonly')
        pval = varargin{n+1};
        onlySequence =  opttf(pval);
        if isempty(onlySequence)
            error('Bioinfo:InputOptionNotLogical','SequenceOnly must be a logical value, true or false.');
        end
        continue;
    end
end

try
    if onlySequence
        % if only the sequence is desired, always use FASTA
        gb = getncbidata(accessnum,varargin{:},'database','protein','fileformat','FASTA');
    else
        % otherwise, default to GenPept format.  if the format is specified as
        % an input, then it will be used. the protein database will always be
        % used.
        gb = getncbidata(accessnum,'fileformat','GenPept','database','protein',varargin{:});
    end
catch
    le = lasterror;
    warning('Bioinfo:GenPeptDataNotFound','Unable to locate GenPept information for access number %s.  Trying FASTA...',accessnum);
    try
        gb = getncbidata(accessnum,varargin{:},'database','protein','fileformat','FASTA');
    catch
        % throw original error
        rethrow(le);
    end
end

if nargout || onlySequence || ~usejava('desktop') || any(strcmpi(varargin,'FASTA'))
    gbout = gb;
else
    for n = 1:numel(gb)
        tmp = gb(n);
        if isstruct(tmp) && isfield(tmp,'SearchURL')
            searchurl = tmp.SearchURL;
            retrieveurl = strrep(tmp.RetrieveURL,'Text','Retrieve');
            tmp = rmfield(tmp,{'SearchURL';'RetrieveURL'});
            disp(tmp);
            disp([char(9) 'SearchURL: <a href="' searchurl '">' tmp.Accession '</a>']);
            disp([char(9) 'RetrieveURL: <a href="' retrieveurl '">' tmp.GI '</a>']);
         else
            % should never get here...
            warning('Bioinfo:NoSearchURL','Expected a structure with field SearchURL.');
            disp(tmp);
        end
    end
end

