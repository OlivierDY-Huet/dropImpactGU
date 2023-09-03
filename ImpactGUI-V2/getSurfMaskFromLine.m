function [imgMask]=getSurfMaskFromLine(imgBG,surfLimit) % Give the mask in order to ignore the pixels belonging to the surface
%imgBG: background image
%surfLimit:[postion y of limit at the middle of image, angle of limit] [px,deg]

s=size(imgBG);

% Limit parameters: y=mx+p
m=tand(-surfLimit(2));
p=surfLimit(1)-m*mean([1,s(2)]);

% surface mask
[X,Y]=meshgrid(1:s(2),1:s(1));
imgMask=(Y<m.*X+p);
%figure, imshow(imgMask)

end