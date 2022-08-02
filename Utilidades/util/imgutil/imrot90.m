function varargout = imrot90(varargin)
%IMROT90  Rotate an image N*90 degrees anticlockwise.
%
%   NEWI = IMROT90(I, N) rotates an intensity image I N*90 degrees
%   anticlockwise.
%
%   NEWBM = IMROT90(BM, N) rotates a bitmap image N*90 degrees anticlockwise.
%
%   NEWRGB = IMROT90(RGB, N) rotates an RGB image I N*90 degrees anticlockwise.
%
%   [NEWX, NEWMAP] = IMROT90(X, MAP, N) rotates an indexed image I N*90 degrees
%   anticlockwise.
%
%   [NEWR, NEWG, NEWB] = IMROT90(R, G, B, N) rotates a "old-style" RGB image
%   N*90 degrees anticlockwise.
%
%   See also ROT90.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:25:38 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   nargsin = nargin;
   error(nargchk(2, 4, nargsin));

   % initialize output argument list
   varargout = varargin(1:end-1);

   % check the rotation value
   n = varargin{end};
   if any(size(n) ~= 1) | n ~= round(n) | imag(n) | ~isfinite(n)
      error('N must be a real finite scalar integer.');
   end
   n = n - 4*floor(n/4);        % map n to {0,1,2,3}

   % rotate the arrays
   switch nargsin
      case {2, 3}
         % any "modern" image type
         varargout{1} = rot90(varargout{1}, n);
      case 4
         % "old-style" RGB image
         varargout{1} = rot90(varargout{1}, n);
         varargout{2} = rot90(varargout{2}, n);
         varargout{3} = rot90(varargout{3}, n);
   end

function B = rot90(A, n)
%ROT90 Rotate a 3D array N*90 degrees anticlockwise.

   switch n
      case 1
         B = permute(A(:,end:-1:1,:), [2 1 3]);
      case 2
         B = A(end:-1:1,end:-1:1,:);
      case 3
         B = permute(A(end:-1:1,:,:), [2 1 3]);
   end
