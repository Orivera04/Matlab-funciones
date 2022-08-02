function GAdemo
% GAdemo: a short demonstrations of the basics of GA
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
try
clc
disp('Welcome to the GABLE demonstration!');disp(' ');
disp('This script demonstrates some of the basic features of GABLE.');
disp('At any prompt, you may hit return to continue the demo or type');
disp('a Matlab command.');
disp(' ');
disp('This brief demonstration is intended to introduce you to the');
disp('the basic geometric elements of our geometric algebra (vectors,');
disp('bivectors, and trivector) and introduce the three basic products:');
disp('the outer product, the inner product, and the geometric product.');
disp('For a discussion of what these products are useful for, see our');
disp('tutorial.');

disp(' ');GAprompt;disp(' ');

disp('GABLE is an implementation of a Geometric Algebra (Cl3,0) with');
disp('graphical representations of the geometrical objects.  The defining');
disp('objects of a Geometric Algebra are a basis of vectors.  In GABLE,');
disp('we use a vector basis of {e1,e2,e3}');

disp(' ');GAprompt;disp(' ');

disp('We will now draw e1, e2, and e3, in the graphics window.');
disp('As we draw things, we will list the corresponding graphics');
disp('commands on lines starting with '' >> ''');
disp(' ');
disp('In our software, basic objects are drawn with the ''draw'' command,');
disp('which has an optional color argument.');
pause(5);
disp(' >> clf;');
clf;
disp(' >> draw(e1,''r'');');
draw(e1,'r');
drawnow
disp(' >> draw(e2,''m'');');
draw(e2,'m');
drawnow
disp(' >> draw(e3,''b'');');
draw(e3,'b');
drawnow;
disp(' ');
pause(1);
disp('In the graphics window, you should see three arrows.  The red one');
disp('represents e1, the magenta one e2, and the blue one e3.  Matlab');
disp('automatically rescales the axes as needed.');

disp(' ');GAprompt;disp(' ');

clc
disp('There are three products in a Geometric Algebra, the first of which');
disp('we will look at being the Outer product.  In GABLE, we use');
disp('the circumflx symbol (^) to take the outer product of two objects.');
disp('The outer product of two vectors is a bivector, which can be thought');
disp('of as a directed area element in the plane spanned by the two bivectors.');

disp(' ');GAprompt;disp(' ');

disp('As an example of a bivector, we will draw e1^e2.');
disp(' >> draw(e1^e2);');
draw(e1^e2);
drawnow
disp(' ');
disp('We have drawn a circle to represent this bivector.  Note that');
disp('the bivector drawn for e1^e2 lies in the plane defined by');
disp('e1 and e2');

disp(' ');GAprompt;disp(' ');

disp('To give a better feeling of the 3D relationships of the objects,');
disp('we have implemented a routine called GAorbit that rotates the');
disp('scene.  We will run it now to allow you a better view of the');
disp('three vectors and the bivector.');

pause(4);
disp(' >> GAorbit(-180)');
GAorbit(-180)

disp(' ');
disp('At prompts, you may find it useful to type GAorbit to visualize the');
disp('scene more clearly.  Try that now.');

disp(' ');GAprompt;disp(' ');

disp('The outer product of two objects yields a higher dimensional');
disp('object only if the two objects are linearly independent.  Thus,');
disp('the outer product e1^e1 is zero.  Type ''e1^e1'' in now and see');
disp('for yourself.');

disp(' ');GAprompt;disp(' ');
disp(' ');
disp('In addition to vectors and bivectors, there are trivectors,');
disp('which are formed as the outer product of three independent vectors.');
disp('We will now draw the trivector e1^e2^e3 (which has a special name,');
disp('''I3'') on the screen...');

disp(' >> draw(I3);');
draw(I3);
drawnow
pause(2);
disp(' ');

disp('We have drawn the trivector as a line drawing of a sphere, although it');
disp('should be thought of as a solid volume element.  In our space, the');
disp('trivector is the highest dimensional object, and the outer product');
disp('of the trivector with any other element in our space gives us zero,');
disp('since the two objects must be linearly dependent.');

disp(' ');GAprompt;disp(' ');

disp('Visualizing bivectors as circles and trivectors as spheres is not');
disp('the usual way to visualize them.  See the tutorial for another method');
disp('of visulazation.');

disp(' ');GAprompt;clc;

disp('The second product in a Geometric Algebra is the inner product,');
disp('which is similar to the dot product on vectors.  However, on');
disp('objects of different dimensions, it finds the object lying in');
disp('the higher dimensional space that is perpendicular to the lower');
disp('dimensional object.');

disp(' ');GAprompt;disp(' ');
disp(' ');

disp('We implemented the inner product as a Matlab routine called "inner"');
disp('As an example of the inner product, we draw the vector e1+e3 and the');
disp('bivector e1^e2.');
disp(' >> clf;');
clf;
pause(1);
disp(' >> draw(e1+e3);');
draw(e1+e3);
drawnow
disp(' >> draw(e1^e2);');
draw(e1^e2);
drawnow
disp(' ');
disp('(In Matlab, the command ''clf'' clears the display.)');

disp(' ');GAprompt;disp(' ');

disp('Next, we will draw in red the inner product of these two ');
disp('objects, inner(e1+e3,e1^e2), which we rotate for a better view...');
pause(3);
disp(' >> draw(inner(e1+e3,e1^e2),''r'');');
draw(inner(e1+e3,e1^e2),'r');
disp(' >> GAorbit(-180)');
pause(1);
GAorbit(-180)

disp(' ');GAprompt;disp(' ');

clc
disp('The third and most important product of a Geometric Algebra is the');
disp('Geometric Product.  Unfortunately, the geometric product is not');
disp('easily visualized.  However, one nice property it has that the other');
disp('two products do not have is an inverse.  The inverse allows you');
disp('to divide by vectors, bivectors, etc.');

disp(' ');GAprompt;disp(' ');

disp('Rather than visualize an object created by the geometric product, it');
disp('is better to think of it as creating an operator, and to visualize');
disp('this operator being applied to an object.  For example, if you have');
disp('a vector b and want to rotate it to vector a, you are looking for');
disp('an operator R such that b = Ra.  This suggests that R = b/a, which');
disp('we can compute with the geometric product.');

disp(' ');GAprompt;disp(' ');

disp('So try this out.  We''ll clear the screen and create the vectors for you:');
disp(' >> clf;');
clf;
disp(' >> a = (e1+e2)/sqrt(2);');
a = (e1+e2)/sqrt(2);
disp(' >> b = e2;');
b = e2;
pause(3);
disp('Now at the prompt create R, draw a, and draw b.');
disp('To get a 2D perspective on your picture, type GAview([0 90]) after drawing');

disp(' ');GAprompt;disp(' ');

disp('Now draw draw R*a in red (give a second argument of ''r'' to draw to get red).');

disp(' ');GAprompt;disp(' ');

disp('What you see is that the red vector (R*a) overwrote the blue b vector');
disp('as desired, since R is suppose to rotate a into b');
disp('Try rotating a second and third time by drawing R*R*a and R*R*R*a.');

disp(' ');GAprompt;disp(' ');

disp('This method of representation of rotations has some draw-backs that');
disp('we won''t discuss here; see the tutorial for a discussion of those ');
disp('draw-backs and a better representation of rotations.');

disp(' ');

disp('This is the end of our brief introduction to GABLE.');
disp('For a further discussion on Geometric Algebra, see our tutorial,');
disp('which investigates other visualizations of bivectors and trivectors,');
disp('and shows how to compute useful geometric calculations using');
disp('the three products described in this demonstration.');
catch ; end
