%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Developed by Bapi Chatterjee, IIT Delhi, India               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The script steepest.m optimizes a multivariable function using steepest
% descent method.
% Input:
%       1)Dimensionality of the multivariable function.
%       2)Function in the proper format.
%         Note: Kindly ensure that the function is entered in the proper
%         format readable by MATLAB. This is the only point where the
%         maximum possibility of error is there.
%       3)Initial approximation vector.
%         Note: Kindly ensure that the dimensionalty matches with the
%         dimension of initial approximation vector.
%       4)Error tolerance.
%
% For the theory of steepest decent method, see "Practical methods of
% optimization- R. Fletcher, Second edition, 2003, John Wiley & Sons" or
% any other good book on unconstrained optimization methods.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Would you like to clear your workspace memory and command screen?');
z=input('To do so enter 1, any other number to continue:');
if z==1
    clc;clear
end
choice=input('To do a maximization enter 1, for minimization enter 2:');a=2;
while a==2
    if choice~=1&&choice~=2
        disp('Wrong input!');a=2;
        choice=input('To do a maximization enter 1, for minimization enter 2:');
    else
        a=1;
    end
end
a=2;mark=0;flag=0;count=0;syms b;u=[];warning off all
try
    while a==2
        n=floor(input('Enter the dimension of function:'));
        if n<1
            disp('Kindly enter a positive integer');a=2;
        else
            a=1;
        end
    end
catch
    disp('Kindly enter a positive integer');
end
a=2;
for i=1:n
    syms (['x' num2str(i)]);
end
while a==2
    try
        f=input('Enter the function in terms of variables x_i(i.e. x1,x2,etc.):');a=1;
    catch
        disp('Kindly recheck the index of variables and format of expression!');a=2;
    end
end
if choice==1
    f=-f;
end
x0=input('Enter the initial approximation row vector of variables:');a=2;
while a==2
    if length(x0)~=n
        disp('The dimension of initial approximation is incorrect!');a=2;
        x0=input('Enter the initial approximation as row vector of variables:');
    else
        a=1;
    end
end
try
    eps=abs(input('Enter the error tolerance:'));
catch
    disp('Kindly enter a real number!');
end
g=f;
try
    for i=1:n
        h(i)=diff(g,['x' num2str(i)]);
        for j=1:n
            k(i,j)=diff(h(i),['x' num2str(j)]);
        end
    end
catch
    disp('Your optimization problem can not be solved');
    return
end
disp('Hessian matrix of the function=')
if choice==1
    disp(-k)
elseif choice==2
    disp(k)
end
for i=1:n
    for j=1:n
        if i==j
            d=det(-k(1:i,1:j));
            if choice==1
                d=-d;
            end
            SOL=solve(d);
            if str2num(char(d))<=0
                mark=mark+1;u=[u i];
            elseif isempty(SOL)==0
                for m=1:length(SOL)
                    if isreal(SOL(m))==1||isa(SOL(m),'sym')
                        mark=mark+1;
                        if (length(find(u==i))==0)
                            u=[u i];
                        end
                    end
                end
            end
        end
    end
end
if mark>0
    if choice==1
        fprintf('\nThe %gth principal minor of Hessian is not negative at all real x!\n',u);
        fprintf('So the function is not concave globally and hence the global maximization is not guaranteed!\n');
    elseif choice==2
        fprintf('\nThe %gth principal minor of Hessian is not positive at all real x!\n',u);
        fprintf('So the function is not convex globally and hence the global minimization is not guaranteed!\n');
    end

else
    if choice==1
        fprintf('\nAll the principal minors of Hessian are negative so the function is concave globally!\n');
        disp('Hence a global maximization is possible!');
    elseif choice==2
        fprintf('\nAll the principal minors of Hessian are positive so the function is convex globally!\n');
        disp('Hence a global minimization is possible!');
    end
end
X=x0;
while flag~=1
    count=count+1;steplength=0;
    grad=h;fprintf('\n-------------------------%gth Iteration------------------\n\n\n',count)
    for i=1:n
        grad=subs(grad,['x' num2str(i)],X(i));
    end
    disp('Present point:');disp(X);
    disp('Gradient=');
    if choice==1
        disp(-grad)
    elseif choice==2
        disp(grad)
    end
    if max(abs(grad))>eps
        fprintf('\nThe error tolerance you provided has not been achieved yet\n');
        flag=input('To terminate enter 1, any other number to continue:');
    end
    if flag==1
        hes=k;
        for i=1:n
            hes=subs(hes,['x' num2str(i)],X(i));
        end
        fprintf('\n\n..........Result...........\n\n')
        if length(find(eig(hes)>0))==length(eig(hes))
            disp('At the present point the function is convex so it may be a local minimum!');
        elseif length(find(eig(hes)<0))==length(eig(hes))
            disp('At the present point the function is concave so it may be a local maximum!');
        else
            disp('The present point is not a local extremum!');
        end
        disp('Presently the hessian matrix is:');
        if choice==1
            disp(-hes)
        elseif choice==2
            disp(hes)
        end
        fprintf('The optimum point at %g error is:\n',max(abs(grad)));
        disp(X);
        for i=1:n
            f=subs(f,['x' num2str(i)],X(i));
        end
        fprintf('\nAnd the function value here is:\n')
        if choice==1
            disp(-f)
        elseif choice==2
            disp(f)
        end
        fprintf('The total number of iterations performed=%g\n',count);
    end
    if max(abs(grad))<=eps 
        fprintf('\n\nThe error tolerance you provided has been achieved.\n');
        hes=k;
        for i=1:n
            hes=subs(hes,['x' num2str(i)],X(i));
        end
        fprintf('\n\n..........Result...........\n\n')
        if length(find(eig(hes)>0))==length(eig(hes))
            disp('Also at the present point the function is convex so it may be a local minimum!');
        elseif length(find(eig(hes)<0))==length(eig(hes))
            disp('Also at the present point the function is concave so it may be a local maximum!');
        else
            disp('However the present point is not a local extremum point!');
        end
        disp('Presently the hessian matrix is:');
        if choice==1
            disp(-hes)
        elseif choice==2
            disp(hes)
        end
        fprintf('The optimum point at %g error is:\n',max(abs(grad)));
        disp(X);
        for i=1:n
            f=subs(f,['x' num2str(i)],X(i));
        end
        fprintf('\nAnd the function value here is:\n')
        if choice==1
            disp(-f)
        elseif choice==2
            disp(f)
        end
        fprintf('The total number of iterations performed=%g\n',count);flag=1;
    elseif max(abs(grad))>eps && flag~=1
        fun=f;
        for i=1:n
            fun=subs(fun,['x' num2str(i)],X(i)-b*grad(i));
        end
        diff(fun,b);
        d=solve(diff(fun,b));
        if isempty(d)==1
            steplength=0.001;
        else
            t=double(d);
            dd=diff(diff(fun,b));
            for i=1:length(t)
                if isreal(t(i))==1
                    if subs(dd,'b',t(i))>0
                        steplength=t(i);break
                    end
                end
            end
            if steplength==0
                for i=1:length(t)
                    if  isreal(t(i))==1
                        if t(i)>0
                            steplength=t(i);break
                        end
                    end
                end
            end
            if steplength==0
                steplength=0.001;
            end
        end
        funct=f;
        for i=1:n
            funct=subs(funct,['x' num2str(i)],X(i));
        end
        disp('Functional value at present=');
        if choice==1
            disp(-funct)
        elseif choice==2
            disp(funct)
        end
        disp('Step size taken=');disp(steplength);
        X=X-steplength*grad;
        if count>100
            disp('You already have performed 100 iterations and it seems that no extremum of the function exists!');
            flag=input('It is recommended that you terminate the procedure, to do so enter 1, any other number to continue:');
        end
    end
end

