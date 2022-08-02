function align=gethmmalignment(accessnum,varargin)
%GETHMMALIGNMENT retrieves multiple sequences aligned to a PFAM profile HMM.
%
%   SEQS = GETHMMALIGNMENT(PFID) retrieves multiple sequences aligned to
%   profile Hidden Markov Model PFID in the PFAM database. 
%
%   SEQS = GETHMMALIGNMENT(..., 'TOFILE', FILENAME) saves the data returned
%   from the PFAM database in the file FILENAME. 
%
%   SEQS = GETHMMALIGNMENT(..., 'TYPE', TYPE) returns only the alignments
%   used to generate the HMM model when TYPE is 'seed', and returns all
%   alignments that hit the model if TYPE is 'full'. The default TYPE is
%   'full'. 
%
%   SEQS = GETHMMALIGNMENT(..., 'MIRROR', MIRROR) selects a specific web
%   database. Options are 'Sanger' (default) or 'WUSTL'. Other mirror sites
%   can be reached by passing the complete url to FASTAREAD. Note: these
%   mirrors are maintained separately, therefore slight variations may be
%   found. For more information:  http://www.sanger.ac.uk/Software/Pfam/
%   and http://pfam.wustl.edu/.
%
%   Examples:
%
%       pfamalign = gethmmalignment(2, 'type', 'seed')
%       
%       pfamalign = gethmmalignment('PF00002', 'type', 'seed')
%
%       % These both retrieve a multiple alignment of the sequences used to
%       % train the HMM profile model for global alignment to the
%       % 7-transmembrane receptor, secretin family (pfam key = PF00002).
%
%   See also FASTAREAD, GETHMMPROF, GETHMMTREE, MULTIALIGNREAD, PFAMHMMREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.3.4.5 $   $Date: 2004/04/01 15:57:57 $


if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end


mirrorOptions = {'sanger','wustl'};
selectedMirror = 1; %default option

% find if one of the input args is a mirror selector
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
        elseif k==5 % mirror
            selectedMirror = strmatch(lower(pval),mirrorOptions);
            if isempty(selectedMirror)
                error('Bioinfo:InvalidMirror','Invalid mirror name.')
            end
        end
    end
end

switch selectedMirror
    case 1
        % call getsangerdata with database set to 'align'
        align = getsangerdata(accessnum,'database','align',varargin{:});
    case 2
        % call getwustldata with database set to 'align'
        align = getwustldata(accessnum,'database','align',varargin{:});
end
