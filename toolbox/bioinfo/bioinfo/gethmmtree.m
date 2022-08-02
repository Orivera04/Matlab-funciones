function tree=gethmmtree(accessnum,varargin)
%GETHMMTREE retrieves phylogenetic tress from the PFAM database.
%
%   TREE = GETHMMTREE(ACCESSNUM) searches for the PFAM family accession
%   number in the PFAM database and returns an object containing
%   a phylogenetic tree representative of such protein family.
%
%   TREE = GETHMMTREE(...,'TOFILE',FILENAME) saves the data returned from
%   the PFAM database in the file FILENAME.
%
%   TREE = GETHMMTREE(...,'TYPE',TYPE) returns only the tree of the
%   alignments used to generate the HMM model when TYPE is 'seed', and
%   returns the tree of all alignments that hit the model if TYPE is
%   'full'. The default TYPE is 'full'. 
% 
%   Examples:
%
%       tree  = gethmmtree(2)
%       
%       tree  = gethmmtree('PF00002')
%
%       These both retrieve the phylogenetic tree built from the multiple
%       aligned sequences used to train the HMM profile model for global
%       alignment to the 7-transmembrane receptor, secretin family (pfam
%       key = PF00002).
%
%   See also GETHMMALIGNMENT, PHYTREEREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $   $Date: 2004/03/09 16:14:47 $


if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end

mirrorOptions = {'sanger','wustl'};
selectedMirror = 1; %default option

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
        % call getsangerdata with database set to 'tree'
        tree = getsangerdata(accessnum,'database','tree',varargin{:});
    case 2
        % call getwustldata with database set to 'tree'
        tree = getwustldata(accessnum,'database','tree',varargin{:});
end

