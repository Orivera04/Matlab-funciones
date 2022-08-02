function out=numint3(integrand,var1,lowlim1,uplim1,var2,lowlim2,uplim2,var3,lowlim3,uplim3)
syms   uU vV
%newlowlim2=subs(lowlim2,var3,x);
%newuplim2=subs(uplim2,var3,x);
newvar2=lowlim2+uU*(uplim2-lowlim2);
newlowlim1=subs(lowlim1,var2,newvar2);
newuplim1=subs(uplim1,var2,newvar2);
newvar1=newlowlim1+vV*(newuplim1-newlowlim1);
integrand2=subs(integrand,{var1,var2},{newvar1,newvar2})*(uplim2-lowlim2)*(newuplim1-newlowlim1);
integrand3=inline(vectorize(integrand2),'vV','uU',var3);
out=trplquad(integrand3,0,1,0,1,lowlim3,uplim3);