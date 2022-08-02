function a = aaabsorbance(aa)
%AAABSORBANCE calculates the absorbance of an amino acid sequence.
%
%  AAABSORBANCE(AA) returns the absorbance (or optical density) of the
%  amino acid sequence AA.

% Author(s) : Gill S.C., von Hippel P.H.
% Reference : Anal. Biochem. 182:319-326(1989).

%   $Revision: 1.1.6.2 $  $Date: 2004/01/24 09:19:17 $
%   Copyright 2003-2004 The MathWorks, Inc.


if ~nargin
    a = [];
    return
elseif ~isaa(aa)
    error('Bioinfo:NotAnAminoAcid','The input is not an amino acid sequence.');
end

e = aaextinctioncoefficient(aa);

a = e / sum(aamolecularweight(aa));
