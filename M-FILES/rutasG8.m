%Matrices de rutas para el grafo G8
%v1=[2,3]; v2=[3,4]; v3=[2,4,6]; v4=[5,6,7];
%v5=[4,6,7]; v6=[4,5,7,8]; v7=[4,5,6,8];
clear;
clc;
MR =[2     3     0     0
     3     4     0     0
     2     4     6     0
     5     6     7     0
     4     6     7     0
     4     5     7     8
     4     5     6     8];
 
e =[2     2     3     3     3     4     4];

MR2 =[1 2; 1 3]
[m,n]=size(MR2);
MR3=[];
for i=1:m
    MR3=[MR3;matrep(MR,MR2,e,i)];
end
MR3
[m,n]=size(MR3);
MR4=[];
for i=1:m
  MR4=[MR4;matrep(MR,MR3,e,i)];
end 
[m,n]=size(MR4);
for i=1:m  
  w=MR4(i,:);
  if elrep(w)==1
     v(i)=i;
  end
end
v
N=v(v~=0);
MR4(N,:)=[]
[m,n]=size(MR4);
L1=[MR4(m,:)]
MR5=[];
for i=1:m-1
  MR5=[MR5;matrep(MR,MR4,e,i)];
end
[h,k]=find(MR5==8);
L2=MR5(h,:)
MR5(h,:)=[];
[m,n]=size(MR5);
for i=1:m  
  w=MR5(i,:);
  if elrep(w)==1
     v(i)=i;
  end
end
N=v(v~=0);
MR5(N,:)=[]
[m,n]=size(MR5);
MR6=[];
for i=1:m-1
  MR6=[MR6;matrep(MR,MR5,e,i)];
end
[h,k]=find(MR6==8);
L3=MR6(h,:)
MR6(h,:)=[];
[m,n]=size(MR6);
for i=1:m  
  w=MR6(i,:);
  if elrep(w)==1
     v(i)=i;
  end
end
N=v(v~=0);
MR6(N,:)=[]
[m,n]=size(MR6);

MR7=[];
for i=1:m-1
  MR7=[MR7;matrep(MR,MR6,e,i)];
end
[h,k]=find(MR7==8);
L4=MR7(h,:)
MR7(h,:)=[];
[m,n]=size(MR7);
for i=1:m  
  w=MR7(i,:);
  if elrep(w)==1
     v(i)=i;
  end
end
N=v(v~=0);
MR7(N,:)=[]
[m,n]=size(MR7);
for i=1:m
    x=MR7(i,:);
    if x(end)~=7
      y(i)=i
    end
end
p=y(y~=0);
MR7(p,:)=[];
[m,n]=size(MR7);
A=8*ones(m,1);
L5=[MR7,A];
L5(3,:)=[1 2 3 4 5 6 7 8];
disp('Las matrices de rutas para G8 son:')
L1
L2
L3
L4
L5
[m1,n1]=size(L1);
[m2,n2]=size(L2);
[m3,n3]=size(L3);
[m4,n4]=size(L4);
[m5,n5]=size(L5);
disp('El No total de rutas desde v1 a v8 son:')
No_rutas=m1+m2+m3+m4+m5

  
