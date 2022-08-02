function [out] = EvalConstraints(d,Xc)
%EVALCONSTRAINTS Evaluate constraints for design
%
%  EVALCONSTRAINTS(D) evaluates the constraints for each point in the
%  design D and returns an updated design object
%  EVALCONSTRAINTS(D, X) evaluates the constraints for each point in X and
%  returns a vector containing the constraint status for each point.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:27:04 $

out=d;
if ~isempty(d.constraints)
    c = reset(d.constraints);
    if nargin==1
        nc= ncand(d,'unconstrained');
        if isfinite(nc)
            n= 100000;
            nd= fix(nc/n);
            ind= 1:n;
            st=0;

            usewait=waitbars(d) & (nd>1);
            if usewait
                % prevent any nested waitbars
                d=waitbars(d,0);
                % gui feedback
                h=xregGui.waitdlg('title','MBC Toolbox', ...
                    'message','Evaluating constraints.  Please wait...');
                h.waitbar.max=nd+1;
            end

            for i=1:nd
                Xc= indexcand(d,ind+n*(i-1),'unconstrained');
                c= eval(c,Xc,st);
                st= st+n;
                if usewait
                    h.waitbar.value=i;
                end
            end
            Xc= indexcand(d,nd*n+1:nc,'unconstrained');
            d.constraints= eval(c,Xc,st);
            if usewait
                h.waitbar.value=nd+1;
            end
            if usewait
                delete(h);
                % turn waitbars back on
                d=waitbars(d,1);
            end
        else
            error('Nc= Inf')
        end
        d.candstate=d.candstate+1;
        d.constraintsflag=d.candstate;
        out=d;
    else
        [c, out] = eval(c,Xc);
    end
end
