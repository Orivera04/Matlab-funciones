function [FOUND, ind] = pfind( obj, b )
%PFIND Finds the cgslblock entry for the given block
%
%  [FOUND, index] = pfind( cgslblock, blockhandle )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:15:44 $ 


FOUND = false;
ind = 1:length( obj );

blocktype = get_param(b,'blocktype');
if isempty(strmatch(blocktype,{'SubSystem','S-Function'}))
    % find blocktype
    ind = strmatch(blocktype,{obj.blocktype},'exact');
    if length(ind)==1
        FOUND = true;
    end
end

if ~FOUND
    masktype = get_param(b, 'MaskType');
    % find on masktype
    ind = intersect(strmatch(masktype,{obj.masktype},'exact'), ind);
    if length(ind)==1
        FOUND = true;
    end
end

if ~FOUND
    tagtype =  get_param(b, 'Tag');
    % find on tagtype
    ind = intersect(strmatch(tagtype,{obj.tagtype},'exact'), ind);
    if length(ind)==1
        FOUND = true;
    end
end
