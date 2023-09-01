function [imgsE]=getImgsEnhanced(imgsR,imgBG) %Improve the contrast between the drop(s) and the background
%imgsR: {raw images}
%imgBG: background image


imgsE=imgsR;
for n=1:length(imgsR)
    imgsE{n}=uint8(255*double(imgsE{n})./double(imgBG));
end

end