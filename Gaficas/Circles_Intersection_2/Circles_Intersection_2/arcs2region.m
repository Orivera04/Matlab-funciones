function R=arcs2region(c,k,dfi);
% Converts the region, returned by Circles_Intersection, into
% array, approximated as polygons collection
% Input: c - result of Circles_Intersection action;
% k - number of element in c, corresponds to selected overlaying region
% dfi - step of arc aproximation in degrees
% Output: R - array, described polygonal region, which contain any
%         non-intersected polygons
%         see reg_patch, InsLineToComp, InsCompToRegn to know the format of this array 
%
%   Author:  Alexander Vakulenko
%   e-mail:  dspt@yandex.ru
%   Last modified: 20050123
%
nin=nargin;
if nin<3, dfi=2;end;
dfi=dfi*pi/180;
R=[0;-2];
U=[0;-2]; % empty region
n=c.Ng;
nk=size(c.w(k).sk,2);
ar=zeros(1,nk);
for l=1:nk,
    ar(l)=c.w(k).sk(l).S;
end;
jp=find(ar>0);
jn=find(ar<=0);
kn=length(jn);
kp=length(jp);
pnz=ones(kn,1);
if kp>0,
    for m=1:kp,
        nt=size(c.w(k).sk(jp(m)).data,1);
        x=[];y=[];
        for i=1:nt-1,
            a=c.w(k).sk(jp(m)).data(i,3);
            b=c.w(k).sk(jp(m)).data(i,4);
            if a>=b, a=a-2*pi; end;
            lo=b-a;
            N=ceil(lo/dfi);
            dl=lo/N;
            teta=[a:dl:b];
            x=[x c.G(c.w(k).sk(jp(m)).data(i,1),3)*cos(teta)+c.G(c.w(k).sk(jp(m)).data(i,1),1)];
            y=[y c.G(c.w(k).sk(jp(m)).data(i,1),3)*sin(teta)+c.G(c.w(k).sk(jp(m)).data(i,1),2)];
        end;
        lm=[x;y];
        g=InsLineToComp(lm,[0;-1]);
        U=InsCompToRegn(g,U);
    end;
    rltn=zeros(kp,kp);
    for m1=1:kp-1,
        N=U(1,m1+1); % index of begin data for component number m1
        M=U(2,m1+1); % index of end data for component number m1
        g1=U(:,N:M);
        N=g1(1,1+1); % index of begin data for line number 1
        M=g1(2,1+1); % index of end data for line number 1
        x=g1(1,N:M);
        y=g1(2,N:M);
        for m2=(m1+1):kp,
            N=U(1,m2+1); % index of begin data for component number m1
            M=U(2,m2+1); % index of end data for component number m1
            g1=U(:,N:M);
            N=g1(1,2); % index of begin data for line number 1
            M=g1(2,2); % index of end data for line number 1
            xx=g1(1,N);
            yy=g1(2,N);
            inp = inpolygon(xx,yy,x,y);
            if inp>0.9,
                rltn(m1,m2)=1;
            end;
        end;
    end;
    rr=ones(kp,1);
    while (sum(rr)>0),
        rz=zeros(kp,1);
        for m=1:kp,
            if rr(m)>0,
                for mm=1:kp,
                    if rr(mm)>0,
                        rz(m)=rz(m)+rltn(m,mm);
                    end;
                end;
            end;
        end;
        jrr=find((rz==0)&(rr>0));
        rr(jrr)=0;
        kjz=length(jrr);
        for ik=1:kjz,
            % find lines with negative area inside
            nom=jrr(ik);
            N=U(1,nom+1); 
            M=U(2,nom+1); 
            g=U(:,N:M);
            for mn=1:kn,
                if pnz(mn)>0,
                    a=c.w(k).sk(jn(mn)).data(1,3);
                    if a>=b, a=a-2*pi; end;
                    xx=c.G(c.w(k).sk(jn(mn)).data(1,1),3)*cos(a)+c.G(c.w(k).sk(jn(mn)).data(1,1),1);
                    yy=c.G(c.w(k).sk(jn(mn)).data(1,1),3)*sin(a)+c.G(c.w(k).sk(jn(mn)).data(1,1),2);
                    
                    inp = inpolygon(xx,yy,g(1,g(1,2):g(2,2)),g(2,g(1,2):g(2,2)));
                    if inp>0.9,
                        nt=size(c.w(k).sk(jn(mn)).data,1);
                        x=[];y=[];
                        for i=1:nt-1,
                            a=c.w(k).sk(jn(mn)).data(i,3);
                            b=c.w(k).sk(jn(mn)).data(i,4);
                            if a>=b, a=a-2*pi; end;
                            lo=b-a;
                            N=ceil(lo/dfi);
                            dl=lo/N;
                            teta=[a:dl:b];
                            x=[x c.G(c.w(k).sk(jn(mn)).data(i,1),3)*cos(teta)+c.G(c.w(k).sk(jn(mn)).data(i,1),1)];
                            y=[y c.G(c.w(k).sk(jn(mn)).data(i,1),3)*sin(teta)+c.G(c.w(k).sk(jn(mn)).data(i,1),2)];
                        end;
                        g=InsLineToComp([x;y],g);
                        pnz(mn)=0;
                    end;
                end;
            end;
            R=InsCompToRegn(g,R);
        end;
    end;
end;
