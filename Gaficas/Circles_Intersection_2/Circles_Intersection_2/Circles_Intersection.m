function C=Circles_Intersection(G);
% Calculate k-times intrsection region of circles collection,
% given as array G(N,3):
% Input: G - array, which contain parameters of the circles
%        G(n,1) - x-coordinate,
%        G(n,2) - y-coordinate,
%        G(n,3) - radius of circle number n=1,...,N
% Output: C - structure, which contain 
% description of region, corresponding to k-th times intersection.
% Each region discibed as sequence of arcs, it bounded
% C contains fields
%      G: - input array G
%      P: - coordinates of points, there intrsects boundary of circles
%     Ng: - size(G,1)
%     Np: - size(P,1)
%      K: - maximum number of circles, 
%           which may contain one common point inside 
%      w: - structure with description of intersection regions
%           (length(w)=K) 
%           fields of w(k):
%           nk: - number of components in this region
%            S: - area of k-times intersection region
%           sk: - array of structures (length(sk)=nk)
%                 sk(m) contain fields:
%                 data: - array (Narcs x 4) contain parameters of boundary arcs
%                 S: - area of corresponding component
% -------------------------------------------------------------------------
%   Vesrion 1.0
%   Author:  Alexander Vakulenko
%   e-mail:  dspt@yandex.ru
%   Last modified: 20040618
%

pi2=2*pi;
n=size(G,1);
P=zeros(2*n,2);
P(1:2:2*n-1,:)=G*[1 0;0 1; 1 0];
P(2:2:2*n  ,:)=G*[1 0;0 1;-1 0];

for i=n:-1:1, O(i).f=[0 pi;0 0;2*i-1 2*i]; end;

m=size(P,1);
for i=1:n-1,
    for j=i+1:n,
        dx=G(j,1)-G(i,1); dy=G(j,2)-G(i,2);
        Ri=G(i,3); Rj=G(j,3); Rij=sqrt(dx*dx+dy*dy);
        if Ri+Rj>Rij,
            M=0;
            if Ri>=Rj,
                if Rij<=Ri-Rj, O(j).f(2,:)=O(j).f(2,:)+1; else M=1; end;
            else
                if Rij<=Rj-Ri, O(i).f(2,:)=O(i).f(2,:)+1; else M=1; end;
            end;
            if M==1,
                fi1=mod(atan2(G(j,2)-G(i,2),G(j,1)-G(i,1)),pi2);
                fi2=mod(fi1+pi,pi2);
                df1=acos((Rij*Rij+Ri*Ri-Rj*Rj)/(2*Rij*Ri));
                df2=acos((Rij*Rij+Rj*Rj-Ri*Ri)/(2*Rij*Rj));
                f11=mod(fi1-df1,pi2); f12=mod(fi1+df1,pi2);
                f21=mod(fi2-df2,pi2); f22=mod(fi2+df2,pi2);
                p1=[G(i,1)+G(i,3)*cos(f11) G(i,2)+G(i,3)*sin(f11)];
                p2=[G(i,1)+G(i,3)*cos(f12) G(i,2)+G(i,3)*sin(f12)];
                m1=m+1;m2=m+2;
                [O(i).f mm1]=Partition(O(i).f,[f11 f12; m1 m2]);
                [O(j).f mm2]=Partition(O(j).f,[f21 f22; m2 m1]);
                if (mm1(1,1)==m1)&(mm2(1,2)==m1),
                    P=[P;p1];m=m+1;
                    if (mm1(1,2)==m2)&(mm2(1,1)==m2),
                        P=[P;p2];m=m+1;
                    else
                        mmin=m2;
                        if mmin>mm1(1,2),mmin=mm1(1,2);end; if mmin>mm2(1,1),mmin=mm2(1,1);end;
                        O(i).f(3,mm1(2,2))=mmin; O(j).f(3,mm2(2,1))=mmin;
                    end;
                else
                    mmin=m1;
                    if mmin>mm1(1,1),mmin=mm1(1,1);end; if mmin>mm2(1,2),mmin=mm2(1,2);end;
                    O(i).f(3,mm1(2,1))=mmin; O(j).f(3,mm2(2,2))=mmin;
                    if (mm1(1,2)==m2)&(mm2(1,1)==m2),
                        P=[P;p2];m=m+1;
                        O(i).f(3,mm1(2,2))=m2-1; O(j).f(3,mm2(2,1))=m2-1;
                    else
                        mmin=m2;
                        if mmin>mm1(1,2),mmin=mm1(1,2);end; if mmin>mm2(1,1),mmin=mm2(1,1);end;
                        O(i).f(3,mm1(2,2))=mmin; O(j).f(3,mm2(2,1))=mmin;
                    end;
                end;
            end;
        end;
    end; 
end;

C.G=G;
C.P=P;
C.Ng=n;
C.Np=m;
for i=1:n, O(i).f=[O(i).f O(i).f(:,1)]; end;
maxk=0;
for i=1:n,
    m(i)=size(O(i).f,2)-1;
    for j=1:m(i), if O(i).f(2,j)>maxk, maxk=O(i).f(2,j); end; end;
    O(i).f=[O(i).f;ones(1,m(i)+1)];
end;
nk=zeros(1,maxk+1);
for i=1:n, for j=1:m(i), nk(O(i).f(2,j)+1)=nk(O(i).f(2,j)+1)+1; end; end;
for k=1:maxk+1,
    w(k).sk=[]; N=0;w(k).S=0;
    while nk(k)>0,
        io=1;jo=1;N=N+1;
        while (O(io).f(2,jo)~=(k-1))|(O(io).f(4,jo)~=1), jo=jo+1; if jo==m(io)+1, jo=1;io=io+1; end; end;
        w(k).sk(N).data=[io O(io).f(3,jo) O(io).f(1,jo) O(io).f(1,jo+1)];
        np=O(io).f(3,jo+1);ik=io;jk=0;
        while (ik~=io)|(jk~=jo),
            i=1;j=1;
            while (O(i).f(2,j)~=(k-1))|(O(i).f(4,j)~=1)|(np~=O(i).f(3,j)), j=j+1; if j==m(i)+1, j=1;i=i+1; end; end;
            w(k).sk(N).data=[w(k).sk(N).data; [i np O(i).f(1,j) O(i).f(1,j+1)] ];
            ik=i;jk=j;np=O(i).f(3,j+1); O(i).f(4,j)=0; nk(k)=nk(k)-1;
        end;
        % Area of element
        % area of closed region, given as vertexes of polygon 
        % if m - matrix (1:2,1:n),  m(1,:) - x coord, m(2,:) - y coord
        U=P(w(k).sk(N).data(:,2),:)'; Un=size(U,2);
        ss=0.5*(  U(1,1:Un-1)*U(2,2:Un)' - U(2,1:Un-1)*U(1,2:Un)'  );
        rs=G(w(k).sk(N).data(1:Un-1,1),3);
        df=mod(w(k).sk(N).data(1:Un-1,4)-w(k).sk(N).data(1:Un-1,3),pi2);
        w(k).sk(N).S=ss+0.5*sum(rs.*rs.*(df-sin(df)));
        w(k).S=w(k).S+w(k).sk(N).S;
    end;
    w(k).nk=N;
end;
maxk=maxk+1;C.K=maxk;
C.w=w;

%
function [g,mm]=Partition(f,b);
n=size(f,2);
h=[f(:,n) f(:,:)];n=n+1; 
i=1; while (IsPtInRight(b(1,1),[h(1,i),h(1,i+1)])==0), i=i+1; end;
if b(1,1)==h(1,i+1),
    h=[h(:,i+1:n) h(:,2:i+1)];
else
    h=[[b(1,1); h(2,i);b(2,1)] h(:,i+1:n) h(:,2:i+1)];
    n=n+1;
end;
mm(1,1)=h(3,1);mm(2,1)=1;
i=1; while (IsPtInLeft(b(1,2),[h(1,i),h(1,i+1)])==0), h(2,i)=h(2,i)+1; i=i+1; end;
if b(1,2)~=h(1,i), 
    h=[h(:,1:i) [b(1,2);h(2,i);b(2,2)] h(:,i+1:n)];
    h(2,i)=h(2,i)+1;
    n=n+1;
    mm(1,2)=h(3,i+1);mm(2,2)=i+1;
else
    mm(1,2)=h(3,i  );mm(2,2)=i;
end;
g=h(:,1:n-1);

%%%%
function rc=IsPtInRight(f,b)
% is point f inside arc b (rc=1) ore not (rc=0)
rc=0;
if b(1)<b(2),
    if (b(1)<f) & (f<=b(2)), rc=1; end;
else
    if (b(1)<f) | (f<=b(2)), rc=1; end;
end;

%%%%
function rc=IsPtInLeft(f,b)
% is point f inside arc b (rc=1) ore not (rc=0)
rc=0;
if b(1)<b(2),
    if (b(1)<=f) & (f<b(2)), rc=1; end;
else
    if (b(1)<=f) | (f<b(2)), rc=1; end;
end;
