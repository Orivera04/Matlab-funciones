function type = imtype(varargin)
%IMTYPE Display information about what kind of image the data represent.
%
%   IMTYPE(...) looks at the given image data (see below) and displays a
%   message telling what kind of image the data represent.
%
%   MSG = IMTYPE(...) does not display the message but returns it in the
%   variable MSG.
%
%   IMTYPE(X, MAP) assumes the image is an indexed image represented by the
%   index matrix X and the color map MAP.  If MAP is empty, X is assumed to be
%   a bitmap, intensity image or RGB image.
%
%   IMTYPE(RGB) assumes the image is an RGB image represented by the 3-D image
%   array RGB.
%
%   IMTYPE(I) assumes the image is an intensity image represented by the 2-D
%   matrix I.
%
%   IMTYPE(BM) assumes the image is a bitmap image represented by the logical
%   2-D matrix BW.
%
%   IMTYPE(R, G, B) assumes the image is an "old-style" RGB image represented
%   by the 2-D image matrices R, G and B.  This way of representing an image is
%   deprecated in favour of using a 3-D RGB array .
%
%   Note that IMTYPE performs the smallest amount of work possible to determine
%   the image type.  No sanity checking of the data is done.
%
%   Class Support
%   -------------
%   The input image can be of class double, uint8 or uint16.
%
%   See also IMCHECK.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:18:49 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 3, nargsin));

   msg = imgtype(varargin{:});
   if nargout
      type = msg;
   else
      disp(msg);
   end

function msg = imgtype(varargin)

   nargsin = nargin;
   valid_classes = {'double' 'uint8' 'uint16'};

   % Let IMTYPE(X, MAP) with empty MAP mean IMTYPE(RGB), IMTYPE(I) or IMTYPE(BM).
   if nargsin == 2 & isempty(varargin{2})
      nargsin = 1;
   end

   switch nargsin

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % IMTYPE(RGB), IMTYPE(I) or IMTYPE(BM)
      %
      case 1

         switch size(varargin{1}, 3)
            case 1
               if islogical(varargin{1})
                  msg = 'Bitmap image.';
                  return
               else
                  msg = 'Intensity image.';
                  return
               end
            case 3
               msg = 'Truecolor image';
               return
            otherwise
               error('Invalid number of planes in image array.');
         end

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % IMTYPE(X, MAP)
      %
      case 2

         msg = 'Indexed image.';
         return

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % IMTYPE(R, G, B)
      %
      case 3

         msg = '"Old-style" truecolor image.';
         return

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % We should never get here.
      %
      otherwise
         msg = 'Internal error.';

   end
