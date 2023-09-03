function [imgS,T]=getUnderneathFocus(imgBG,T)

if T==0
    T=graythresh(imgBG);
else
    T=T/255;
end
imgB=imbinarize(imgBG,T);
imgB=imfill(imgB,'holes');
s=size(imgB);
[qx,qy] = meshgrid(1:s(2),1:s(1));
r=regionprops(imgB,'PixelList');
XY=[];
for k=1:length(r)
    XY=cat(1,XY,r(k).PixelList);
end
shp = alphaShape(XY(:,1),XY(:,2));
tf=inShape(shp,qx,qy);
imgS=imfill(tf,'holes');
T=T*255;
end