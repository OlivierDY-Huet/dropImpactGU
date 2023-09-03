function [imgs]=getImgsCropped(imgs,pts) %Crop the set of images
%imgs: {images} 
%pts: [x1,x2,y1,y2] with 1<2

rect=[pts(1),pts(3),pts(2)-pts(1),pts(4)-pts(3)];

%Crop
for n=1:length(imgs)
    imgs{n}=imcrop(imgs{n},rect);
end

end