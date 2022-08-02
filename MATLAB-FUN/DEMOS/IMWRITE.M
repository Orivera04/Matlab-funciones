function imwrite(X,map,filename)
%IMWRITE Write an image file.
%	IMWRITE(X,map,'filename.raw') writes a "raw" image file used
%	by the Image Alchemy program from Handmade Software, Inc.
%	The image is in X and its colormap is in map.
%
%	See also IMREAD, IMAGE, COLORMAP.

%	C. Moler, 6/18/91, 9/19/91, 6/24/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 3, 
	filename = map;
	map = colormap;
end
if size( map, 2 ) ~= 3
	error('Invalid colormap');
end
suffix = filename(length(filename)-2:length(filename));

if strcmp(suffix,'raw')
   % Write the 32-byte header
   fp = fopen(filename,'wb','b');  % "Big-endian" byte order.
   if (fp<0) error(['Cannot open ' filename '.']), end
   [n,m] = size(X);
   p = size(map,1);
   fwrite(fp,'mhwanh','uchar');
   fwrite(fp,4,'short');
   fwrite(fp,m,'short');
   fwrite(fp,n,'short');
   fwrite(fp,p,'short');
   fwrite(fp,zeros(1,18),'uchar');
   
   % Scale and write the palette (tranpose produces row oriented output).
   map = min(255,fix(256*map));
   fwrite(fp,map','uchar');

   % Write the image, based at 0 instead of 1.
   fwrite(fp,X'-1,'uchar');
   fclose(fp);
else
   error('Image file name must end in ''raw''.')
end
