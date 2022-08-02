function t=find_t(m1,method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%function t=find_t(m1)
%%
%%
%%
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ((nargin==0) || (length(m1)==0)) m1=inputStartM; end;
if (nargin~=2) method=1; end;
mstr=find_tn(method);
q=length(m1{1});
for i=1:length(m1)
    if (any(size(m1{i})~=[q q])) error(['All state matrices must be have identical size!']); end;
end;
t=ones(q,1);
length_t_old=size(t,2);
mstr2=strcat(mstr,'(m1,t)');
mstr3=strcat(mstr,'(mn,t)');
t=eval(mstr2);
k=1; disp(['t',num2str(k),'= ']); disp(t); pause;
mn=m1;
while (length_t_old~=size(t,2))
    length_t_old=size(t,2);
    mn=next_stage(m1,mn);
    
    tic;
    t=eval(mstr3);
    disp(toc);

    k=k+1; disp(['t',num2str(k),'= ']); disp(t); pause;
end;

function m=inputStartM()
x=input('Number of input letters: ');
y=input('Number of output letters: ');
q=input('Number of inner states: ');
r=input('Use random matrix? (Y/N): ','s');
k=1;
for i=1:x
    for j=1:y
        if (r=='y' || r=='Y')
            m{k}=rand(q);
        elseif (r=='n' || r=='N')
            m{k}=input(['State matrix [', num2str(i), ',', num2str(j), '] (size=',num2str(q),'x',num2str(q),'): ']);
            if (any(size(m{k})~=[q q])) error(['Every state matrix must be ',num2str(q),'x',num2str(q),'!']); end;
        else
            r=input('Use random matrix? (Y/N): ','s');
        end;
        k=k+1;
    end;
end;

function mstr=find_tn(method)
switch method
    case 1
        mstr='find_tn1';
    case 2
        mstr='find_tn2';
end;

function t=find_tn1(m,t)
k=length(m);
for i=1:k
    tc=max(m{i},[],2);
    if (any(fuzzy_maxmin(t,fuzzy_alpha(t',tc))~=tc))
        t=[t,tc];
    end;
end;

function t=find_tn2(m,t)
k=length(m);
for i=1:k
    tc=max(m{i},[],2);
    fsol=FillHelpMatrixSolution(t,tc);
    if (~fsol.exist)
        t=[t,tc];
    end;
end;

function mn=next_stage(m1,mn);
length_m1=length(m1);
length_mn=length(mn);
k=length_m1*length_mn;
for i=length_m1:-1:1
    for j=length_mn:-1:1
        mn{k}=fuzzy_maxmin(m1{i},mn{j});
        k=k-1;
    end;
end;