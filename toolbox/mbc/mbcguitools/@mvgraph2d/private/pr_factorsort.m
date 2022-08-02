function pr_factorsort(gr)
%PR_FACTORSORT
%  Private function for sorting out any mismatch between data length and number
%  of given factors

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:35 $

ud = gr.DataPointer.info;
data=ud.data;
sd=size(data,2);
factors=ud.factors;
labels=get(gr.xfactor,'string');
if iscell(labels)
   labels=labels{1};
end

if (isempty(factors) | (iscell(factors) & isempty(factors{1})))
   factors={};
end

% factors may be two cell arrays: one for the rows when in image
% mode.  That isn't needed here.
if ~isempty(factors) & iscell(factors{1})
   factors=factors{1};
end

% get current factor selection values
vals=get([gr.xfactor;gr.yfactor],{'value'});

% check values
vals=cat(1,vals{:});
if strcmp(labels,' ') & all(vals==1)
   % assume a new-graph case: initialise factor numbers sequentially
   vals(:)=sd;
   vals(1:sd)=[1:sd];
   vals=vals(1:2);
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
   lbls=repmat({lbls},[2 1]);
   set([gr.xfactor;gr.yfactor],{'string','value'},[lbls,vals]);
end

return