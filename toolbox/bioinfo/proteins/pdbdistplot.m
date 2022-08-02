function  pdbdistplot(ID,threshold)
%PDBDISTPLOT displays distances between residues in a PDB structure.
%
%   PDBDISTPLOT(PDBID) retrieves entry PDBID from the PDB database and
%   creates a heat map showing inter residue distances and a spy plot
%   showing the residues where the minimum distances apart are less than 7
%   Angstroms. PDBID can also be the name of a variable or a file
%   containing a PDB structure.
%    
%   PDBDISTPLOT(PDBID,DIST) allows you to specify the threshold distance in
%   Angstroms to be shown on the spy plot. The default is 7.
%
%   Example:
%
%   Show spy plot at 7 Angstroms of rat calmodulin-dependent protein kinase.
%
%      pdbdistplot('5CYT');
%
%   Now take a look at 12 Angstroms.
%
%      pdbdistplot('5CYT',12);
%
%   See also GETPDB, PDBREAD.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.7.4.4 $  $Date: 2004/03/22 23:53:43 $

if nargin == 0
    error('Bioinfo:EmptyInput','Input is empty.');
end

if nargin < 2
    threshold = 7;
end

%read the pdb entry
%ID must either a structure, a pdb file, or a valid PDBID.
try
    if (~isstruct(ID))
        if exist(ID,'file')
            pdbstruct = pdbread(ID);
        else
            pdbstruct = getpdb(ID);
        end
    else
        pdbstruct = ID;
    end
catch
    error('Bioinfo:PdbdistplotInvalidInput', ...
          'The input should be a structure of data, a pdb file, or a valid PDBID.');
end

%threshold must be numeric
if ~isnumeric(threshold)
    error('Bioinfo:PdbdistplotNumeric','THRESHOLD must be a numeric value.');
end

% If there are multiple chains, we will look at them separately

numSequences = numel(pdbstruct.Sequence);

for seq = 1:numSequences
    % get IDs for current chain
    chainID =  pdbstruct.Sequence(seq).ChainID;
    
    % get coords of Atoms and HeterogenAtoms
    chainCoords = [pdbstruct.Atom.chainID]' ==chainID;
    hetCoords = [pdbstruct.HeterogenAtom.chainID]' == chainID;
    
    % Create Nx3 matrix of 3D coords
    coords = [pdbstruct.Atom(chainCoords).X pdbstruct.HeterogenAtom(hetCoords).X;
        pdbstruct.Atom(chainCoords).Y pdbstruct.HeterogenAtom(hetCoords).Y;  
        pdbstruct.Atom(chainCoords).Z pdbstruct.HeterogenAtom(hetCoords).Z; ]';
    
    
    order = [pdbstruct.Atom(chainCoords).resSeq,...
            pdbstruct.HeterogenAtom(hetCoords).resSeq;];
    % calculating and plotting pairwise distances is memory intensive. Stop
    % if we have more than 2000 coordinates.
    if numel(order) > 2000
        % we could break the model up into blocks to deal with the memory
        % required for very large proteins, but even so we will still have to
        % calculate all the pairwise distances which will take a long time.
        if numSequences > 1
            warning('Bioinfo:PDBDistChainTooLong','Chain %d is too long.',seq);
            continue
        else
            error('Bioinfo:PDBDistModelTooBig','Model is too large.')
        end
    end
    
    % reorder the matrix so that any Het atoms that should be intersperced
    % with normal atoms are in the correct order.
    [order, perm] = sort(order);
    
    % make sure that we start counting at 1
    if order(1) < 1
        order = order + (1-order(1));
    end
    coords = coords(perm,:);
    % calculate pairwise distances. 
    distances = pdist(coords);
    
    figure
    % squareform takes pdist output and turns it into a square matrix.
    imagesc(squareform(distances))
    axis image
    title(sprintf('Chain %s: Inter-atomic distances',chainID) );
    
    % figure out which atoms are close
    closeAtoms = distances<threshold;
    [r,c] = find(squareform(closeAtoms));
    
    % use sparse to count how many of each residue are close to others
    interactions = sparse(order(r),order(c),1);
    
    % some hetatoms may be bound elements and not part of the actual
    % protein. We will remove them from the plot as they tend to skew it,
    % however these may be of interest.
    residues = pdbstruct.Sequence(seq).NumOfResidues;
    if residues>min(size(interactions))
        interactions(residues,residues) = 0;
    end
    
    figure
    spy(interactions(1:residues,1:residues));
    title(sprintf('Chain %s: Residues less than %.2f Angstroms apart',...
        chainID,threshold));
end

