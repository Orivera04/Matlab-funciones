function im_out=im(varargin);
% Fuzzy inutitionistic matrix class constructor.
%   mi = inuti(Am,An) creates a fuzzy intuitionistic matrix
%   with memberhip degrees from matrix Am
%   and non-membership degres from Matrix An.
% If the new matrix is not intuitionistic i.e. Am(i,j)+An(i,j)>1 
% appears warning message, but the new object will be constructed.
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.
if length(varargin)==2
    Am = varargin{1}; % Cell array indexing
    An = varargin{2};
end

im_.m=Am;
im_.n=An;
im_out=class(im_,'im');

if ~checkim(im_out)
    disp('Warning! The created new object is NOT an intuitionistic matrix')
end