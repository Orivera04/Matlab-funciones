function C = membership(A,B)
% MEMBERSHIP counts membership of elements of one array in another.
%
%   C = MEMBERSHIP(A,B) for the array A returns an array of the same size
%   as A containing the number of instances of the elements of A in the
%   array B. A and B can be character arrays or cell arrays of strings.
%
%   Examples: 
%   membership(1:6,pascal(3)) returns   [5 1 2 0 0 1]
%   membership('MASK','MISSISSIPI') retruns [1 0 4 0]
%   membership({'john','gul';'sim','ku'},{'sim','gul','kid','gul'}) returns
%   [0 2;1 0]
%
%   See also FREQTABLE, ISMEMBER

% Mukhtar Ullah
% June 6, 2005
% mukhtar.ullah@informatik.uni-rostock.de

if ~isa(A,class(B))
    error('A must be of or inherit the class of B')
else
    [Y,N] = freqtable(B);
    [tf,loc] = ismember(A,Y);
    C = double(tf);
    C(tf) = N(loc(tf));
end