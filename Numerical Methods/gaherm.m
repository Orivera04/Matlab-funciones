function s=gaherm(func,n)
% Implements Gauss-Hermite integration.
%
% Example call: s=gaherm(func,n)
% Integrates user defined function func from -inf to +inf, using n divisions
% n must be 2 or 4 or 8 or 16
%
if (n==2)|(n==4)|(n==8)|(n==16)
  c=zeros(8,4); t=zeros(8,4);
  c(1,1)  = 1.461141183;
  c(1:2,2)=[1.059964483; 1.240225818];
  c(1:4,3)=[.7645441286; .7928900483; .8667526065; 1.071930144];
  c(:,4)  =[.5473752050; .5524419573; .5632178291; .5812472754; ...
            .6097369583; .6557556729; .7382456223; .9368744929];
  t(1,1)  = .7071067811;
  t(1:2,2)=[.5246476233; 1.650680124];
  t(1:4,3)=[.3811869902; 1.157193712; 1.981656757; 2.930637420];
  t(:,4)  =[.2734810461; .8229514491; 1.380258539; 1.951787991; ...
            2.546202158; 3.176999162; 3.869447905; 4.688738939];
  j=1;
  while j<=4
    if 2^j==n;break;
    else
      j=j+1;
    end
  end
  s=0;
  for k=1:n/2
    x1=t(k,j); x2=-x1;
    y=feval(func,x1)+feval(func,x2);
    s=s+c(k,j)*y;
  end
else
  disp('n must be equal to 2, 4, 8 or 16');break
end
