function  prop = aaratioside(aa) 
%AARATIOSIDE calculates atomic weight ratio of hetero elements in end group to C in side chain.
%
% Author(s) :  Grantham R.
% Reference :  Science 185:862-864(1974).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:20:07 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Ratio hetero end/side';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.000; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                2.750; ...% C	cysteine
                1.380; ...% D	asparatic acid
                0.920; ...% E	glutamic acid
                0.000; ...% F	phenylalanine
                0.740; ...% G	glycine
                0.580; ...% H	histidine
                0.000; ...% I	isoleucine
                NaN;... % J not used 
                0.330; ...% K	lysine
                0.000; ...% L	leucine
                0.000; ...% M	methionine
                1.330; ...% N	asparagine
                NaN;... % O not used 
                0.390; ...% P	proline
                0.890; ...% Q	glutamine
                0.650; ...% R	arginine
                1.420; ...% S	serine
                0.710; ...% T	threonine
                NaN;... % U not used 
                0.000; ...% V	valine
                0.130; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.200; ...% Y	tyrosine
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
        prop(n) = aaratioside(aa(n));
    end
end
