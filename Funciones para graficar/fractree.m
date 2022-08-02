function fractree(X,Y,length,direction)

%  Fractal Trees  by Stephen Battey
%                   batteysp@aston.ac.uk
%    3rd March 1998
%  written for Matlab V4.2c
%   Modified 13th March 1998 - new stopping criterium
%
%  Script draws a fractal tree for a specified
%       number of branches, angle & distance factor ...
%
%   Each branch is 'distance-factor' times the last in length
%  and leans off to the left/right at the given angle. The depth
%  of the tree limits the total number of branches drawn.
%   Random trees can be generated from an integer seed. 


global angle distFactor branches minLen branchFac;

if  nargin<1

%  For initial call, get user input for parameters

  branchFac = [ 1 -1 0 ];

  fprintf('\n  Fractal Trees\n\n');
  angle=pi*(input('Enter angle (0 - 180, zero for random) : ')/180);
  distFactor=input('Enter distance factor (0 - 1, zero for random) : ');
  if  angle==0  |  distFactor==0
    seed=input('Enter the random number seed (integer) : ');
    rand('seed',seed);
  end
  branches=input('Enter the number of branches (2 or 3) : ');
  maxDepth=input('Enter the maximum depth of the tree : ');

%  Thanks to Ken Crounse for the stopping criterium
  if distFactor~=0
    minLen=distFactor.^(maxDepth-0.5);
  else
    minLen=0.5.^(maxDepth-0.5);
  end

%  Declare figure window for output
  figure(1);
  axis('square','equal','off');
  hold on
  fractree(0,0,1,0);
  hold off
  disp('  ');

else

%  Calculate end position of the branch
  newX=X+(length*sin(direction));
  newY=Y+(length*cos(direction));

%  Set the colour for a branch, twig or leaf
  colStr='r-';
  if length<0.25
    colStr='g-';
  end
  if length<0.03125
    colStr='w-';
  end

%  Draw the branch
  plot([X newX],[Y newY],colStr);


%  If the branch is reasonably long...
  if length>minLen

%  extend new branches to it
    for brNo=1:branches

%  Calculate length and direction of the next branch
      if distFactor==0
        newLength=length*( (rand(1)*.5) + .25 );
      else
        newLength=length*distFactor;
      end

      if angle==0
        newDir=direction+( ((rand(1)*1.7453)+0.1745) * branchFac(brNo) );
      else
        newDir=direction+(angle*branchFac(brNo));
      end

%  Call the routine again to draw next branch
      fractree(newX,newY,newLength,newDir);

    end

  end

end
