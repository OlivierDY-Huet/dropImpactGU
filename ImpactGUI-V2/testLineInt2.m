
f0=51;
C0 = [252 165];


Fs=3800;
r=27;

Img = I.img.type.Mu;


x=0:100;
y=0:length(Img)-f0;
[xx,yy] = meshgrid(x,y);
zz=nan(length(y),length(x));
for n=1:length(y)
    Img2sample=Img{f0+n-1};
    for m=1:length(x)
        zz(n,m)=Img2sample(C0(2),C0(1)+x(m));
    end
end
xx2=xx/r;
yy2=yy*1000/Fs;


figure, surf(xx,yy,zz)
xlabel('Distance form the drop center [px]')
ylabel('Time [frame]')
xlim([min(xx(:)) max(xx(:))])
ylim([min(yy(:)) max(yy(:))])
view(0,-90)
colorbar

figure, 
surf(xx2,yy2,zz)
xlabel('Distance form the drop center [mm]')
ylabel('Time [ms]')
zlabel('Pixel intensity [uint8]')
xlim([min(xx2(:)) max(xx2(:))])
ylim([min(yy2(:)) max(yy2(:))])
view(0,-90)
c=colorbar;
c.Label.String='Pixel intensity [uint8]';
%set(h,'linestyle','none')
%shading interp
hold on
plot3([0 2.7],[2 2],[0 0],'-r','LineWidth',2)
plot3([0 0],[2 4.8],[0 0],'-r','LineWidth',2)
plot3([2.7 0],[2 4.8],[0 0],'-r','LineWidth',2)
plot3([0 0],[2 7.2],[0 0],'--r','LineWidth',2)
plot3([2.7 0],[2 7.2],[0 0],'--r','LineWidth',2)

% figure, contour(xx2,yy2,zz)
% xlabel('Distance form the drop center [mm]')
% ylabel('Time [ms]')
% xlim([min(xx2(:)) max(xx2(:))])
% ylim([min(yy2(:)) max(yy2(:))])
% view(0,-90)
% colorbar

figure, 
waterfall(xx2,yy2,zz)
xlabel('Distance form the drop center [mm]')
ylabel('Time [ms]')
zlabel('Pixel intensity [uint8]')
xlim([min(xx2(:)) max(xx2(:))])
ylim([min(yy2(:)) max(yy2(:))])
view(0,-90)
c=colorbar;
c.Label.String='Pixel intensity [uint8]';


figure, 
waterfall(xx2',yy2',zz')
xlabel('Distance form the drop center [mm]')
ylabel('Time [ms]')
zlabel('Pixel intensity [uint8]')
xlim([min(xx2(:)) max(xx2(:))])
ylim([min(yy2(:)) max(yy2(:))])
view(0,-90)
c=colorbar;
c.Label.String='Pixel intensity [uint8]';


