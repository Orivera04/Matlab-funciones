function varargout = imflipud(varargin)
%IMFLIPUD Flip an image upside down.
%
%   [Y, NEWMAP] = IMFLIPUD(X, MAP) flips the index image represented by the
%   index matrix X and the color map MAP in a up-down direction.  If MAP is
%   empty, X is assumed to be a bitmap, intensity image or RGB image.
%
%   NEWRGB = IMFLIPUD(RGB) flips the RGB represented by the 3-D image array
%   RGB in a up-down direction.
%
%   NEWI = IMFLIPUD(I) flips the intensity image represented by the 2-D
%   matrix I in a up-down direction.
%
%   NEWBM = IMFLIPUD(BM) flips the bitmap image represented by the logical
%   2-D matrix BW in a up-down direction.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 21:39:12 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   % Now do the actual flipping.
   varargout = varargin;
   varargout{1} = flipdim(x, 1);
