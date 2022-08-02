function  prop = aaalpha_helixroux(aa) 
%AAALPHA_HELIXROUX calculates the conformational parameter for alpha helix.
%
% Author(s) :  Deleage G., Roux B.
% Reference :  Protein Engineering 1:289-294(1987).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:21 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Alpha helix (Deleage & Roux)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	1.489; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.966; ...% C	cysteine
                0.924; ...% D	asparatic acid
                1.504; ...% E	glutamic acid
                1.195; ...% F	phenylalanine
                0.510; ...% G	glycine
                1.003; ...% H	histidine
                1.003; ...% I	isoleucine
                NaN;... % J not used 
                1.172; ...% K	lysine
                1.236; ...% L	leucine
                1.363; ...% M	methionine
                0.772; ...% N	asparagine
                NaN;... % O not used 
                0.492; ...% P	proline
                1.164; ...% Q	glutamine
                1.224; ...% R	arginine
                0.739; ...% S	serine
                0.785; ...% T	threonine
                NaN;... % U not used 
                0.990; ...% V	valine
                1.090; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.787; ...% Y	tyrosine
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
        prop(n) = aaalpha_helixroux(aa(n));
    end
end
