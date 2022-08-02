function  prop = aahphob_argos(aa) 
%AAHPHOB_ARGOS calculates membrane buried helix parameter.
%
% Author(s) :  Rao M.J.K., Argos P.
% Reference :  Biochim. Biophys. Acta 869:197-214(1986).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:35 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Rao & Argos)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	1.360; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                1.270; ...% C	cysteine
                0.110; ...% D	asparatic acid
                0.250; ...% E	glutamic acid
                1.570; ...% F	phenylalanine
                1.090; ...% G	glycine
                0.680; ...% H	histidine
                1.440; ...% I	isoleucine
                NaN;... % J not used 
                0.090; ...% K	lysine
                1.470; ...% L	leucine
                1.420; ...% M	methionine
                0.330; ...% N	asparagine
                NaN;... % O not used 
                0.540; ...% P	proline
                0.330; ...% Q	glutamine
                0.150; ...% R	arginine
                0.970; ...% S	serine
                1.080; ...% T	threonine
                NaN;... % U not used 
                1.370; ...% V	valine
                1.000; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.830; ...% Y	tyrosine
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
        prop(n) = aahphob_argos(aa(n));
    end
end
