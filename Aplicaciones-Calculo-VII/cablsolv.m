function [r,t,pends]=cablsolv(Len,P,Rend)
% 
% [r,t,pends]=cablsolv(Len,P,Rend)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the equilibrium 
% position for a cable composed of rigid 
% weightless links with loads applied at the 
% frictionless joints. The ends of the cable 
% are assumed to have a known position.
%
% Len   - a vector containing the lengths 
%         Len(1), ..., Len(n)
% P     - matrix of force components applied 
%         at the interior joints. P(:,i) 
%         contains the Cartesian components of 
%         the force at joint i.
% Rend  - the coordinate vector giving the 
%         position of the outer end of the last 
%         link, assuming the outer end of the 
%         first link is at [0,0,0].
%
% r     - a matrix with rows giving the 
%         computed equilibrium positions of all 
%         ends
% t     - a vector of tension values in the 
%         links
% pends - a matrix having two rows which 
%         contain the force components acting 
%         at both ends of the chain to maintain 
%         equilibrium 
%
% User m functions called: endfl, cabldefl

if nargin < 3
  % Example for a ten link cable with vertical 
  % and lateral loads
  Len=1.5*ones(10,1); Rend=[10,0,0];
  P=ones(9,1)*[0,-2,-1];  
end

global len p rend
len=Len; rend=Rend; p=P; tol=sum(Len)/1e8;

% Start the search with a random force applied
% at the far end

% Perform several searches to minimize the  
% length of the vector from the outer end of 
% the last link to the desired position Rend 
% where the link is to be connected to a 
% support. The final end force should reduce 
% the deflection error to zero if the search 
% is successful.

opts=optimset('tolx',tol,'tolfun',tol,...
              'maxfunevals',2000); 
endval=realmax;

% Iterate several times to avoid false
% convergence
for k=1:5
  p0=10*max(abs(p(:)))*rand(size(p,2),1);
  [pendk,endvalk,exitf]=...
  fminsearch(@endfl,p0,opts);
    if endvalk < endval
      pend=pendk(:); endval=endvalk;
    end
end

% Use the computed end force to obtain the 
% final deflection. Also return the 
% support forces.
[r,t,pstart]=cabldefl(len,[p;pend']);
x=r(:,1); y=r(:,2); z=r(:,3); 
pends=[pstart(:)';pend(:)']; close

% Plot the deflection curve of the cable
plot3(x,y,z,'k-',x,y,z,'ko'); xlabel('x axis');
ylabel('yaxis'); zlabel('z axis');
title('Deflection Shape for a Loaded Cable');
axis('equal'); grid on; figure(gcf);
print -deps defcable

%=============================================

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

%=============================================

function [r,t,pbegin]=cabldefl(len,p)
%
% [r,t,pbegin]=cabldefl(len,p)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the static equilibrium 
% position for a cable of rigid weightless 
% links having concentrated loads applied at 
% the joints and the outside of the last link. 
% The outside of the first link is positioned 
% at the origin.
%
% len    - a vector of link lengths 
%          len(1), ..., len(n)
% p      - a matrix with rows giving the 
%          force components acting at the 
%          interior joints and at the outer 
%          end of the last link
%
% r      - matrix having rows which give the 
%          final positions of each node
% t      - vector of member tensions
% pbegin - force acting at the outer end of 
%          the first link to achieve 
%          equilibrium 
%
% User m functions called:  none
%----------------------------------------------

n=length(len); len=len(:); nd=size(p,2);

% Compute the forces in the links
T=flipud(cumsum(flipud(p))); 
t=sqrt(sum((T.^2)')');

% Obtain the deflections of the outer ends 
% and the interior joints
r=cumsum(T./t(:,ones(1,nd)).*len(:,ones(1,nd)));
r=[zeros(1,nd);r]; pbegin=-t(1)*r(2,:)/len(1);
