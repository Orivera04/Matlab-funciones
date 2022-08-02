function varargout = imfliplr(varargin)
%IMFLIPLR Flip an image left to right.
%
%   [Y, NEWMAP] = IMFLIPLR(X, MAP) flips the index image represented by the
%   index matrix X and the color map MAP in a left-right direction.  If MAP is
%   empty, X is assumed to be a bitmap, intensity image or RGB image.
%
%   NEWRGB = IMFLIPLR(RGB) flips the RGB represented by the 3-D image array RGB
%   in a left-right direction.
%
%   NEWI = IMFLIPLR(I) flips the intensity image represented by the 2-D matrix
%   I in a left-right direction.
%
%   NEWBM = IMFLIPLR(BM) flips the bitmap image represented by the logical 2-D
%   matrix BW in a left-right direction.
%
%   See also IMFLIPUD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 21:39:12 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   % Now do the actual flipping.
   varargout = varargin;
   varargout{1} = flipdim(x, 2);
