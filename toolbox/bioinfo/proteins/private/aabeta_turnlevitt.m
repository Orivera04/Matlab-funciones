function  prop = aabeta_turnlevitt(aa) 
%AABETA_TURNLEVITT calculates normalized frequency for beta-turn.
%
% Author(s) :  Levitt M.
% Reference :  Biochemistry 17:4277-4285(1978).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:29 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Beta-turn (Levitt)';    
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.770; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.810; ...% C	cysteine
                1.410; ...% D	asparatic acid
                0.990; ...% E	glutamic acid
                0.590; ...% F	phenylalanine
                1.640; ...% G	glycine
                0.680; ...% H	histidine
                0.510; ...% I	isoleucine
                NaN;... % J not used 
                0.960; ...% K	lysine
                0.580; ...% L	leucine
                0.410; ...% M	methionine
                1.280; ...% N	asparagine
                NaN;... % O not used 
                1.910; ...% P	proline
                0.980; ...% Q	glutamine
                0.880; ...% R	arginine
                1.320; ...% S	serine
                1.040; ...% T	threonine
                NaN;... % U not used 
                0.470; ...% V	valine
                0.760; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                1.050; ...% Y	tyrosine
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
        prop(n) = aabeta_turnlevitt(aa(n));
    end
end
