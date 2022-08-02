function mat = testmat( siz );
%
% matrix generator function for templates tester
%
   if ( siz == 10 ),
      mat = makefish( 4 );           % poisson matrix
   elseif ( siz == 20  ),
      mat = wathen( 3, 3, 0 );       % spd consistent mass matrix
   elseif ( siz == 30  ),
      mat = wathen( 3, 3, 1 );       % spd consistent mass matrix
   elseif ( siz == 40 ),
      mat = lehmer(5);
   elseif ( siz == 50 ),
      mat = lehmer(10);
   else
      mat = makefish( 4 );           % irrelevant: x0 = exact solution
   end
