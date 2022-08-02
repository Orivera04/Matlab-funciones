function errmsg = imcheck(varargin)
%IMCHECK Check an image and give an error if the image is invalid.
%
%   IMCHECK(...) checks the given image data (see below) and displays a message
%   telling whether the given image data is a valid image or not and also some
%   information about what kind of image the data was interpreted as.
%
%   MSG = IMCHECK(...) returns the message rather than displays it.  If the
%   image data is ok, then MSG will be an empty string.
%
%   IMCHECK(X, MAP) checks the indexed image represented by the index matrix X
%   and the color map MAP.  If MAP is empty, X is assumed to be a bitmap,
%   intensity image or RGB image.
%
%   IMCHECK(RGB) checks the RGB image represented by the 3-D image array RGB.
%
%   IMCHECK(I) checks the intensity image represented by the 2-D matrix I.
%
%   IMCHECK(BM) checks the bitmap image BW to a grayscale intensity image
%   represented by the intensity matrix I.
%
%   IMCHECK(R, G, B) checks the "old-style" RGB image represented by the 2-D
%   image matrices R, G and B.  This way of representing an image is deprecated
%   in favour of using a 3-D RGB array .
%
%   Class Support
%   -------------
%   The input image can be of class double, uint8 or uint16.
%
%   See also IMTYPE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:15:52 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 3, nargsin));

   msg = imgcheck(varargin{:});
   if nargout
      errmsg = msg;
   else
      if isempty(msg)
         disp('Image is OK.');
      else
         error(msg);
      end
   end

function msg = imgcheck(varargin)

   nargsin = nargin;
   valid_classes = {'double' 'uint8' 'uint16'};

   % Let IMCHECK(X,MAP) with empty MAP mean IMCHECK(RGB), IMCHECK(I) or
   % IMCHECK(BM).
   if nargsin == 2 & isempty(varargin{2})
      nargsin = 1;
   end

   msg = '';

   switch nargsin

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % IMCHECK(RGB), IMCHECK(I) or IMCHECK(BM)
      %
      case 1

         % IMCHECK(RGB), IMCHECK(I) or IMCHECK(BM)
         if ~any(strcmp(class(varargin{1}), valid_classes))
            msg = ['Truecolor/grayscale/bitmap: Image array is of an ' ...
                   'invalid class.';
            return
         end

         if ~isreal(varargin{1})
            msg = 'Truecolor/grayscale/bitmap: Image array must be real.';
            return
         end

         if isempty(varargin{1})
            msg = ['Truecolor/grayscale/bitmap: Image array can not ' ...
                   'be empty.'];
            return
         end

         if ndims(varargin{1}) > 3
            msg = ['Truecolor/grayscale/bitmap: Image array can not ' ...
                   'have more than 3 dimensions.'];
            return
         end

         if all(size(varargin{1}, 3) ~= [1 3])
            msg = ['Truecolor/grayscale/bitmap: Image array must be ' ...
                   'M-by-N or M-by-N-by-3.'];
            return
         end

         if isa(varargin{1}, 'double') & any(isnan(varargin{1}(:)))
            msg = ['Truecolor/grayscale/bitmap: Image array can not ' ...
                   'contain NaNs.'];
            return
         end

         % IMCHECK(RGB) and IMCHECK(I) only.
         if ~islogical(varargin{1}) & isa(varargin{1}, 'double')
            if max(varargin{1}(:)) > 1
               msg = ['Truecolor/grayscale: A "double" image array ' ...
                      'can not have values > 1.'];
               return
            end
            if min(varargin{1}(:)) < 0
               msg = ['Truecolor/grayscale: A "double" image array ' ...
                      'can not have values < 0.'];
               return
            end
         end

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % IMCHECK(X, MAP)
      %
      case 2

         % check classes of arrays

         if ~any(strcmp(class(varargin{1}), valid_classes))
            msg = ['Indexed: Index matrix must be "double", "uint8" ' ...
                   'or "uint16".'};
            return
         end

         if ~isa(varargin{2}, 'double')
            msg = 'Indexed: Colormap must be of class "double".';
            return
         end

         % check for complex arrays

         if ~isreal(varargin{1})
            msg = 'Indexed: Index matrix must be real.';
            return
         end

         if ~isreal(varargin{2})
            msg = 'Indexed: Colormap must be real.';
            return
         end

         % Check size (including emptyness and number of dimensions).
         % We know colormap is non-empty or we wouldn't be here.

         if isempty(varargin{1})
            msg = 'Indexed: Index matrix can not be empty.';
            return
         end

         if ndims(varargin{1}) > 2
            msg = ['Indexed: Index matrix can not have more than' ...
                   ' 2 dimensions.'];
            return
         end

         if ndims(varargin{2}) > 2
            msg = 'Indexed: Colormap can not have more than 2 dimensions.';
            return
         end

         if size(varargin{2}, 2) ~= 3
            msg = 'Indexed: A colormap must have exactly three columns.';
            return
         end

         % Check the values of the colormap.

         if any(isnan(varargin{2}(:)))
            msg = 'Indexed: Colormap can not contain NaNs.';
            return
         end
         if max(varargin{2}(:)) > 1
            msg = 'Indexed: Colormap can not have values > 1.';
            return
         end
         if min(varargin{2}(:)) < 0
            msg = 'Indexed: Colormap can not have values < 0.';
            return
         end

         colormap_length = size(varargin{2}, 1);

         % Check the values of the index matrix.

         switch class(varargin{1})
            case 'double';
               if any(isnan(varargin{1}(:)))
                  msg = 'Indexed: Index matrix can not contain NaNs.';
                  return
               end
               if min(varargin{1}(:)) <= 0
                  msg = ['Indexed: Index matrix must have only ' ...
                         'positive values.'];
                  return
               end
               maxindex = max(varargin{1}(:));
            case {'uint8' 'uint16'}
               maxindex = 1 + double(max(varargin{1}(:)));
            otherwise
               % we should never get here
               error('Internal error.');
         end

         if maxindex > colormap_length
            msg = ['Indexed: Some index values point outside of ' ...
                   'the colormap.'];
            return
         end

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % IMCHECK(R,G,B)
      %
      case 3

         if   ~isequal(class(varargin{1}), class(varargin{2})) ...
            | ~isequal(class(varargin{1}), class(varargin{3}))
            msg = ['Old-style truecolor: All three image matrices ' ...
                   'must be of the same class.'];
            return
         end

         if ~isreal(varargin{1}) | ~isreal(varargin{2}) | ~isreal(varargin{3})
            msg = ['Old-style truecolor: All three image matrices ' ...
                   'must be real.'];
            return
         end

         if   ~isequal(size(varargin{1}), size(varargin{2})) ...
            | ~isequal(size(varargin{1}), size(varargin{3}))
            msg = ['Old-style truecolor: All three image matrices ' ...
                   'must have the same size.'];
            return
         end

         % Only check first arg, since we know they all have the same size.
         if isempty(varargin{1})
            msg = ['Old-style truecolor: All three image matrices ' ...
                   'must be non-empty.'];
            return
         end

         % Only check first arg, since we know they all have the same size.
         if ndims(varargin{1}) > 2
            msg = ['Old-style truecolor: All three images matrices ' ...
                   'must be 2-D.'];
            return
         end

         if   any(isnan(varargin{1}(:))) | any(isnan(varargin{2}(:))) ...
            | any(isnan(varargin{3}(:)))
            msg = 'Old-style truecolor: A colormap can not contain NaNs.';
            return
         end

         if   max(varargin{1}(:)) > 1 | max(varargin{2}(:)) > 1 ...
            | max(varargin{3}(:)) > 1
            msg = ['Old-style truecolor: All three matrices must have ' ...
                   'values <= 1.'];
            return
         end

         if   min(varargin{1}(:)) < 0 | min(varargin{2}(:)) < 0 ...
            | min(varargin{3}(:)) < 0
            msg = ['Old-style truecolor: All three matrices must ' ...
                   'have values >= 0.'];
            return
         end

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % We should never get here.
      %
      otherwise
         msg = 'Internal error.';
   end
