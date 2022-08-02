function draw(s,O,c)
%draw(s,O,c) - draw a multivector. 
%  s: the multivector to be drawn.
%  O: an offset by which to displace the multivector before drawing (optional)
%  c: a color in which to draw the multivector (optional).
%
%  For bivectors, can set shape using 'GAbvShape'
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

set(gcf,'Render',GArender)

A = GAZ(s);

% if you assign to nargin, then Matlab doesn't set it
% We will set na to be 2 (no color) or 3 (color)
na = nargin;	

if nargin == 1
    O = GA([0;0;0;0;0;0;0;0]);
    na = 2;
elseif nargin == 2
    if isa(O,'char')
       c = O;
       O = GA([0;0;0;0;0;0;0;0]);
       na = 3;
    end
end

if isa(A,'double') 
    if nargin == 2
     title(['scalar = ' num2str(A)]);
    else
     title(['scalar = ' num2str(A)], 'Color', c);
    end
    hold on;
elseif GAisa(A,'double')
    if nargin == 2
     title(['scalar = ' num2str(A.m(1))]);
    else
     title(['scalar = ' num2str(A.m(1))], 'Color', c);
    end
    hold on;
elseif GAisa(A,'vector')
     if na == 2
	arrow(A,O);
     else
	arrow(A,O,c);
     end
     hold on;
elseif GAisa(A,'bivector')
     if na == 2
	drawBivector(A,O);
     else
        drawBivector(A,O,c);
     end
elseif GAisa(A,'trivector')
     if na == 2
        drawTrivector(A,O);
     else
        drawTrivector(A,O,c);
     end
else
     % Draw a multivector as the sum of its parts
     if sum(abs(A.m(2:4))) > 0
          M = GA([0; A.m(2:4); 0; 0; 0; 0]);
	  if na == 3
	    draw(M,O,c);
    	  else
	    draw(M,O);
	  end
     end
     if sum(abs(A.m(5:7))) > 0
          M = GA([0; 0; 0; 0; A.m(5:7); 0]);
	  if na == 3
	    draw(M,O,c);
    	  else
	    draw(M,O);
	  end
     end
     if A.m(8) ~= 0
          M = GA([0; 0; 0; 0; 0; 0; 0; A.m(8)]);
	  if na == 3
	    draw(M,O,c);
    	  else
	    draw(M,O);
	  end
     end
     if A.m(1) ~= 0
	  if na == 3
	    draw(A.m(1),O,c);
    	  else
	    draw(A.m(1),O);
	  end
     end
     return;	% Return to avoid 2 'axis' calls
end
% We want equal axes to avoid distortion.  However, we need
% the axis('auto') before hand to ensure that everything
% appears on the screen.
axis('auto');
axis('equal');
axis('tight');
