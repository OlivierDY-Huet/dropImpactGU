function [imgsB]=getImgsBinarised(imgsE,imgS,T) %Binarisation
%imgsE: {enhanced images}
%imgS: surface image [binary]
%T=Treshold

T=double(T)/255;
s=size(imgsE{1});
idx=reshape(imgS,1,s(1)*s(2));
imgsB=cell(length(imgsE),1);
for n=1:length(imgsE)
    imgsB{n}=~imbinarize(imgsE{n},T);
    imgsB{n}(~imgS)=false(sum(~idx),1); %Remove surface form the binary image
end

end

