function connectdata(obj, data)
%CONNECTDATA Connect data to the layout object
%
%  CONNECTDATA(OBJ, DATA) connects the UDD object DATA to the UDD core data
%  of the layout OBJ.  This ensures that the object will be destroyed when
%  the layout is deleted.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/02/09 07:35:14 $

if ishandle(obj.g)
    for n = 1:length(data)
        h = data(n);
        if ~isnumeric(h) && ishandle(h) && ~isa(h, 'hg.GObject')
            % Connect data directly to g
            h.connect(obj.g, 'up');
        else
            % For HG objects, connect a listener to g that destroys the data
            obj.g.connectData(h);
        end
    end
end
