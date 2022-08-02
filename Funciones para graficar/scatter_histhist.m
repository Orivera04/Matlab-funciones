function [hm, hx, hy]=scatter_histhist(x, x_sig, y,y_sig, x_lim, y_lim)
% [hm, hx, hy]=scatter_histhist(x, x_sig, y,y_sig, x_lim, y_lim)

org=0.15;
wdth=0.5;
hist_h=0.2;
num_bns=17;

	x_lim_b=[min(x)-0.1 max(x)+0.1];
	y_lim_b=[min(y)-0.1 max(y)+0.1];

if nargin==4;
	x_lim=x_lim_b;
	y_lim=y_lim_b;
end
	


figure

hx=axes('Position',[org org+wdth+0.01 wdth hist_h]);
hy=axes('Position',[org+wdth+0.01 org hist_h wdth]);
hm=axes('Position',[org org wdth wdth]);


marker_size=zeros(size(x))+12;
marker_size(x_sig==1)=24;
marker_size(y_sig==1)=24;
marker_size(x_sig+y_sig==2)=36;

% make the scatter plot
axes(hm);
scatter(x, y, marker_size,'k');
xlim(x_lim);
ylim(y_lim);
xhairs;
text(getx,gety,['n=' num2str(numel(x))])

% make the y-axis histogram
axes(hy);
bns=linspace(y_lim_b(1),y_lim_b(2),num_bns);
nsig=histc(y(y_sig==0), bns);
nsig=nsig(1:end-1);
sig=histc(y(y_sig==1), bns);
sig=sig(1:end-1);
cbns=edge2cen(bns);
[hh]=barh(cbns, [sig nsig],'stacked');
set(gca, 'YTick',[]);
ylim(y_lim);
set(gca, 'XAxisLocation','bottom');
set(hh(1),'FaceColor','k')
set(hh(2),'FaceColor',[1 1 1])
set(gca,'box','off')
set(gca,'Color','none')
text(getx,gety,[num2str(round(100*mean(y_sig))) '% p<0.05'])
y_mean=mean(y);
yt_sig=ttest(y);
if yt_sig
    hy_m=axes('Position',get(hy,'Position'));
    plot([0 1],[y_mean, y_mean],':k');
    set(hy_m, 'Visible','off')
   
end

% make the x-axis histogram

axes(hx);
bns=linspace(x_lim_b(1),x_lim_b(2),num_bns);
nsig=histc(x(x_sig==0), bns);
nsig=nsig(1:end-1);
sig=histc(x(x_sig==1), bns);
sig=sig(1:end-1);
cbns=edge2cen(bns);
[hh]=bar(cbns, [sig nsig],'stacked');
set(gca, 'XTick',[]);
xlim(x_lim);
set(gca, 'YAxisLocation','left');
set(hh(1),'FaceColor','k')
set(hh(2),'FaceColor',[1 1 1])
set(gca,'box','off')
set(gca,'Color','none')
text(getx,gety,[num2str(round(100*mean(x_sig))) '% p<0.05'])

x_mean=mean(x);
xt_sig=ttest(x);
if xt_sig
    hx_m=axes('Position',get(hx,'Position'));
    plot([x_mean, x_mean],[0 1],':k');
    set(hx_m, 'Visible','off')
   
end


function y=edge2cen(x)
b2b_dist=x(2)-x(1);
y=x+0.5*b2b_dist;
y=y(1:end-1);

function y=getx
x=xlim;
y=0.1*(x(2)-x(1))+x(1);

function y=gety
x=ylim;
y=0.9*(x(2)-x(1))+x(1);





