function R=grafrutas1(e1,e2)
%k=1;
N=numel(e1);
t=e1';u=e2';
P=[t,u];
R1=[t(1),u(1)];
for i=1:21
for j=1:21 
   A=t(i)~=t(j);B=u(i)==t(j);C=t(i)~=u(j);
   if A&B&C
   R1=[R1,t(j),u(j)] 
   end
end
end
R=R1;