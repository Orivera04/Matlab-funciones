function istable = cgsl2expristabletype( b )
%CGSL2EXPRISTABLETYPE Return true if given block is a lookup table

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:17:41 $

% A list of mask names for tables from different strategies
TABLETYPES = {...
    'lookupone',...
    'lookuptwo',...
    'normfunction',...
    'Lookup Table (2-D)',...
    ' 3-D, piece-wise, linear interpolation',...
    '2-D, piece-wise, linear interpolation'};

blocktype = lower( get_param( b, 'BlockType' ) );
tag = get_param( b, 'Tag' );
masktype = get_param( b, 'MaskType' );

% if the blocktype OR the tag OR the masktype match a TABLETYPE this is a table block
istable = ismember(blocktype, TABLETYPES) || ismember(tag, TABLETYPES) || ismember(masktype, TABLETYPES);
