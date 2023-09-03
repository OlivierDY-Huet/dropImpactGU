
f0=118;
C0 = [273 180];


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
% hold on
% plot3([0 2.7],[2 2],[0 0],'-r','LineWidth',2)
% plot3([0 0],[2 4.8],[0 0],'-r','LineWidth',2)
% plot3([2.7 0],[2 4.8],[0 0],'-r','LineWidth',2)
% plot3([0 0],[2 7.2],[0 0],'--r','LineWidth',2)
% plot3([2.7 0],[2 7.2],[0 0],'--r','LineWidth',2)

% figure, contour(xx2,yy2,zz)
% xlabel('Distance form the drop center [mm]')
% ylabel('Time [ms]')
% xlim([min(xx2(:)) max(xx2(:))])
% ylim([min(yy2(:)) max(yy2(:))])
% view(0,-90)
% colorbar

% figure, 
% waterfall(xx2,yy2,zz)
% xlabel('Distance form the drop center [mm]')
% ylabel('Time [ms]')
% zlabel('Pixel intensity [uint8]')
% xlim([min(xx2(:)) max(xx2(:))])
% ylim([min(yy2(:)) max(yy2(:))])
% view(0,-90)
% c=colorbar;
% c.Label.String='Pixel intensity [uint8]';


% figure, 
% waterfall(xx2',yy2',zz')
% xlabel('Distance form the drop center [mm]')
% ylabel('Time [ms]')
% zlabel('Pixel intensity [uint8]')
% xlim([min(xx2(:)) max(xx2(:))])
% ylim([min(yy2(:)) max(yy2(:))])
% view(0,-90)
% c=colorbar;
% c.Label.String='Pixel intensity [uint8]';


% s=round(linspace(9,27,10));
% pP=length(s);
% figure,
% for k=1:p
% subplot(p,1,k)
% plot(xx2(s(k),:),zz(s(k),:))
% legend({['Time: ',num2str(yy2(s(k),1)),' ms']})
% xlim([min(xx2(:)) max(xx2(:))])
% ylim([0 255])
% end

%------------------------------------------------
s=round(linspace(9,27,10));
pP=length(s);
legNames={};
colorLine=jet(pP);
figure,
for k=1:pP
plot(xx2(s(k),:),1-zz(s(k),:)/255+(k-1),'-','color',colorLine(k,:)),
hold on
legNames=cat(2,legNames,{['Time: ',num2str(yy2(s(k),1)),' ms']});
% xlim([min(xx2(:)) max(xx2(:))])
% ylim([0 255])
% end
disp(num2str(f0+s(k)-1))
end
legend(legNames)
xlabel('Distance form the drop center [mm]')
set(gca,'YTickLabel',[]);
set(gca, 'YDir','reverse')
grid on

xP=[0.4444,0.7407,1.1074,1.407,1.704,1.963,2.185,2.407]';
yP=[8.141,7.051,6.278,5.329,4.176,3.094,2.173,1.212]';
yP0=getPtsYBase(yP);

plot(xP,yP,'*r')
plot(xP,yP0,'^r')
pP=polyfit(xP,yP0,1);
yPfit=polyval(pP,xP);
plot(xP,yPfit,'--r')
c_pP=(xP(end)-xP(1))/(yy2(s(end-1),1)-yy2(s(1+1),1));
lambdaP=(2*pi*0.072)/(1000*c_pP^2);
xE=[3.037,3.148,3.259,3.407,3.519,3.63]';
yE=[9.376,8.38,7.4,6.42,5.498,4.545]';
yE0=getPtsYBase(yE);
plot(xE,yE,'*k')
plot(xE,yE0,'^k')
pE=polyfit(xE,yE0,1);
yEfit=polyval(pE,xE);
plot(xE,yEfit,'--k')
c_pE=(xE(end)-xE(1))/(yy2(s(end),1)-yy2(s(1+4),1));
lambdaE=(2*pi*0.072)/(1000*c_pE^2);

c_pP-c_pE



%---------------




%---------------

function [y0]=getPtsYBase(y)
y0=ceil(y);
end







