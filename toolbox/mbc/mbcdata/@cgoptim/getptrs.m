function ptrlist=getptrs(o)
% cgoptim get xregpointers method
% ptrlist=getptrs(o)
% recursive call to return xregpointers contained within constrain object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:28 $

ptrlist = [];

% pointers to freevariables
p = o.values;
for i = 1:length(p)
    if ~isempty(p(i)) & isvalid(p(i))
        ptrlist = [ptrlist; p(i); getptrs(info(p(i)))];
    end
end


% pointers to objective functions
OFs = o.objectiveFuncs;
for i = 1:length(OFs)
    if ~isempty(OFs(i)) & isvalid(OFs(i))
        ptrlist = [ptrlist; OFs(i); getptrs(info(OFs(i)))];
    end
end

% pointers to constraints
c = o.constraints;
for i = 1:length(c)
    if ~isempty(c(i)) & isvalid(c(i))
        ptrlist = [ptrlist; c(i); getptrs(info(c(i)))];
    end
end

% pointers to datasets
p = o.oppoints;
for i = 1:length(p)
    if ~isempty(p(i)) & isvalid(p(i))
        ptrlist = [ptrlist; p(i); getptrs(info(p(i)))];
    end
end

% pointers to oppoint values
pcell = o.oppointValues;
for i = 1:length(pcell) 
    for j = 1:length(pcell{i})
        p = pcell{i}(j);
        if ~isempty(p) & isvalid(p)
            ptrlist = [ptrlist; p; getptrs(p)];
        end
    end
end

% pointers to output items
pcell = pveceval(o.outputColumns, 'getptrs');
ptrlist = vertcat(ptrlist, o.outputColumns(:), pcell{:});
pcell = pveceval(o.outputWeightsColumns, 'getptrs');
ptrlist = vertcat(ptrlist, o.outputWeightsColumns(:), pcell{:});