function Dout = xsort(d,piset,Names)
% XSORT sort x-data for transform to pi-domain
%  D = XSORT(D,PISET,NAMES) sorts the x-data in the
%  matrix D (row correspond to variables, columns to
%  records) for a transform with PISET. NAMES are
%  the variable names in the order as they appear in
%  the data matrix D

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-07

for ii=1:length(Names)
    jj = strmatch(Names{ii},piset.Name,'exact');
    if isequal(jj,[]) | isequal(jj,0)
        error('variable vectors must be consistent');
        break;
    end
    Dout(jj,:) = d(ii,:);
end
