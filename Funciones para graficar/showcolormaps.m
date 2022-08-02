function showcolormaps(m)
% SHOWCOLORMAPS shows available Matlab colormaps by cycling through them.
%
% Usage:    showcolormaps(m)
%
% where m is the number of levels the colormap should have. Default is 64,
% except for vga which has (always) only 16.
%
% Next the user may cycle by entering either
%
%           1 or enter - shows next colormap
%           0          - stops
%           -1         - inverts current colormap
%
% See also INVERTCOLORMAP, COLORMAP and COLORBAR.
%
% Matlab Versions: upto 7.4
%
% TSMAT Toolbox function.

% Uilke Stelwagen, July 2007.
% Copyright (C) 1992-2007, TNO Science and Industry,
% The Netherlands.

if ~exist('m','var')
    m = 64; % default colormap length
end

map_s = [
   'hsv        - Hue-saturation-value color map.                   '
   'hot        - Black-red-yellow-white color map.                 '
   'gray       - Linear gray-scale color map.                      '
   'bone       - Gray-scale with tinge of blue color map.          '
   'copper     - Linear copper-tone color map.                     '
   'pink       - Pastel shades of pink color map.                  '
   'white      - All white color map.                              '
   'flag       - Alternating red, white, blue, and black color map.'
   'lines      - Color map with the line colors.                   '
   'colorcube  - Enhanced color-cube color map.                    '
   'vga        - Windows colormap for 16 colors.                   '
   'jet        - Variant of HSV (Matlab default).                  '
   'prism      - Prism color map.                                  '
   'cool       - Shades of cyan and magenta color map.             '
   'autumn     - Shades of red and yellow color map.               '
   'spring     - Shades of magenta and yellow color map.           '
   'winter     - Shades of blue and green color map.               '
   'summer     - Shades of green and yellow color map.             '
];
Nmaps = size(map_s,1);

disp('ShowColorMaps, cycling thru Matlab colormaps')
disp(' ')
disp('Currently available are:')
disp(map_s)
disp(' ')

figure,h=subplot(132);
colormap([deblank(map_s(1,1:10)) '(' num2str(m) ')'])
colorbar(h);title(deblank(map_s(1,:)))
next_map = 1;
j = 1;
while next_map
    if j==11
        colormap(deblank(map_s(j,1:10)))
    else
        colormap([deblank(map_s(j,1:10)) '(' num2str(m) ')'])
    end
    title(deblank(map_s(j,:)))
    next_map = input('Enter or 1 gives next, 0 stops, -1 inverts. Your choice ? ');
    if isempty(next_map)
        next_map = 1;
    end
    i_invert = 1;
    while (next_map==-1)
        map = colormap;        %
        map = map(end:-1:1,:); % equivalent to invertcolormap (also in TSMAT toolbox
        colormap(map)          %
        if i_invert>0
            title([deblank(map_s(j,:)) ' INVERTED !'])
        else
            title(deblank(map_s(j,:)))
        end
        next_map = input('Enter or 1 gives next, 0 stops, -1 inverts. Your choice ? ');
        if isempty(next_map)
            next_map = 1;
        end
        i_invert = -i_invert;
    end
    j = j+1; if j>Nmaps, j = j-Nmaps; end
end
close gcf;

