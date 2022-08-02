function  prop = aahphob_chothia(aa) 
%AAHPHOB_CHOTHIA calculates proportion of residues 95% buried (in 12 proteins).
%
% Author(s) :  Chothia C.
% Reference :  J. Mol. Biol. 105:1-14(1976).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:38 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Chothia)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.380; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.500; ...% C	cysteine
                0.150; ...% D	asparatic acid
                0.180; ...% E	glutamic acid
                0.500; ...% F	phenylalanine
                0.360; ...% G	glycine
                0.170; ...% H	histidine
                0.600; ...% I	isoleucine
                NaN;... % J not used 
                0.030; ...% K	lysine
                0.450; ...% L	leucine
                0.400; ...% M	methionine
                0.120; ...% N	asparagine
                NaN;... % O not used 
                0.180; ...% P	proline
                0.070; ...% Q	glutamine
                0.010; ...% R	arginine
                0.220; ...% S	serine
                0.230; ...% T	threonine
                NaN;... % U not used 
                0.540; ...% V	valine
                0.270; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.150; ...% Y	tyrosine
                NaN;... % Glu or Gln	glutamic acid or glutamine
];

try
    prop = data(ndx);
catch
    prop = NaN;
end

% one vector input, call recursively for single values 
else
   prop = zeros(numel(aa),1);
    for n = 1:numel(aa),
        prop(n) = aahphob_chothia(aa(n));
    end
end
