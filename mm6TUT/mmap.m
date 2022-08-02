function map=mmap(c,m)
%MMAP Single Color Colormap. (MM)
% MMAP(C,M) makes a colormap of length M starting with the basic
% colorspec C. The map changes from dark to light, but does not
% include black or white.
% MMAP(C) is the same length as the current colormap.
%
% Example: mmap('w') is a white/gray colormap
%          mmap('y') is a yellow colormap
%          mmap([.49 1 .83]) is an auqamarine colormap
%          mmap('c',20) is a cyan colormap having length 20.
%          mmap('c') is the default if C can not be interpreted.
%
% Apply using: colormap(mmap(c,m))
%
% See also COLORMAP, RAINBOW

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 4/17/95, revised 8/21/96, 1/14/97, 1/25/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<=1, m=size(get(gcf,'colormap'),1); end
if nargin==0, c=[1 1 1]; end
colors='wymcrgb';
rgb=[0 0 0;1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1];
if ischar(c)  % colorspec is a letter
   i=find(c==colors);
   if isempty(i), i=1;end
   c=rgb(i,:);  % convert it to an rgb vector
end
if all(c==0), c=[1 1 1]; end % don't allow a black colormap!

c=c./max(c);   % normalize values
n=ceil(1.3*m); % throw out black end of gray colormap
map=gray(n);   % generate gray colormap to colorize

map=map(n-m+1:n,:)*diag(c);
