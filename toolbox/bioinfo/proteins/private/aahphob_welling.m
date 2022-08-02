function  prop = aahphob_welling(aa) 
%AAHPHOB_WELLING calculates the antigenicity value X 10.
%
% Author(s) :  Welling G.W., Weijer W.J., Van der Zee R., Welling-Wester S.
% Reference :  FEBS Lett. 188:215-218(1985).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:54 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Welling et al.)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	1.150; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                -1.200; ...% C	cysteine
                0.650; ...% D	asparatic acid
                -0.710; ...% E	glutamic acid
                -1.410; ...% F	phenylalanine
                -1.840; ...% G	glycine
                3.120; ...% H	histidine
                -2.920; ...% I	isoleucine
                NaN;... % J not used 
                2.060; ...% K	lysine
                0.750; ...% L	leucine
                -3.850; ...% M	methionine
                -0.770; ...% N	asparagine
                NaN;... % O not used 
                -0.530; ...% P	proline
                -0.110; ...% Q	glutamine
                0.580; ...% R	arginine
                -0.260; ...% S	serine
                -0.450; ...% T	threonine
                NaN;... % U not used 
                -0.130; ...% V	valine
                -1.140; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.130; ...% Y	tyrosine
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
        prop(n) = aahphob_welling(aa(n));
    end
end
