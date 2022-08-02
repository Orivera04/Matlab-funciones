function  prop = aahphob_roseman(aa) 
%AAHPHOB_ROSEMAN calculates hydrophobicity scale (pi-r).
%
% Author(s) :  Roseman M.A.
% Reference :  J. Mol. Biol. 200:513-522(1988).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:52 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Roseman)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.390; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.250; ...% C	cysteine
                -3.810; ...% D	asparatic acid
                -2.910; ...% E	glutamic acid
                2.270; ...% F	phenylalanine
                0.000; ...% G	glycine
                -0.640; ...% H	histidine
                1.820; ...% I	isoleucine
                NaN;... % J not used 
                -2.770; ...% K	lysine
                1.820; ...% L	leucine
                0.960; ...% M	methionine
                -1.910; ...% N	asparagine
                NaN;... % O not used 
                0.990; ...% P	proline
                -1.300; ...% Q	glutamine
                -3.950; ...% R	arginine
                -1.240; ...% S	serine
                -1.000; ...% T	threonine
                NaN;... % U not used 
                1.300; ...% V	valine
                2.130; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                1.470; ...% Y	tyrosine
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
        prop(n) = aahphob_roseman(aa(n));
    end
end
