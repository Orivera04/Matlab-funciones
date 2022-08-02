function  prop = aanumbercodons(aa) 
%AANUMBERCODONS calculates the number of codon(s) coding for each residue.
%
% AANUMBERCODONS calculates number of codon(s) coding for each amino acid
% using the universal genetic code. 


%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:20:03 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Number of codon(s)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	4.000; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                1.000; ...% C	cysteine
                2.000; ...% D	asparatic acid
                2.000; ...% E	glutamic acid
                2.000; ...% F	phenylalanine
                4.000; ...% G	glycine
                2.000; ...% H	histidine
                3.000; ...% I	isoleucine
                NaN;... % J not used 
                2.000; ...% K	lysine
                6.000; ...% L	leucine
                1.000; ...% M	methionine
                2.000; ...% N	asparagine
                NaN;... % O not used 
                4.000; ...% P	proline
                2.000; ...% Q	glutamine
                6.000; ...% R	arginine
                6.000; ...% S	serine
                4.000; ...% T	threonine
                NaN;... % U not used 
                4.000; ...% V	valine
                1.000; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                2.000; ...% Y	tyrosine
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
        prop(n) = aanumbercodons(aa(n));
    end
end
