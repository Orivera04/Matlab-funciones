function model=gethmmprof(accessnum,varargin)
%GETHMMPROF retrieves profile Hidden Markov Models from the PFAM database.
%
%   MODEL = GETHMMPROF(ACCESSNUM) searches for the PFAM family accession
%   number in the PFAM database and returns a structure containing
%   information for the sequence.
%
%   MODEL = GETHMMPROF(...,'TOFILE',FILENAME) saves the data returned from
%   the PFAM database in the file FILENAME.
%
%   MODEL = GETHMMPROF(...,'MODE',MODE) returns the global alignment model
%   when MODE='ls' and the local alignment model when MODE='fs'. Default is
%   'ls'.
%
%   MODEL = GETHMMPROF(...,'MIRROR',MIRROR) selects a specific web
%   database. Options are 'Sanger' (default) or 'WUSTL'. Other mirror sites
%   can be reached by passing the complete url to PFAMHMMREAD. Note: these
%   mirrors are maintained separately, therefore slight variations may be
%   found. For more information:  http://www.sanger.ac.uk/Software/Pfam/
%   and http://pfam.wustl.edu/.
%   
%
%   Examples:
%
%       hmmmodel  = gethmmprof(2)
%       
%       hmmmodel  = gethmmprof('PF00002')
%
%       % These both retrieve an HMM profile model for global alignment to
%       % the 7-transmembrane receptor, secretin family (pfam key = PF00002).
%
%   See also GETHMMALIGNMENT, HMMPROFALIGN, HMMPROFSTRUCT, PFAMHMMREAD, SHOWHMMPROF.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.3.4.3 $   $Date: 2004/01/24 09:17:31 $


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
        % call getsangerdata with database set to 'hmm'
        model = getsangerdata(accessnum,'database','hmm',varargin{:});
    case 2
        % call getwustldata with database set to 'hmm'
        model = getwustldata(accessnum,'database','hmm',varargin{:});
end
