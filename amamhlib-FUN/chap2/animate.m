function animate(x,y,titl,tim,trace)
%
% animate(x,y,titl,tim,trace)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function performs animation of a 2D curve
% x,y - arrays with columns containing curve positions
%       for successive times. x can also be a single
%       vector if x values do not change. The animation
%       is done by plotting (x(:,j),y(:,j)) for
%       j=1:size(y,2).
% titl- title for the graph
% tim - the time in seconds between successive plots

if nargin<5, trace=0; else, trace=1; end;
if nargin<4, tim=.05; end
if nargin<3, trac=''; end; [np,nt]=size(y);
if min(size(x))==1, j=ones(1,nt); x=x(:);
else, j=1:nt; end; ax=newplot; 
if trace, XOR='none'; else, XOR='xor'; end
r=[min(x(:)),max(x(:)),min(y(:)),max(y(:))];
%axis('equal') % Needed for an undistorted plot
axis(r), % axis('off')
curve = line('color','k','linestyle','-',...
	'erase',XOR, 'xdata',[],'ydata',[]);
xlabel('x axis'), ylabel('y axis'), title(titl)
for k = 1:nt   
   set(curve,'xdata',x(:,j(k)),'ydata',y(:,k))
   if tim>0, pause(tim), end, drawnow, shg
end