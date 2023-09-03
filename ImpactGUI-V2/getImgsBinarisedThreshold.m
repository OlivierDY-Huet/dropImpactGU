function [T]=getImgsBinarisedThreshold(imgsE,imgS) %Find the limit
%imgsE: {enhanced images}
%imgS: surface image [binary]

s=size(imgsE{1});
idx=reshape(imgS,1,s(1)*s(2));
imgs1D=cell(length(imgsE),1);
for n=1:length(imgsE)
    imgs1D{n}=reshape(imgsE{n},1,s(1)*s(2));
    imgs1D{n}=imgs1D{n}(idx);
end
imgsFuse=cat(1,imgs1D{:});
T=graythresh(imgsFuse);
T=uint8(255*T);

end
