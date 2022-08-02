function d = iswhole(varargin)
% ISWHOLE True for integers(whole numbers).
%     ISWHOLE(X) is 1 for the elements of X that are integers, 0 otherwise.
%     ISWHOLE(X1,X2,..,XN) returns a 1-by-N array with 1 for integers and 0 
%     otherwise.
% ISWHOLE does not check for integer data type as does ISINTEGER.

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% University of Rostock
% November 15, 2004  

C = varargin;
nIn = nargin;

if nIn < 2
    d = C{:} == round(C{:});
else
    d = zeros(1,nIn);
    for i = 1:nIn
        d(i) = isequal(C{i},round(C{i}));
    end
end