function atomcomp = atomiccomp(prtn)
%ATOMICCOMP evaluates the atomic composition of a protein sequence.
%
%   ATOMICCOMP(SEQUENCE) calculates the atomic composition of a protein
%   with amino acid sequence SEQUENCE. The results are returned in a
%   structure with fields C, H, N, O, and S.
%
%   Example:
%       pirdata = getpir('cchu','SequenceOnly',true)
%       mwcchu = atomiccomp(pirdata)
%
%   See also AACOUNT, MOLWEIGHT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/01/24 09:18:46 $

if nargin ~= 1
    error('Bioinfo:IncorrectNumberOfArguments',...
        'Incorrect number of arguments to %s.',mfilename);
end

% If the input is a structure then extract the Sequence data.
if isstruct(prtn)
    try
        prtn = seqfromstruct(prtn);
    catch
        rethrow(lasterror);
    end
end

atomcomp = struct('C',0,...
    'H',0,...
    'N',0,...
    'O',0,...
    'S',0);

if  ~isaa(prtn) 
    error('Bioinfo:NotAASequence','SEQUENCE does not appear to be a valid amino acid sequence.');
end

for aa = 1:length(prtn)
    atomcomp.C = atomcomp.C + getnumberatoms(aminoacidinfo(prtn(aa)),'C');
    atomcomp.H = atomcomp.H + getnumberatoms(aminoacidinfo(prtn(aa)),'H');
    atomcomp.N = atomcomp.N + getnumberatoms(aminoacidinfo(prtn(aa)),'N');
    atomcomp.O = atomcomp.O + getnumberatoms(aminoacidinfo(prtn(aa)),'O');
    atomcomp.S = atomcomp.S + getnumberatoms(aminoacidinfo(prtn(aa)),'S');
end

% Add terminating H and OH for protein atomic composition.
if ~isempty(prtn)
    atomcomp.H = atomcomp.H + 2;
    atomcomp.O = atomcomp.O + 1;
end

function numatoms = getnumberatoms(aa,element)

mf = aa.MolecularFormula;

[numC,theRest] = strtok(mf(2:end),'H');
numC = str2double(numC);
if isletter(theRest(2))
    numH = 1;
    theRest = theRest(2:end);
else
    [numH,theRest] = strtok(theRest(2:end),'N');
    numH = str2double(numH);
end
if isletter(theRest(2))
    numN = 1;
    theRest = theRest(3:end);
else   
    [numN,theRest] = strtok(theRest(2:end),'O');
    numN = str2double(numN);
end
%always a single digit number after Oxygen (at least 2)
if isletter(theRest(1)),
    numO = str2double(theRest(2));
else
    numO = str2double(theRest(1));
end

%see if the last element is a letter 
%(must be S, since there's only 1 in any amino acid)

if isletter(theRest(end))
    numS = 1;
else
    numS = 0;
end

% aminoacidinfo contains formula for single amino acid with H and OH on the
% termials. We need to remove these for the internal elements.
switch element
    case 'C'
        numatoms = numC;
    case 'H'
        numatoms = numH - 2;
    case 'N'
        numatoms = numN;
    case 'O'
        numatoms = numO - 1;    
    case 'S'
        numatoms = numS;
end
