function phytreewrite(filename,varargin)
%PHYTREEWRITE saves a phylogenetic tree object as a NEWICK format file.
%
%   PHYTREEWRITE(FILENAME, TREE) writes the contents of a phylogenetic tree
%   TREE to file FILENAME using the NEWICK format. TREE must be an object
%   created either with PHYTREE or imported using NEWICKREAD.
%
%   PHYTREEWRITE(TREE) opens a standard get file dialog box to select the
%   target filename.
%
%   Example:
%
%      seqs = int2nt(ceil(rand(10)*4));      % some random sequences
%      dist = seqpdist(seqs,'alpha','nt');   % pairwise distances
%      tree = seqlinkage(dist);              % construct phylogenetic tree
%      phytreewrite('mytree.tree',tree)      % write it to NEWICK file
%
%   See also PHYTREE, PHYTREEREAD, PHYTREETOOL, SEQLINKAGE.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Author: batserve $ $Date: 2004/03/14 15:31:37 $

overwritedlg = true;
askforfile = false;

if strcmp(class(filename),'phytree')
    tr = filename; 
    askforfile =true;
    treeWasAt = 0;
else
    if ~ischar(filename)
        error('Bioinfo:FilenameMustBeString','FILENAME must be a string.');
    end
    tr = varargin{1};
    treeWasAt = 1;
end    

if ~strcmp(class(tr),'phytree')
        error('Bioinfo:IncorrectInputType','TREE must be a Phylogenetic Tree Object');
end

% for the time being extra arguments are not documented
nvarargin = numel(varargin);
if  nvarargin > treeWasAt
    if rem(nvarargin-treeWasAt,2) == 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'overwritedlg'};
    for j=treeWasAt+1:2:nvarargin
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs); %#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        %elseif length(k)>1
        %    error('Bioinfo:AmbiguousParameterName',...
        %        'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % overwritedlg
                    overwritedlg = pval == true;
                    if strcmpi(pval,'false') 
                        overwritedlg = false;
                    end
            end
        end
    end
end

if askforfile
    [filename, pathname] = uiputfile('*.tree','Save Phylogenetic tree as');
    if ~filename
        disp('Canceled, file not written.');
        return;
    end
    filename = [pathname, filename];
    overwritedlg = false; % since I'am manually selecting the filename
                          % no warning for overwriting
end

tr=struct(tr);
B=tr.tree;
N=tr.names;
D=tr.dist;
numBranches = size(B,1);
numLeaves = numBranches + 1;
numLabels = numBranches + numLeaves; 

for i=1:numLabels-1;
    namedist{i} = [N{i} ':' num2str(D(i))]; %#ok
end
namedist{numLabels} = [N{numLabels} ';'];

% This part of code should be improved, an intelligent algorithm with a
% proper queue can avoid creating all these cells.

for i=1:numBranches
    if B(i,1) > numLeaves
        t1 = branchstr{B(i,1)};
    else
        t1 = namedist{B(i,1)};
    end
    if B(i,2) > numLeaves
        t2 = branchstr{B(i,2)};
    else
        t2 = namedist{B(i,2)};
    end
    branchstr{i+numLeaves} = ...
         [ '(\n' t1 ',\n' t2 ')\n' , namedist{i+numLeaves} ]; %#ok
end

sout=sprintf(branchstr{numLabels});

if exist(filename,'file') && overwritedlg
    % use dialog box to display options
    writefile=questdlg(sprintf('The file %s already exists.  Do you want to overwrite it?'...
        ,filename),'Save Phylogenic Tree','Yes','No','Yes');
    if strcmp(writefile,'Yes')
        disp(sprintf('File ''%s'' overwritten.',filename));
    else
        disp(sprintf('File ''%s'' not written.',filename));
        return
    end
end

fid=fopen(filename,'wt') ;
if fid == (-1)
    error('Bioinfo:CouldNotOpenFile','Could not open file %s.', filename);
end
fprintf(fid,'%s',sout) ;
fclose(fid) ;


