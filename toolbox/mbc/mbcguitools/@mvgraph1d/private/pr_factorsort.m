function pr_factorsort(gr)
%GRAPH1D/PRIVATE/PR_FACTORSORT
%   Private function for sorting out any mismatch between data length and number
%   of given factors

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:16 $

%  Date: 16/9/1999

data=get(gr.line,'userdata');
sd=size(data,2);
factors=get(gr.factorsel,'userdata');
labels=get(gr.factorsel,'string');
if iscell(labels)
   labels=labels{1};
end

if isempty(factors)
   factors={};
end

% get current factor selection values
vals=get(gr.factorsel,'value');

% check values
if strcmp(labels,' ') & vals==1
   % assume a new-graph case: initialise factor numbers sequentially
   % not needed in a 1D case
else
   vals(vals>sd)=sd;
end
vals=num2cell(vals);

if ~isempty(data)
   % sort out labels to match data
   if length(factors)>=sd
      lbls=factors(1:sd);
   elseif length(factors)<sd
      lbls=cellstr([repmat('col',sd,1) num2str([1:sd]')]);
      lbls(1:length(factors))=factors;
   end
   set(gr.factorsel,{'string','value'},[{lbls},vals]);
end

return