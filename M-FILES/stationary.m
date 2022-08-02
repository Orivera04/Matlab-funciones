function [ind]=stationary(x,y,type)

%
%Stationary gives the index points for stationary points in the function described by the vectors x and y.
%Specifying the string "type" as 'max','min' or 'both' means that "ind" gives the maximum stationary points, the 
%minimum stationary points or both respectively.  The default option is 'both'.
%
%Created By James Rooney 

if exist('type','var')==0
   type='both'
end

ygrad=gradient(y,x);
ygrad2=gradient(ygrad,x);

ind=[];
switch type
   
case 'min'
   for j=1:length(x)-1
   
if sign(ygrad(j+1))~=sign(ygrad(j)) & ygrad(j+1)~=0 & ygrad2(j)>0
   
    [v g]=min(y(j:j+1));
      
         ind=[ind j+(g-1)];
      
   elseif ygrad(j)==0 & ygrad2(j)>0

 
ind=[ind j];

end

end

case 'max'   
   for j=1:length(x)-1
   
if sign(ygrad(j+1))~=sign(ygrad(j)) & ygrad(j+1)~=0 & ygrad2(j)<0
   
    [v g]=min(y(j:j+1));
      
         ind=[ind j+(g-1)];
      
   elseif ygrad(j)==0 & ygrad2(j)<0

 
ind=[ind j];

end

end

case 'both'
   
   for j=1:length(x)-1
   
if sign(ygrad(j+1))~=sign(ygrad(j)) & ygrad(j+1)~=0 
   
    [v g]=min(y(j:j+1));
      
         ind=[ind j+(g-1)];
      
   elseif ygrad(j)==0 
 
ind=[ind j];

end

end

end