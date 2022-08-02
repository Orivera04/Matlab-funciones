function [X,map] = imread(filename);
%IMREAD	Read an image file.
%	IMREAD('imagefile.raw') reads a "raw" image file produced by the
%	Image Alchemy program from Handmade Software, Inc.
%	[X,map] = IMREAD('imagefile.raw') returns both the image and a
%	color map, so that
%	        [X,map] = imread('imagefile.raw');
%	        image(X)
%	        colormap(map)
%	will display the result with the proper colors.
%
%	Image Alchemy can be used to convert a GIF file, for example, with
%	        alchemy -r -c 128 -z 4 imagefile.gif
%	The relevant options are:
%	        -r      Produce a "raw" file.
%	        -c 128  Limit the color map length to 128 colors.
%	        -z 4    Sort color map by luminance, so colormap(gray)
%	                works pretty well.
%
%	See also IMWRITE, IMAGE, COLORMAP.

%	C. Moler, 8/9/91, 10/28/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

dot = max(find(filename == '.'));
suffix = filename(dot+1:dot+3);

if strcmp(suffix,'raw')
   % Read and crack the 32-byte header
   
   fp = fopen(filename,'rb','b');  % "Big-endian" byte order.
   if (fp<0) error(['Cannot open ' filename '.']), end
   
   head = fread(fp,6,'uchar')';
   verno = fread(fp,1,'ushort');
   n = fread(fp,1,'ushort');
   m = fread(fp,1,'ushort');
   p = fread(fp,1,'ushort');
   notused = fread(fp,18,'uchar');
   
   if ~strcmp(head,'mhwanh') | (verno ~= 4)
      disp(['header = ' head]);
      disp(['verno  = ' int2str(verno)]);
      error([filename ' is not an HSI version 4 raw image ' ...
             'from Image Alchemy version 1.5.']);
   end
   
   % Read the palette and scale to [0,1).
   
   map = fread(fp,[3,p],'uchar')'/256;
   
   % Read the image
   
   [X,l] = fread(fp,[n,m],'uchar');
   if l ~= m*n, l, error('HSI image file is wrong length'), end
   % Image elements are colormap indices, so start at 1.
   X = X'+1;
   fclose(fp);
else
   error('Image file name must end in ''raw''.')
end
