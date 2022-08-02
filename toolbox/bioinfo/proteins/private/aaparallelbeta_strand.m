function  prop = aaparallelbeta_strand(aa) 
%AAPARALLELBETA_STRAND calculates conformational preference for parallel beta strand.
%
% Author(s) :  Lifson S., Sander C.
% Reference :  Nature 282:109-111(1979).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:20:04 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Parallel beta strand';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	1.000; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.910; ...% C	cysteine
                0.500; ...% D	asparatic acid
                0.590; ...% E	glutamic acid
                1.300; ...% F	phenylalanine
                0.790; ...% G	glycine
                0.380; ...% H	histidine
                2.600; ...% I	isoleucine
                NaN;... % J not used 
                0.590; ...% K	lysine
                1.420; ...% L	leucine
                1.490; ...% M	methionine
                0.540; ...% N	asparagine
                NaN;... % O not used 
                0.350; ...% P	proline
                0.280; ...% Q	glutamine
                0.680; ...% R	arginine
                0.700; ...% S	serine
                0.590; ...% T	threonine
                NaN;... % U not used 
                2.630; ...% V	valine
                0.890; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                1.080; ...% Y	tyrosine
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
        prop(n) = aaparallelbeta_strand(aa(n));
    end
end
