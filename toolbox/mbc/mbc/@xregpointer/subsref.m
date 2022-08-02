function q = subsref(p,S)
%SUBSREF Overloaded subsref for xregpointers
%
%  SUBSREF provides sub-referencing for xregpointer objects.  The following
%  styles of referencing are supported:
%
%    p.info       dereferences pointer p
%    p(i,j)       (i,j)th element of p
%    p(i,j).info  dereferences pointer p(i,j)
%    p(i,j).func  runs function 'func' on p.info
%    p(i,j).func(otherargs)  runs function 'func' on p.info with
%             a list of other rarguments
%
%  Note that p.info has precedence over p.func.  Also, p.func can only be
%  used to collect one function output - use PEVAL or func(p.info) if this
%  is not the case.
%
%  Chained subsref-ing of contained data is also supported, for example
%  p.info(:,1) will return the first column of p.info.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:48:19 $

OK = false;
if strcmp(S(1).type,'()')
    % array indexing
    p.ptr = p.ptr(S(1).subs{:});
    if length(S)==1
        q = p;
        return
    end
    S = S(2:end);
    OK = true;
end

if strcmp(S(1).type,'.')
    S1 = S(1).subs;
    if strcmp(lower(S1),'info')
        % dereferencing
        info = HeapManager(0,p.ptr);
        if length(S)>1
            info = subsref(info,S(2:end));
        end
        q = info;
    else
        info = HeapManager(0,p.ptr);
        if length(S)==1
            % no extra arguments
            q = feval(S1,info);
        elseif length(S)==2 && strcmp(S(2).type,'()')
            % passes other arguments to function
            q = feval(S1,info,S(2).subs{:});
        else
            error('mbc:xregpointer:InvalidArgument', ...
                'Unsupported pointer function call style: use p.FName(arglist)');
        end
    end
elseif ~OK
    error('mbc:xregpointer:InvalidArgument', ...
        'Unsupported pointer reference style.');
end