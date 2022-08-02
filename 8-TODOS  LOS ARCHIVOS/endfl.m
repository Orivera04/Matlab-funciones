function enderr=endfl(pend)
%
% enderr=endfl(pend)
% ~~~~~~~~~~~~~~~~~~
%
% This function computes how much the 
% position of the outer end of the last link 
% deviates from the desired position when an 
% arbitrary force pend acts at the cable end. 
%
% pend   - vector of force components applied 
%          at the outer end of the last link
%
% enderr - the deflection error defined by the 
%          square of the norm of the vector 
%          from the computed end position and 
%          the desired end position. This error 
%          should be zero for the final 
%          equilibrium position
%
% User m functions called: cabldefl
%----------------------------------------------

% Pass the lengths, the interior forces and the 
% desired position of the outer end of the last 
% link as global variables.
global len p rend

% use function cabldefl to compute the 
% desired error
r=cabldefl(len,[p;pend(:)']); 
rlast=r(size(r,1),:);
d=rlast(:)-rend(:); enderr=d'*d;