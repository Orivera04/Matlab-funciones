function ans=fuzzy_minmax_ind(A,n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin
    case 1
        ans=linind(A);
    case 2
        if length(n)==1
            ans=lincomb(A,n);
        else
            ans=fuzzy_lincomb(A,n);
        end;
end;

function ans=fuzzy_lincomb(A,v);
if size(v)==[size(A,1) 1]
    if (any(fuzzy_minmax(A,fuzzy_epsilon(A',v))~=v))
        ans=false;
    else
        ans=true;
    end;
else
    error(['Vector size is out of range']);
end;

function ans=lincomb(A,n)
if (n<=size(A,2)) && (n>0)
    b=A(:,n);
    A(:,n)=[];
    if fuzzy_lincomb(A,b)
        ans=true;
    else
        ans=false;
    end;
else
    error(['Column number is out of range!'])
end;

function ans=linind(A);
ans=false;
for i=1:size(A,2)
    if (lincomb(A,i))
        ans=true;
        break;
    end;
end;