function H=chglines
% CHGLINES	function to change the line styles of the current figure

%	Kristinn Kristinsson, June 1993

h=get(gca,'children');
h=flipud(h);
numlines=length(h);
k=0;
for i=1:numlines,
  k=k+1;
  if k==1, set(h(i),'linestyle','-');
  elseif k==2, set(h(i),'linestyle','--');
  elseif k==3, set(h(i),'linestyle','-.');
  elseif k==4,
    set(h(i),'linestyle',':');
    k=0;
  end
end
if nargout>0, H=h; end

%-- 
%Kristinn Kristinsson             Mail: Pulp and Paper Centre
%Email: Kristinn@ppc.ubc.ca             University of British Columbia
%Email: K.Kristinsson@ieee.org          2385 East Mall
%Ph:(604)-822-8567  Fax:(604)-822-8563  Vancouver B.C. V6T 1Z4, CANADA
