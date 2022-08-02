function q = subsasgn(p,S,data)
%SUBSASGN Overloaded sub-assignment for pointers
%
%  SUBSASGN implements sub-referencing for xregpointer objects.  The
%  following styles of referencing are supported:
%
%    p.info = newinfo         assigns newinfo to p.info
%    p(i,j) = q               assigns the (i,j)th element of p with q 
%    p(i,j).info = newinfo    assigns newinfo to p(i,j).info
%
%  Array expansion is not supported.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:48:18 $

q = p;
if strcmp(S(1).type,'()')
    if isempty(q)
        % Create an empty pointer
        q = xregpointer;
        q.ptr = [];
    end
    if length(S)==1
        % p(i,j) = q
        if isa(data,'xregpointer')
            q.ptr(S(1).subs{:}) = data.ptr;
        elseif isempty(data) || (isa(data,'double') && all(size(data)==1) && data==0)
            % can assign new location to null
            q.ptr(S(1).subs{:}) = data;
        else
            error('mbc:xregpointer:InvalidAssignment','Invalid Pointer Assignment');
        end
        return
    else
        p.ptr = p.ptr(S(1).subs{:});
        S = S(2:end);
    end
end

if strcmp(S(1).type,'.') && strcmp(lower(S(1).subs),'info')
    if length(S)>1
        info = HeapManager(0, p.ptr);
        data = subsasgn(info,S(2:end),data);
    end
    HeapManager(2, p.ptr, data);
else
    error('mbc:xregpointer:InvalidAssignment','Invalid Pointer Info Assignment: User p.info')
end
