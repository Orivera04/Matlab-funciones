%IMAGEDEMO Demonstrate V4's image capability.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset
colormap(gray)
format short
format compact
echo on
clc

% For any matrix X, the command
%
%    image(X)
% 
% displays a graphical image with brightness or color chosen from
% the elements of X used as indices into the colormap.  A simple,
% visually interesting, example is

     X = spiral(8), image(X)

pause      % Press any key to continue.

clc

% The spiral pattern of the matrix elements is apparent in the display.
% The small values in the center of the matrix are mapped to black
% and dark gray, while the larger values around the edge of the matrix
% are mapped to light gray and white.

X

pause      % Press any key to continue.

clc

% Color is added or changed with the "colormap" function.
% For example

    colormap(hsv)

% varies the hue in the hue-saturation-value color model.
% This is the default color map.  The map had been set with
% colormap(gray) before echo on at the beginning of this script.

pause      % Press any key to continue.

clc

% A better map for this example is

    colormap(hot)

% This ranges from black through shades of red and yellow to white.

pause      % Press any key to continue.

clc

% The quantities "hsv" and "hot" used with the colormap function are,
% of course, matrices.  (More precisely, they are the names of functions
% which return matrices.)  Color map matrices have three columns which
% specify intensities of the red, green and blue video components.  The
% number of rows depends upon the particular image.  In this example, the
% elements of X = spiral(8) range from 1 to 64, so we are using 64 rows.

    M = hot;
    size(M)

pause      % Press any key to continue.

clc

% The elements of X are used as indices into the color map and so X must
% have positive, integer elements between 1 and the length of the map.
% To see how an individual color is determined, pick one element of X, say

    X(7,1)

% The corresponding color map entry is

    M(37,:)

% This has full intensity in the red gun, a little over half intensity
% in the green gun, and no blue.  It produces the shade of orange in
% the cell in the (7,1) position near the lower left corner.

pause      % Press any key to continue.

clc

% In general, the statements

    image(X), colormap(M)

% produces a display of colored cells where the RGB intensity of
% the (i,j)-th cell is the 3-vector
%
%   M(X(i,j),:)
%
% The matrix X can be of any size, but its elements must be positive
% integers between 1 and m.  The matrix M should then have m rows,
% 3 columns, and elements between 0.0 and 1.0.
%
% colormap(M) also sets the colors used by pcolor(X), surf(Z) and
% mesh(Z), but in these cases the data matrix, X or Z, is rescaled
% to provide indices into the color map.

pause      % Press any key to continue.

clc

% A completely different feature of our spiral example is revealed by

    colormap(flag)

% The "flag" color map is simply m/4 copies of the matrix

    flag(4)

% stacked on top of each other.

pause      % Press any key to continue.

clc

% The colors red, white, blue and black are used cyclically as the
% elements of X vary and so finer details of the image data become apparent.
% In this example, we can see the diagonal patterns in the matrix

    rem(X,4)

pause      % Press any key to continue.

clc

% Since color maps are matrices, it is possible to modify them, or
% create new ones, with MATLAB's array operations.  For example
% the hot color map can be softened by adding some gray.

    S = (hot + gray)/2;
    colormap(S)

pause

% This can be brightened by raising the elements of the color map
% to a power less than 1.

    gamma = .6;
    S = S.^gamma;
    colormap(S)

pause      % Press any key to continue.

clc

% The command

    rgbplot(S)

% produces a plot of the color map.  The x-axis is the map index,
% which corresponds to the elements of X in image(X), and the y-axis
% is the intensity of the red, green and blue components.

pause      % Press any key to continue.

clc

if isstudent, echo off, format loose, return, end

% A sparse matrix display function, spy, is useful for displaying
% the location of image elements which point to a particular color
% map entry.  For example

    load cape
    spy((X==2) | (X==3))

% loads a file containing altitude data for eastern New England and
% displays all the elements which use the second or third element of
% the color map.  Locations with X==1 correspond to sea level, so we
% see a crude representation of the coast line.

pause      % Press any key to continue.

clc

% Our 8-by-8 spiral matrix is only a small, illustrative example.
% Larger matrices resulting from extensive computations, or images
% obtained from photographs, satellites or scanners are more typical.
%
% The demos directory contains several sample images with their own
% color maps and the color directory contains M-files which generate
% other useful color maps.
%
% Here is an interactive display, built with UIControls, which allows
% you to explore these images and maps.

clf
imageext

echo off
format loose
