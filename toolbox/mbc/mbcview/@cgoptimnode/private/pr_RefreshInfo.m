function pr_RefreshInfo(hInfo, Opt)
%PR_REFRESHINFO Update information pane
%
%  PR_REFRESHINFO(HINFO, OPTIM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:27:39 $ 

% Name
om = get(Opt, 'om');
algname = getname(om);
if isempty(algname)
   algname = '(Unknown)';
end

% Free variable labels
freevalues = get(Opt, 'values');
valcell = pveceval(freevalues, 'getname');
valnames = sprintf('%s, ', valcell{:});
valnames = valnames(1:end-2);


% Data Set Variables
DSLabs = get(Opt, 'oppointLabels');
DSvalues = get(Opt, 'oppointvalues');
oppointvalues = cell(length(DSLabs),2);

for n = 1:length(DSLabs)
    oppointvalues{n,1} = [DSLabs{n} ' variables'];
    if isempty(DSvalues{n})
        oppointvalues{n,2} = 'None required';
    else
        valcell = pveceval(DSvalues{n}, 'getname');
        dsnames = sprintf('%s, ', valcell{:});
        oppointvalues{n,2} = dsnames(1:end-2);
    end
end

hInfo.ListText = [{'Algorithm name',algname; ...
            'Description', get(Opt,'description'); ...
            'Free variables', valnames}; ...
        oppointvalues];
