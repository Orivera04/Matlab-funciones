function [res1,res2] = diff_scheme(func,X,DX,DT,c,a,b,Tfinal,n)

R=(c*DT/DX)^2;


T = 0:DT:Tfinal;
Uout(:,1)=feval(func,X)';


%Leap Frog Matrices
A=diag((R)*ones(n-2,1),-1)+diag((2-2*R)*ones(n-1,1))+diag((R)*ones(n-2,1),1);

Uout(:,1) = [0;Uout(2:n,1);0];
Uout(:,2)=Uout(:,1);%[0;U;0];
%save temp1.mat
for p = 2:length(T)-1
    %U=A*Uout(2:n,p)-Uout(2:n,p-1)+(R)*[Uleft(T(p));zeros(n-3,1);Uright(T(p))];
    %Uout(:,p+1)=[Uleft(T(p));U;Uright(T(p))];
    U=A*Uout(2:n,p)-Uout(2:n,p-1)+(R)*[0;zeros(n-3,1);0];
    Uout(:,p+1)=[0;U;0];
end

%for k = 2:n
%    for p = 2:length(T)-1
%        U=A*Uout(2:n,p)-Uout(2:n,p-1)+(R)*[0;zeros(n-3,1);0];
        %Uout(:,p+1)=[Uleft(T(p));U;Uright(T(p))];
        %save temp1.mat
        %Uout
        %pause
        %figure(1),plot(X,Uout(:,p)),grid
        %pause
        %U=R.*(Uout(3:n+1,p)+Uout(1:n-1,p))+2.*(1-R).*Uout(2:n,p)-Uout(2:n,p-1);%+(R)*[0;zeros(n-3,1);0];
%        Uout(:,p+1)=[0;U;0];
        %size(U),size(Uout)
        %pause
        %    end
    res1 = Uout;
res2 = T;

return
%end

for j = 2:length(T)-1
    %Uout
    %figure(1),plot(X,Uout(:,2*j-1)),grid
    %axis([0 1 -1 1])
    %pause
    for i = 2:n
        %U=A*Uout(2:n,p)-Uout(2:n,p-1);%+(R)*[Uleft(T(p));zeros(n-3,1);Uright(T(p))];
        %Uout(:,p+1)=[Uleft(T(p));U;Uright(T(p))];
        U(i-1)=R*(Uout(i+1,j)+Uout(i-1,j))+2*(1-R)*Uout(i,j)-Uout(i,j-1);%+(R)*[0;zeros(n-3,1);0];
        %Uout(:,p+1)=[0;U;0];
        %U=R.*(Uout(3:n+1,p)+Uout(1:n-1,p))+2.*(1-R).*Uout(2:n,p)-Uout(2:n,p-1);%+(R)*[0;zeros(n-3,1);0];
        %Uout(:,p+1)=[0;U;0];
    end
    %save temp1.mat
    %size(U),size(Uout)
    Uout(:,j+1)=[0;U';0];
    %U(end) = 0;
    %Uout(:,j+1)=[0;U'];
end

res1 = Uout;
res2 = T;
