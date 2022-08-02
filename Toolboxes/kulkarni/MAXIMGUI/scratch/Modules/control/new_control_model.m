function P = new_control_model(x,aa)
%lod data for the new control model
load new_model_parameters C W P ;
PP=P;
if aa == -1 %return cost matrix
   P=C;   
elseif aa == -2 %return W matrix
   P=W;
else %return tran. matrix for action aa 
   m=size(PP,2);
   P=PP((aa-1)*m+1:aa*m,:);
end;

