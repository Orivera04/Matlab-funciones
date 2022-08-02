function listout = cginitinputs(t,vars,listin)
%CGINITINPUTS Set up an input list table
%
%  LISTOUT = CGINITINPUTS(T,VARS,LISTIN)
%
%  T is an instance of com.mathworks.toolbox.mbc.gui.table.InputListTable.
%  VARS is an array of xregpointers to cgvalues.  These are added to the
%  table as variables.
%  LISTIN is an array of xregpointers to cgvalues, which are also added to
%  the table.  Any which are also in "vars" are ignored.  Any which are
%  linked to those in "vars" are added as "linked" values.  Others are
%  added to  the table as constants.
%  LISTOUT is an array of xregpointer to cgvalues in the order they appear
%  in the table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $

t.startNewModel;

% add variables to table
names = pveceval(vars, @getname);
ranges = pveceval(vars, @getrange);
for i = 1:length(vars);
    % 20 points by default
    t.addVariable(names{i}, ranges{i}(1), ranges{i}(2), 20);
end
passign(vars, pveceval(vars, @linspace, 20));

isvar = ismember(listin,vars);
[isindep, pLink] = cgisindependentvars(listin, vars);
names = pveceval(listin, @getname);
for n = 1:length(listin)
    if isindep(n)
        [thisIndep, thisLink] = cgisindependentvars(listin(n), listin(1:n-1));
        if ~thisIndep
            % input is linked to another scalar input that has already been
            % added
            t.addLinkedObject(names{n}, thisLink.getname);
        else
            % this input is to have a single value
            t.addScalar(names{n}, listin(n).getnomvalue);
        end
    elseif ~isvar(n)
        t.addLinkedObject(names{n}, pLink(n).getname);
    end
end
t.completeNewModel;

listout = [vars, listin(~isvar)];
