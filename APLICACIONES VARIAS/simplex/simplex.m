% _________________Simplex Method By Kshitij Deshpande________%
clear all
clc
prompt = {'Function(f)=','Constraints(as an n x m Matrix)=','b(j)(In Matrix form)='};
lineno=1;
title= 'Enter Data';
def={'[1 2 1]','[2 1 -1;2 -1 5;4 1 1]','[2 6 6]'};
a = inputdlg(prompt,title,lineno,def);
a=char(a);
[m,n] = size(a);
f=eval(a(1,1:n));const =eval(a(2,1:n));b=eval(a(3,1:n)) ;
f=-f;
flag=0;
const1 = [const;f]; 
[m,n]=size(const1);

l=1;
it=1;
while n<6 
   const1(l,n+1)=1;
    l=l+1;
    n=n+1;
 end   
 f=const1(m,1:n);
 b(4)=0;
 oldi=0;
while any(f(1:n)<0)
   [p,q] = size(f);  
   basevar=0;
 for i=1:q-1
    if f(i)<0 & f(i+1) <0
       basevar=[abs(f(i));abs(f(i+1))];
       basevar=max(basevar);
       basevar=-basevar;
    else if f(i)<0 | f(i+1) <0 | f(i)==f(i+1)
          if f(i)~=0 & f(i+1)~=0
          basevar=[f(i);f(i+1)];     
          basevar=min(basevar);
        end
     end
  end
  
     end
  
 for i=1:q
    if f(i)==basevar
       break;
    end
 end
 fprintf('We Choose now the basic variable to be x%d',i);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Selection Of Pivot Element
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [m,n]=size(const1);
 ratio=[];
 for row=1:(m-1)
    if const1(row,i)>0
       ratio =[ratio ;b(row)/const1(row,i) row]  ;
    end
  end
 [r,s]=size(ratio);
 [ratio1 index] = min(ratio(1:r,1)) ;
 ratio = [ratio1 ratio(index,2)]; 
 pivot = const1(ratio(1,2),i);
 %%%%%%%Pivot Acieved%%%
 %Using Pivot element for futher application
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [m,n]=size(const1);
 const1(it,1:n)=const1(it,1:n)./pivot;
 b(it) = b(it)./pivot;
 if it~=1
    x=1;
 else
    x=2;
 end
 
while x<=m 
    ratio = const1(it,i)/const1(x,i);
    switch x
    case{1}
       sub = const1(x,1:n)-const1(it,1:n);
       if sub(i)~=0
          sub = const1(x,1:n)+const1(it,1:n);
          if sub(i)~=0
             const1=[const1(x,1:n).*ratio;const1(x,1:n);const1(3:m,1:n)];
             b(x) = b(x)*ratio;
            end 
       end   
    case{2}
       sub = const1(x,1:n)-const1(it,1:n);
       if sub(i)~=0
          sub = const1(x,1:n)+const1(it,1:n);
          if sub(i)~=0
             const1=[const1(1,1:n);const1(x,1:n).*ratio;const1(3:m,1:n)];
              b(x) = b(x)*ratio;
           end  
        end  
     case{3}
        sub = const1(x,1:n)-const1(it,1:n);
        if sub(i)~=0
           sub = const1(x,1:n)+const1(it,1:n);
           if sub(i)~=0
              const1=[const1(1,1:n);const1(2,1:n);const1(x,1:n).*ratio;const1(4,1:n)];
               b(x) = b(x)*ratio;
           end
           
        end   
     case{4}
        sub = const1(x,1:n)-const1(it,1:n);
        if sub(i)~=0
           sub = const1(x,1:n)+const1(it,1:n);
           if sub(i)~=0
              const1=[const1(1,1:n);const1(2,1:n);const1(3,1:n);const1(x,1:n).*ratio];
              b(x) = b(x)*ratio;
           end   
        end
     end
     
    sub = const1(x,1:n)-const1(it,1:n);
    if sub(i)~=0
       const1(x,1:n) =   const1(x,1:n)+const1(it,1:n);
       b(x) = b(x)+b(it);
    else
       if ratio>0
          const1(x,1:n) = sub;
          b(x) = b(x)-b(it);
       else
          const1(x,1:n) = -sub;
          b(x) = -(b(x))+b(it);
      end   
       
   end
   if x+1==it
      x=x+2;
   else
      x=x+1;
    end  
 end
 [m,n]=size(const1);
 f=const1(m,1:n)  
 if i==oldi+1 & oldi~=0
    f_(oldi) = f(oldi)*b(1);
    f_(i) =f(i)*b(2);
    f_(n) = f(n)*b(3);
    answer = sum([f_(oldi) f_(i) f_(n)]);
    answer = b(4)-answer
    report simplex
    disp('Press any Key to Continue....');
    pause
 else
    f_(i)=f(i)*b(1);
    f_(n-2)=f(n-1)*b(2);
    f_(n-1)=f(n)*b(3);
    answer=sum([f_(i) f_(n-2) f_(n-1)]);
    answer = -(b(4)-answer)
    report simplex
    disp('Press any Key to Continue....');
    pause
 end  
  oldi=i;
  it=it+1;
end