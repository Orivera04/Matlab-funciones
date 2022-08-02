function  [seq , map] = aa2int(aa)
%AA2INT converts a string of amino acids from letters to numbers.
%
%   SEQ = AA2INT(AA) converts string AA of amino acids into an array of
%   integers using the following mapping table:
%
%   A R N D C Q E G H I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *  -  ?
%   1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 0
%
%   Where B is D or N (aspartic), Z is E or Q (glutamic), X represents any
%   amino acid, * represents an end terminator, - is a gap, and ? is an
%   unknown amino acid.
%
%   Example:
%
%   s = aa2int('MATLAB')
%
%   See also AMINOLOOKUP, INT2AA, INT2NT, NT2INT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.10.4.3 $  $Date: 2004/01/24 09:17:10 $

if isempty(aa)
    seq = uint8([]);
    return
end

% If the input is a structure then extract the Sequence data.
if isstruct(aa)
    try
        aa = seqfromstruct(aa);
    catch
        rethrow(lasterror);
    end
end

origsize = size(aa);
aa = aa(:);
aa = aa';

%      A R N D C Q E G H I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  * -  ?
%
%      1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26

%     'a b  c d e f  g h i  j k  l  m  n o p  q r s  t  u v  w  x  y  z  *  -  ?'
map = uint8(...
    [1 21 5 4 7 14 8 9 10 0 12 11 13 3 0 15 6 2 16 17 0 20 18 23 19 22 24 25 0]);

aa = lower(aa);

aa = regexprep(aa,'[^a-z\-*]','?');
% trick * into being z + 1, - to z + 2 ...
aa = strrep(aa,'*',char('z' + 1));
aa = strrep(aa,'-',char('z' + 2));
aa = strrep(aa,'?',char('z' + 3));

aaLength = length(aa);
% equivalent of uint8(zeros(1,ntLength));
seq = uint8(0); seq(aaLength) = 0;

asciia = double('a');
for count = 1:length(aa)
    seq(count) = map(double(aa(count)) - asciia + 1);
end
% aauint = uint8(aa);
% seq2 = map(aauint-asciia+1);
% % When we can do math on int types
% %seq = map(uint8(aa) - uint8('a') + 1);
seq = reshape(seq,origsize);
