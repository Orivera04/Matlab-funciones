function gbout=getgenbank(accessnum,varargin)
%GETGENBANK retrieves sequence information from the NCBI GenBank database.
%
%   GBOUT = GETGENBANK(ACCESSNUM) searches for the accession number in the
%   GenBank database and returns a structure containing information for
%   the sequence.
%
%   GBOUT = GETGENBANK(...,'TOFILE',FILENAME) saves the data returned from
%   GenBank in the file FILENAME.
%
%   GBOUT = GETGENBANK(...,'SEQUENCEONLY',true) returns only the sequence
%   for the GenBank entry as a character array.
%
%   GBOUT = GETGENBANK(...,'FILEFORMAT',FMT) returns the sequence in the
%   specified format, FMT.  Acceptable values are 'GenBank' and 'FASTA'.
%
%   GETGENBANK(...) will display the information to the screen without returning data
%   to a variable.  The displayed information will include hyperlinks to the URLS used to
%   search for and retrieve the data.
%
%   When the SEQUENCEONLY and TOFILE options are used together, the output file
%   is in the FASTA format.
%
%   If an error occurs while retrieving the GenBank-formatted information, then an attempt
%   is made to retrieve the FASTA-format data.
%
%   Example:
%
%       S = getgenbank('M10051')
%
%   This retrieves the sequence from chromosome 19 that codes for the
%   human insulin receptor and stores it in structure S.
%
%   See http://www.ncbi.nlm.nih.gov/About/disclaimer.html for more
%   information on GenBank data.
%
%   See also GENBANKREAD, GETEMBL, GETGENPEPT, GETPDB, GETPIR.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.7 $   $Date: 2004/03/14 15:31:22 $

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
        gb = getncbidata(accessnum,varargin{:},'database','nucleotide','fileformat','FASTA');
    else
        % otherwise, default to GenBank format.  if the format is specified as
        % an input, then it will be used.  the nucleotide database will always be
        % used.
        gb = getncbidata(accessnum,'fileformat','GenBank','database','nucleotide',varargin{:});
    end
catch
    le = lasterror;
    warning('Bioinfo:GenBankDataNotFound','Unable to get GenBank information for access number %s.  Trying FASTA...',accessnum);
    try
        gb = getncbidata(accessnum,varargin{:},'database','nucleotide','fileformat','FASTA');
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
