%COLORMENU Add a color map menu to the current figure.
%	Each of the menu choices operates on the colormap:
%	HOT, PINK, COOL, BONE, JET, COPPER, FLAG and PRISM are names of
%	functions which generate color maps.
%	RAND is a random color map.
%	BRIGHTEN increases the brightness.
%	DARKEN decreases the brightness.
%	FLIPUD inverts the order of the colormap entries.
%	FLIPLR interchanges the red and blue components.
%	PERMUTE cyclic permuations: red -> blue, blue -> green, green -> red. 
%	SPIN spins the colormap, which is a rapid sequence of FLIPUD's.
%	REMEMBER pushes a copy of the current color map onto a stack.
%	RESTORE pops a map from the stack (initially, the stack contains the
%	   map in use when COLORMENU was invoked.)
%	DONE deletes the colormenu.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

stackofmaps = colormap;
lengthofmap = size(stackofmaps,1);
maps = str2mat('hsv','hot','pink','cool','bone','jet','copper','flag','prism');
colormenuh = uimenu(gcf,'label','colormaps');
for k = 1:size(maps,1);
   uimenu(colormenuh,'label',maps(k,:),'callback',['colormap(' maps(k,:) ');']);
end
uimenu(colormenuh,'label','rand', 'callback','colormap(rand(lengthofmap,3))');
uimenu(colormenuh,'label','brighten','callback','brighten(.25)');
uimenu(colormenuh,'label','darken','callback','brighten(-.25)');
uimenu(colormenuh,'label','flipud','callback','colormap(flipud(colormap))');
uimenu(colormenuh,'label','fliplr','callback','colormap(fliplr(colormap))');
uimenu(colormenuh,'label','permute', ...
   'callback','c = colormap; colormap(c(:,[2 3 1]))');
uimenu(colormenuh,'label','spin','callback','spinmap');
uimenu(colormenuh,'label','help','callback','help colormenu');
uimenu(colormenuh,'label','remember', ...
   'callback','stackofmaps = [colormap; stackofmaps];');
uimenu(colormenuh,'label','restore', ...
   'callback',['colormap(stackofmaps(1:lengthofmap,:));' ...
   'if size(stackofmaps,1)>lengthofmap,stackofmaps(1:lengthofmap,:)=[]; end']);
uimenu(colormenuh,'label','done','Callback',...
       'delete(colormenuh);clear stackofmaps lengthofmap maps colormenuh k');
