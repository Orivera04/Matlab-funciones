function r = ssorpc(nx,ny,ae,aw,as,an,ac,rac,w,d,r)
%   This preconditioner is SSOR.
for j= 2:ny
 	 for i = 2:nx
	    r(i,j) = w*(d(i,j) + aw*r(i-1,j) + as*r(i,j-1))*rac;
    end 
end 
r(2:nx,2:ny) =  ((2.-w)/w)*ac*r(2:nx,2:ny);
for j= ny:-1:2
	 for i = nx:-1:2
    	 r(i,j) = w*(r(i,j)+ae*r(i+1,j)+an*r(i,j+1))*rac;
     end 
end 