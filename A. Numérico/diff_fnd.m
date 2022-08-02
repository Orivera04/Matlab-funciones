%  diff_fnd is a difference approximation finder.
%  All inputs are prompted by the program.
%  See subsection 6.4.2 of text.
%  Copyright S. Nakamura, 1995  
while 1
clear, clg,clc
   fprintf( '\n============================================\n' );
   fprintf( ' Difference Approximation Finder  \n' );
   while 1
      km = input( '** Number of points ?  ' );
      if km>1 break; end
      fprintf(' Input is invalid: Repeat.\n')
   end
% 
   while 1
      fprintf( 'Input the point indices in row vector form ')
      fprintf( 'like [x x ... x]');  el = input(''); 
      if length(el) == km;  break; end  
      fprintf( ' Number of points do not match with indices')  
      fprintf( ' Repeat your input for indices.')
   end
   kdr = input('** Order of difference scheme to be derived ?   ' );
   z = 1.0; for  i = 1:kdr;  z = z*i; end
   for k = 1:km+2;   a(k,:) = el.^(k-1); end
   M = a(1:km, 1:km);   
   rs = zeros(1:km)';  rs(kdr+1) = z;
%  kmp2 = km + 2;       
   y = M^(-1)*rs;   
	  c = a*y;
   u = abs(y);
   for k = 1:km+2
       if k<=km; if u(k)<0.000001, u(k) = 1000;end; end
       if( abs( c(k) ) < 0.00000001 ) c(k) = 0;end
   end
   f_min = min(u);
	  cf = y/f_min;
   fprintf( '\nDifference scheme:\n' );
   for  k = 1:km   
       finv = 1.0/f_min;
       fprintf(  ' +(%8.5f/( %8.5f h^%1.0f))*', cf(k),finv, kdr)
       fprintf(  'f( %3.1fh ) \n',  el(k) );
   end
   fprintf('\nError term\n');
   dd = 1.0;
   for k = 1:km
         dd = dd*k;
   end
   for k = km+1:km+2,   
      cm = -c(k);  
      %km1 = k - 1;   
      nh = k-1-kdr;
      if( k == km+1 & cm ~= 0 ) 
             fprintf(  '    (%7.3f/%7.3f)h^%1.0f f', cm, dd, nh );
             for (i=1:k-1)   fprintf( '`' );
             end
             break
      end
      if( k == km + 2 ),   
         fprintf(  '\n   +(%7.3f/%7.3f)h^%1.0f f', cm, dd, nh );
           for i=1:k-1    
              fprintf( '`' );
           end
       end
       dd = dd*k ;
    end
    fprintf('\n============================================')
    kont = input( 'Type 1 to continue, or 0 to stop:' );
    if kont ==0, break; end
 end                 
