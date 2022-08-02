     disp('>> % 	GEOMETRIC PRODUCT');
     % 	GEOMETRIC PRODUCT
     GAfigure; clc; %/
     disp('>> % 	GEOMETRIC PRODUCT');
     % 	GEOMETRIC PRODUCT
     disp('>> %');
     %
     global a b; %/
     clf; %/
     disp('>> a = e1 + e3;');
     a = e1 + e3;
     disp('>> b = e1 + e2; ');
     b = e1 + e2; %%
     GAprompt;
     disp('>> %	We use * to denote the geometric product in GABLE:');
     %	We use * to denote the geometric product in GABLE:
     fprintf(1,'>> a*b   ');
     input('');
     a*b %w 
     disp('>> %	Note: scalar + bivector ! ');
     %	Note: scalar + bivector ! 
     GAprompt; %/
     disp('>> %	Order matters!');
     %	Order matters!
     fprintf(1,'>> b*a     ');
     input('');
     b*a    %w
     GAprompt; %/
     disp('>> %	Square of a vector is scalar');
     %	Square of a vector is scalar
     fprintf(1,'>> b*b     ');
     input('');
     b*b    %w
     disp('>> %	Square of a bivector is negative');
     %	Square of a bivector is negative
     fprintf(1,'>> (e1^e2)*(e1^e2)     ');
     input('');
     (e1^e2)*(e1^e2)    %w
     disp('>> %	Every non-null vector has an inverse');
     %	Every non-null vector has an inverse
     fprintf(1,'>> 1/b     ');
     input('');
     1/b    %w
     fprintf(1,'>> b*(1/b)     ');
     input('');
     b*(1/b)    %w
     GAprompt; %/
     disp('>> % 	Inverse formula: ');
     % 	Inverse formula: 
     fprintf(1,'>> b/(b*b)     ');
     input('');
     b/(b*b)    %w
     GAprompt; %/
     disp('>> % 	Inverse of unit vector:');
     % 	Inverse of unit vector:
     fprintf(1,'>> 1/e1     ');
     input('');
     1/e1    %w
     GAprompt; %/
     disp('>> %	The geometric product is invertible; ');
     %	The geometric product is invertible; 
     disp('>> %	From (a*b) and b, retrieve a = e1+e3 :');
     %	From (a*b) and b, retrieve a = e1+e3 :
     disp('>> a*b');
     a*b
     disp('>> b');
     b
     fprintf(1,'>> (a*b)/b     ');
     input('');
     (a*b)/b    %w
