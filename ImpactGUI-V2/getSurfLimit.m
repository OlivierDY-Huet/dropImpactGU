function [limPxList]=getSurfLimit(imgS,thickness)
%imgS: binary image of surface

s=size(imgS);

% surface limit
imgS2=cat(1,imgS,false(1,s(2)));
imgS2=cat(2,false(s(1)+1,1),imgS2,false(s(1)+1,1)); %figure, imshow(imgS2)
imgLim=bwperim(imfill(~imgS2,'holes'),8);
imgLim=imgLim(1:end-1,2:end-1); %figure, imshow(imgLim)


% tichness
if thickness>1
    imgblack=false((s(1)+thickness-1),s(2));
    for k=1:thickness
        imgblack(k:(s(1)+k-1),:)=or(imgblack(k:(s(1)+k-1),:),imgLim); %figure, imshow(imgblack)
    end
    imgLim=imgblack(1:s(1),:); %figure, imshow(imgLim)
end
rp=regionprops(imgLim,'PixelIdxList');
limPxList={cat(1,rp(:).PixelIdxList)};

end