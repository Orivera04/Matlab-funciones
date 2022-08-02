function mw = molweight(str)
%MOLWEIGHT calculates molecular weight for a protein.
%
%   MOLWEIGHT(SEQUENCE) calculates the molecular weight of amino acid
%   sequence SEQUENCE. 
%
%   Example:
%
%       pirdata = getpir('cchu','SequenceOnly',true)
%       mwcchu = molweight(pirdata)
%
%   See also AACOUNT, ATOMICCOMP.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/01/24 09:18:49 $

if nargin == 0 
    error('Bioinfo:NotEnoughInputs','Not enough input arguments.');
end
if isempty(str)
    mw = 0;
    return
end

% If the input is a structure then extract the Sequence data.
if isstruct(str)
    try
        str = seqfromstruct(str);
    catch
        rethrow(lasterror);
    end
end

waterweight = 18.015;

if  ~isaa(str) 
    error('Bioinfo:NotAASequence','SEQUENCE does not appear to be a valid amino acid sequence.');
end

if ~ischar(str)
    str = int2aa(str);
end
mw = sum(aminoacidinfo(str,'MolecularWeight')) - (waterweight * (length(str) - 1));

