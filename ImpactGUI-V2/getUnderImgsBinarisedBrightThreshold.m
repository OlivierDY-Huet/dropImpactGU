function [T]=getUnderImgsBinarisedBrightThreshold(imgsE,imgS,Td) %Find the limit
%imgsE: {enhanced images}
%imgS: surface image [binary]

s=size(imgsE{1});
idx=reshape(imgS,1,s(1)*s(2));
imgs1D=cell(length(imgsE),1);
for n=1:length(imgsE)
    imgs1D{n}=reshape(imgsE{n},1,s(1)*s(2));
    idx2 = imbinarize(imgs1D{n},Td/255);
    idxF = any(cat(1,idx2,idx),1);
    imgs1D{n}=imgs1D{n}(idxF); %figure,imshow(imgs1D{n})
end
imgsFuse=cat(2,imgs1D{:}); %figure,imshow(imgsFuse) %figure,imhist(imgsFuse)
%T=graythresh(imgsFuse);
%T=uint8(255*T);

[Ts]=multithresh(imgsFuse,2);
T=uint8(max([Ts,Td+20]));


end