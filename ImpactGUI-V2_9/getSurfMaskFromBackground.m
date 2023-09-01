function [imgMask,level]=getSurfMaskFromBackground(imgBG,level)
%imgBG: background image

level=uint8(level);
level=double(level);
level=level/255;

imgMask=imbinarize(imgBG,level);
level=uint8(level*255);
%figure, imshow(imgMask)

end

