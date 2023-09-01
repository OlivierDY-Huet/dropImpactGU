function [imgsB]=getUnderImgsBinarised(imgsE,imgS,P,Td,Tb) %Binarisation
%imgsE: {enhanced images}
%imgS: surface image [binary]
%T=Treshold

Td=double(Td)/255;
Tb=double(Tb)/255;
s=size(imgsE{1});
idx=reshape(imgS,1,s(1)*s(2));
imgsB=cell(length(imgsE),1);
for n=1:length(imgsE)
    imgsB{n}=~imbinarize(imgsE{n},Td); %figure, imshow(imgsB{n})
    if P==2
        imgBsup=imbinarize(imgsE{n},Tb); %figure, imshow(imgBsup)
        imgsB{n}=any(cat(3,imgsB{n},imgBsup),3);
    end
    imgsB{n}(~imgS)=false(sum(~idx),1); %Remove surface form the binary image
end

end

