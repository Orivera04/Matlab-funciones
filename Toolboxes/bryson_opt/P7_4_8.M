% Script p7_4_8.m; 4 by 4 combin. DP pb. with 
% initial and final costs;         4/97, 7/4/98
%
J=zeros(4,4); z=1e10; U=zeros(4,3); 
u12=[6 4 z z; 3 3 3 z; z 5 2 5; z z 4 4];
u23=[4 5 z z; 6 5 4 z; z 4 3 4; z z 2 5];
u34=[5 2 z z; 3 4 3 z; z 1 3 4; z z 6 2];
J(:,4)=[2 6 4 5]'; S0=[4 2 5 3]'; un=ones(1,4);
%
[a,u]=min(u34'+J(:,4)*un); J(:,3)=a'; U(:,3)=u';
[a,u]=min(u23'+J(:,3)*un); J(:,2)=a'; U(:,2)=u';
[a,u]=min(u12'+J(:,2)*un); J(:,1)=a'; U(:,1)=u';
J(:,1)=J(:,1)+S0; disp('J ='); disp(J);	
	