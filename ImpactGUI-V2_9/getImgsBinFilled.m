function [imgsB]=getImgsBinFilled(imgsB,imgS,fillAS,fillOS) % Fill the holes (lens effect of the drop)

if fillAS==1
    for n=1:length(imgsB)
        if fillOS==0
            imgsB{n}=imfill(imgsB{n},'holes');
        else
            imgsB{n}=imfill(or(imgsB{n},~imgS),'holes').*imgS;
        end
    end
end
end