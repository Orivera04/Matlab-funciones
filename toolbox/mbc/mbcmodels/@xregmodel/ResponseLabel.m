function str= ResponseLabel(m,Trans);
% XREGMODEL/RESPONSELABEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:12 $

yi=m.Yinfo;
strj= yi.Symbol;

uct= char(yi.Units);


if ~isempty(yi.Name) & ~strcmp(strj, yi.Name) ;
	strj = [yi.Name ' (',strj,')'];
end
if ~isempty(uct) & ~strcmp(uct,'?')
	strj = [strj ' [' uct ']'];
end

if nargin>1 & Trans
    strj= [strj ' (Transformed)'];
end
str= strj;
