function sTags = pr_getDataTags(gr)
%PR_GETDATATAGS Private function to generate correct tags
%
%  TAGS = PR_GETDATATAGS(GR) returns a cell array that contains the correct
%  data tags for the graph.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:20:09 $ 

ud = gr.DataPointer.info;
switch ud.datatags
    case 1
        nT = size(ud.data, 1);
        sTags = cell(1,nT);
        for n = 1:nT
            sTags{n} = sprintf('%d', n);
        end
    case 2
        sTags = ud.customdatatags;
    otherwise
        sTags = {};
end