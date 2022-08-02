function pTable = gettables(PROJ, type)
%GETTABLES Return pointers to all available table objects in the project
%
%  PTABLE = GETTABLES(PROJ) returns a pointer vector containing pointers to
%  all of the shared tables which are available in the project.
%
%  PTABLE = GETTABLES(PROJ, type) where type is one of '1d', '2d' or 'all'
%  will further filter the returned table list to only return the type of
%  table specified.  Omitting the type argument is equivalent to specifying
%  'all'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:28:12 $ 

nodes = children(PROJ);
if ~isempty(nodes)
    % Get all cgtablenode nodes
    TP = cgtypes.cgtabletype;
    pTable = TP.filterlist(nodes);
    
    % Remove the normalizer nodes, which are a "subtype" of tables
    TP = cgtools.cgnormtype;
    pTable = TP.filterlist(pTable, 'exclude');

    if ~isempty(pTable)
        % Get table expresssions from the table nodes
        pTable = pveceval(pTable, @getdata);
        pTable = [pTable{:}];

        % Check whether user wants just 1d/2d
        if nargin>1 && ~strcmp(type, 'all')
            is2D = pveceval(pTable, @isa, 'cglookuptwo');
            is2D = [is2D{:}];
            if strcmp(type, '1d')
                pTable = pTable(~is2D);
            elseif strcmp(type, '2d')
                pTable = pTable(is2D);
            end
        end
    end
else
    pTable = null(xregpointer, 0);
end
