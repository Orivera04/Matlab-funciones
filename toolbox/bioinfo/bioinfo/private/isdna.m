function result = isdna(seq,varargin)
%ISDNA True for DNA sequences.
%   ISDNA(SEQ) returns 1 for a DNA sequence, 0 otherwise. Valid symbols are
%   A,C,G,T,N,R,Y,K,M,S,W,B,D,H,V and *.
%
%   ISDNA(...,'ACGTOnly',true) returns 1 only if the sequence contains
%   A,C,G and T only.   
%
%   See also ISNT, ISRNA, ISAA.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.5.4.1 $  $Date: 2004/01/24 09:18:37 $

if ischar(seq)
    if any(lower(seq) == 'u')
        result = false;
        return
    end
end
result = isnt(seq,varargin{:});
