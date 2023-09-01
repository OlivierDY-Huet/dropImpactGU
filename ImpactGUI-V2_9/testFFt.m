

f0=118;
C0 = [273 180];


Fs=3800;


Img = I.img.type.Mu;

L=length(Img)-f0+1;

x=round(linspace(20,98,5));

intCheck=nan(L,length(x));
for n=1:L
    Img2sample=Img{f0+n-1};
    for m=1:length(x)
        intCheck(n,m)=Img2sample(C0(2),C0(1)+x(m));
    end
    
end  

 legendCell = strcat('Px=',string(num2cell(x)));

figure
for m=1:length(x)
    plot(intCheck(:,m))
    hold on
end
xlabel('Intensity (int8)')
ylabel('Frame')
legend(legendCell)

f = Fs*(0:(L/2))/L;
figure,
for m=1:length(x)
    Y=fft(intCheck(:,m));
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(f,P1) 
    hold on
end
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|A(f)|')
legend(legendCell)


Y=fft2(double(imgF2));
    fh=figure('Units','Normalized');
    fh.WindowState = 'maximized';
    sfh(1)=subplot(1,2,1);
    imshow(imgF2)
    sfh(2)=subplot(1,2,2);
    imagesc(abs(fftshift(Y)))
