% FUNCTION TO FIND ALL THE POSSIBLE PATHS FROM A SOURCE NODE TO SINK NODE
% PathFinder(B,StartNode,EndNode)
% B is an Nx2 matrix, where N is the number of Edges in the Graph. The data
% is in the form of 'From Node' to 'To Node'.
% StartNode is the source node, and EndNode is the Sink Node.
% Limitation: Works good till N=20. Also as N increses, execution time also increases.

% By- Abhishek Chakraborty
% Dt: 01-May-2010
% For suggestions and queries, please contact the author at: abhishek.piku@gmail.com

function PathFinal=PathFinder(B,StartNode,EndNode)
fb=B(:,1);
tb=B(:,2);
u=max(max(fb),max(tb)); % 'u' contains the number of nodes in the graph
%#################### Formation of Adjacency Matrix ####################
A=zeros(u,u); % Initialization of Adjacency Matrix
n=length(fb); %'n' is the number of edges
for i=1:n
    x=fb(i,1);
    y=tb(i,1);
    A(x,y)=A(x,y)+1;
    A(y,x)=A(y,x)+1;
end
A; % Final Adjacency Matrix
%######################################################################
NodeVector=1:u; % 'NodeVector' is a vector containing all the nodes serially
SourceSinkVector=[StartNode,EndNode];
%########### Rearrangement ############
NodeArray=NodeVector;
NodeArray(StartNode)=0;
NodeArray(EndNode)=0;
NodeVector=find(NodeArray);
NodeArray=NodeArray(NodeVector);
NodeArray=[StartNode,NodeArray,EndNode];
%#####################################
T=[];
TTRaw=ff2n(u);
x=2^u;
for i=1:x
    if (TTRaw(i,1)==0 && TTRaw(i,u)==0)
            T=[T;TTRaw(i,:)];
    end
end
v=length(T(:,1));
Paths=[];
for i=1:v
    Nodes=[];
    for j=1:u
        if (T(i,j)==0)
            Nodes=[Nodes,NodeArray(j)];
        else
            Nodes=[Nodes,0];
        end
    end
    Paths=[Paths;Nodes];
end
%Paths;
%n=length(Paths(:,1));
PathFinalTemp=[];
for i=1:v
    Temp=Paths(i,:);
    NodeArray=find(Temp); %eliminating zeros
    Temp=Temp(NodeArray);
    Temp(1)=[]; %eliminating start node
    Temp(end)=[]; %eliminating end node
    Permutation=perms(Temp);
    if(isempty(Permutation)==0)
       Prow=length(Permutation(:,1));
       SN=[];
       EN=[];
    for c=1:Prow
        SN=[SN;StartNode];
        EN=[EN;EndNode];
    end
    Permutation=[SN,Permutation,EN];
    Pcol=length(Permutation(1,:));
    for k=1:Prow
        PathTemp=zeros(1,u);
        PathTemp(1)=StartNode;
        for l=1:Pcol-1
            a=Permutation(k,l);
            b=Permutation(k,(l+1));
            if (A(a,b)==1)
                PathTemp(l+1)=PathTemp(l+1)+b;
            else
                PathTemp=zeros(1,u);
                break
            end
            
        end
        PathFinalTemp=[PathFinalTemp;PathTemp];
    end
    elseif (isempty(Permutation)==1)
        PathTemp=zeros(1,u);
        if (A(StartNode,EndNode)==1)
            PathTemp(1)=StartNode;
            PathTemp(2)=EndNode;
        else
            PathTemp=zeros(1,u);
                break
        end
         PathFinalTemp=[PathFinalTemp;PathTemp];
    end
end
PathFinal=PathFinalTemp;
PathFinal(~any(PathFinalTemp,2),:)=[];
PathFinal;