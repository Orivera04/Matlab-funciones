function  prop = aahphob_fauchere(aa) 
%AAHPHOB_FAUCHERE calculates hydrophobicity scale (pi-r).
%
% Author(s) :  Fauchere J.-L., Pliska V.E.
% Reference :  Eur. J. Med. Chem. 18:369-375(1983).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:41 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Fauchere & Pliska)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.310; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                1.540; ...% C	cysteine
                -0.770; ...% D	asparatic acid
                -0.640; ...% E	glutamic acid
                1.790; ...% F	phenylalanine
                0.000; ...% G	glycine
                0.130; ...% H	histidine
                1.800; ...% I	isoleucine
                NaN;... % J not used 
                -0.990; ...% K	lysine
                1.700; ...% L	leucine
                1.230; ...% M	methionine
                -0.600; ...% N	asparagine
                NaN;... % O not used 
                0.720; ...% P	proline
                -0.220; ...% Q	glutamine
                -1.010; ...% R	arginine
                -0.040; ...% S	serine
                0.260; ...% T	threonine
                NaN;... % U not used 
                1.220; ...% V	valine
                2.250; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.960; ...% Y	tyrosine
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
        prop(n) = aahphob_fauchere(aa(n));
    end
end
