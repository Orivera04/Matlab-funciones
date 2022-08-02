%HISTO Histogram.
% histogram = histo(x) bins each element of x into
% the container for the nearest whole integer
% and returns the number of elements in each container.
%
%   h =  histo( [ 9 9 9 9 2 2 3 3 4 5 9 ]' )'
% returns h = [ 0 0 2 2 1 1 0 0 0 5 ]
% meaning that
% "0" (-inf to +0.5) never occurred,
% "1" (0.5 to 1.5) never occurred,
% "2" (1.5 to 2.5) occurred twice,
% ...
% "9" (8.5 to 9.5) occurred 5 times.
%
% If x is a matrix,
% histo(x) does every column independently.
% In short, h=histo(x) returns exactly the same results as
% h=hist( x,0:max(x(:)) ), but many times faster.
%
% Usage:
%   cameraman =  imread('cameraman.tif');
%   histogram = histo( cameraman(:) );
%   figure; stem(histogram)
%   diff_cameraman = ...
%     [ double(cameraman(1,:)); diff(double(cameraman)) ];
%   minimum = min(diff_cameraman(:));
%   histogram2 = histo( diff_cameraman(:)-minimum );
%   figure;
%   stem( minimum + (0:length(histogram2)-1), histogram2 );
%
% See also HIST, HISTMULTI5, IMHIST, HISTEQ,
% HUFFMANLENGTH, ENTROPY.

% See "hist.c"
% http://www.mathworks.com/support/ftp/graphicsv4.shtml
% ftp://ftp.mathworks.com/pub/contrib/v4/graphics/hist.c
% for a C Mex file to speed up histograms even faster.

% Change log:
% 1999-07-07:DAV: put online at
%   http://OIL.okstate.edu/~caryd/program/histo.m
% 1999-07-06:DAV: Works under Matlab 5.1. Did some tests:
%   x = double(imread('cameraman.tif')); x = x(:);
%   % These should give identical results for any column vector,
%   % even if it has values outside the range 0...255.
%   h0=histo( x ); % takes 0.02 s
%   h1=histmulti5( x, (0:max(x))'-0.5 );
%   h1(1) = h1(1) + nnz( x<0 ); % takes 1.2 s
%   h2=hist( x, 0:max(x(:)) )'; % takes 24 s
%   isequal( h0, h1, h2 ) % returns 1, indicating identical.
%   % imhist() only works with values in the range 0...255.
%   h3=hist( uint8(x), 0:max(x(:)) )'; % takes 32 s
%   h4=imhist( uint8(x) ); % takes 0.01 s
%   h5 = zeros(256,1); h5(1:length(h0)) = h0;

%   isequal( h0, h5 ) % returns 1, indicating identical.
% 1999-07-06:DAV: Added imhist() speedup.
% 1999-07-05:DAV: Discovered the sparse() one-line trick
%   from "histmulti" by
%   Hans.Olsson@dna.lth.se
%   http://www.mathworks.com/support/ftp/graphicsv5.shtml
%   ftp://ftp.mathworks.com/pub/contrib/v5/graphics/hist/histmulti5.m
%   Now it goes over twice as fast as my "sort()"-based histo.
%   when finding the histogram of cameraman(:).
% 1999-06-29:DAV: Invented a new "sort()"-based algorithm.
%    completely changed; reduced time
%    a factor of 10 on cameraman
%   (from 21 seconds to 2.4 seconds on my machine).
% 1999-06-29:DAV: factored "frequency" into 2 routines,
%   "frequency" and "histo".
% 1999-06-24:DAV: David Cary <d.cary@ieee.org> added documentation
% ???:JCK: John C. Kieffer wrote original "frequency.m"
%   http://www.ee.umn.edu/users/kieffer/programs.html

function histogram = histo(raw_data)
if(2<ndims(raw_data)),

   error('Sorry, can''t handle that many dimensions yet.')
end;

[rows,columns] = size(raw_data);


bins = 1+round(double( max(raw_data(:)) ));
if( bins <= 256 )
   % If so, we can use the blazing fast imhist() function.
   histogram = zeros( 256, columns );
   if( isa( raw_data, 'uint8' ) )
      x = raw_data;

   else,
      i = find(raw_data<0);

      x = uint8(round(raw_data));

      x(i) = 0;

   end;
   
   for i=1:columns;

      histogram( :, i ) = imhist( x( :, i ) );
   end;
   histogram = histogram( 1:bins, : );
   
else,
   % Too many bins for imhist() to handle.
   
   x = round(double(raw_data));

   % make sure all values less than 0 get collapsed to 0,
   % then shift up so min(x(:))==1.

   x = (x .* (0 < x)) + 1;
   
   if( 1 == columns ),
      % If so, we can use this slightly faster version
      histogram = full(sparse(x,1,1,bins,1));

   else,
      % throw away row information (in i).
      [i,j,s] = find(x);

      histogram = full(sparse(s,j,1,bins,columns));

   end;
end;

% end histo.m
