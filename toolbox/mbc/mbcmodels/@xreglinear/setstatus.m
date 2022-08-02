function m = setstatus(m,i,s)
%SETSTATUS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:50:08 $


m.TermStatus(i)= s;

if ischar(i) && strcmp(i,':')
    % could be using scalar expansion
    i= 1:size(m,1);
    s= m.TermStatus;
end
j = s==1 | s ==2;
if any(j)
    % update termsout if status == 1 or 2
    if numel(i)==numel(s)
        m.TermsOut(i(j))= s(j)==2; 	% a term is out if status ==2
    elseif numel(s)==1
        m.TermsOut(i)= s==2; 	% a term is out if status ==2
    else
        error('Incompatible term indices and sizes')
    end
end