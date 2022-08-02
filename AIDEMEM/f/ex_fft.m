function ex_fft
im = 1:8; im =im(ones(1,8),:); im = im(:)';
im = im(ones(1,64),:); colormap(gray);
f = 'imagesc(im);axis square;axis off';
dessine(im, 0, f)
im = peaks(64);
f = 'surf(im);axis square;shading interp';
dessine(im, 5, f)

function dessine(im, n, f)

subplot(2,5,n+1)
eval(f); title({'image','originale','64x64'});
ft = fft2(im);
subplot(2,5,n+2)
surf(angle(ft));title({'fft','phase'});axis square; 
subplot(2,5,n+3)
surf(abs(ft));title({'fft','module'});axis square;
subplot(2,5,n+4);
im = real(ifft2(ft(1:64,1:64)));
eval(f);title({'image', 'reconstituée','64x64'});
subplot(2,5,n+5);
im = real(ifft2(ft(1:16,1:16)));
eval(f);title({'image', 'reconstituée','16x16'});

