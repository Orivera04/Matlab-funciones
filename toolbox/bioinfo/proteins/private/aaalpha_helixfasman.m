function  prop = aaalpha_helixfasman(aa) 
%AAALPHA_HELIXFASMAN calculates the conformational parameter for alpha helix.
%
%   AAALPHA_HELIXFASMAN(AA) calculates the conformational parameter for
%   alpha helix (computed from 29 proteins). 
%
% Author(s) :  Chou P.Y., Fasman G.D.
% Reference :  Adv. Enzym. 47:45-148(1978).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:19 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Alpha helix (Chou & Fasman)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	1.420; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.700; ...% C	cysteine
                1.010; ...% D	asparatic acid
                1.510; ...% E	glutamic acid
                1.130; ...% F	phenylalanine
                0.570; ...% G	glycine
                1.000; ...% H	histidine
                1.080; ...% I	isoleucine
                NaN;... % J not used 
                1.160; ...% K	lysine
                1.210; ...% L	leucine
                1.450; ...% M	methionine
                0.670; ...% N	asparagine
                NaN;... % O not used 
                0.570; ...% P	proline
                1.110; ...% Q	glutamine
                0.980; ...% R	arginine
                0.770; ...% S	serine
                0.830; ...% T	threonine
                NaN;... % U not used 
                1.060; ...% V	valine
                1.080; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.690; ...% Y	tyrosine
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
        prop(n) = aaalpha_helixfasman(aa(n));
    end
end
