function  prop = aahphob_guy(aa) 
%AAHPHOB_GUY calculates hydrophobicity scale based on free energy of transfer (kcal/mole). 
%
% Author(s) :  Guy H.R.
% Reference :  Biophys J. 47:61-70(1985).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:42 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Guy)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.100; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                -1.420; ...% C	cysteine
                0.780; ...% D	asparatic acid
                0.830; ...% E	glutamic acid
                -2.120; ...% F	phenylalanine
                0.330; ...% G	glycine
                -0.500; ...% H	histidine
                -1.130; ...% I	isoleucine
                NaN;... % J not used 
                1.400; ...% K	lysine
                -1.180; ...% L	leucine
                -1.590; ...% M	methionine
                0.480; ...% N	asparagine
                NaN;... % O not used 
                0.730; ...% P	proline
                0.950; ...% Q	glutamine
                1.910; ...% R	arginine
                0.520; ...% S	serine
                0.070; ...% T	threonine
                NaN;... % U not used 
                -1.270; ...% V	valine
                -0.510; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                -0.210; ...% Y	tyrosine
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
        prop(n) = aahphob_guy(aa(n));
    end
end
