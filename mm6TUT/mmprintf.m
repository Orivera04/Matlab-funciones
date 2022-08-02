function s=mmprintf(fm,a)
%MMPRINTF Data Array to String Matrix Conversion. (MM)
% MMPRINTF(FORMAT,A) formats the numerical array A using the
% specified FORMAT string, and returns a string matrix whose
% (i)th row is the formatted (i)th element of A.
% A cannot be complex.
%
% MMPRINTF(A) uses the default FORMAT string '%.5g'
%
% See also NUM2STR, INT2STR.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/5/96, revised 9/8/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

sep=char(7);
if nargin==1
   a=fm; fm='%.5g';
end
if ~isreal(a)
   error('A Cannot be Complex.')
end
if ~ischar(fm)
   error('FORMAT Must be a String Vector.')
end
if isempty(sprintf(fm,pi))
   error('FORMAT Must be a Valid Numerical Format String.')
end
alen=length(a(:));
if alen==1  % simple scalar case
   s=sprintf(fm,a);
end
i=find(sep==fm); % strip separator from format if there
if ~isempty(i),fm(i)=[];end

v=[sep sprintf([fm sep],a)];  % catenate all input

isep=find(v==sep);            % find separators
di=diff(isep)-1;              % length of each formatted string
col=max(di);                  % longest string

s=repmat(' ',col,alen);       % blank transpose of output
istart=1+(0:alen-1)*col;
ipoke=[istart;istart+di-1];   % where to poke input into output
eval(['s([' sprintf('%.0f:%.0f ',ipoke) '])=v(v~=sep);'])
s=s';
