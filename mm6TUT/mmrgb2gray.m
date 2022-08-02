function mm=mmrgb2gray(m)
%MMRGB2GRAY Convert Colormap to Equivalent Grayscale Map.
% MMRGB2GRAY(M) returns a colormap the same size as M
% with colors replaced by their NTSC brightness components.
%
% If M is not given, the current colormap is used.
% If no output argument is provided, the current colormap
% is modified.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 7/26/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0
   Hf=mmgcf(1);
   m=colormap;
else
   if ndims(m)~=2 | size(m,2)~=3 | ...
         any(m<0) | any(m>1)
      
      error('Input is Not a Valid Colormap.')
   end
end
m=sum(diag([0.30 0.59 0.11])*m.').';
m=[m m m];
if nargout==0
   colormap(m)
else
   mm=m;
end
