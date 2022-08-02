     disp('>> % 	SPANNING A TRIVECTOR');
     % 	SPANNING A TRIVECTOR
     GAfigure; clc; %/
     disp('>> % 	SPANNING A TRIVECTOR');
     % 	SPANNING A TRIVECTOR
     disp('>> %');
     %
     global dummy; %/
     clf; %/
     disp('>> % 	We can also span a TRIVECTOR:');
     % 	We can also span a TRIVECTOR:
     fprintf(1,'\n');     fprintf(1,'>> e1^e2^e3  ');
     input('');
     e1^e2^e3 %w
     disp('>> % I3  is called the PSEUDOSCALAR of 3-space ');
     % I3  is called the PSEUDOSCALAR of 3-space 
     GAprompt; %/
     disp('>> % 	Again, there is anti-symmetry:');
     % 	Again, there is anti-symmetry:
     fprintf(1,'\n');     fprintf(1,'>> e2^e1^e3  ');
     input('');
     e2^e1^e3 %w
     GAprompt; %/
     disp('>> % 	Here''s how we draw it:');
     % 	Here's how we draw it:
     disp('>> draw(I3);');
     draw(I3);
     GAtext(0.7*e1+0.2*e3,'I3'); %/
