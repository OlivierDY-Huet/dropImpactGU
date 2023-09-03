function [imgBG]=getImgBackground(imgsR,nBase,intMod) %Create the background image
%imgsR: {raw images} 
%nBase: number of images used to create the BG

L=nBase;
s=size(imgsR{1});
imgF=zeros(s(1),s(2),L);
for n=1:L
    imgF(:,:,n)=imgsR{n}(:,:);
end
imgF=sort(imgF,3);
imgBG=uint8(double(imgF(:,:,round(L*0.8)))*intMod/100);

end