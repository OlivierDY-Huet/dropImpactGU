function [imgs]=getImgsCleared(imgs,pts) %Crop the set of images
%imgs: {images} 
%pts: [x1,x2,y1,y2] with 1<2

for n=1:length(imgs)
    %Find average value amongst the air phase
    BW=imbinarize(imgs{n});
    meanPx=mean(imgs{n}(BW==1));
    %Replace the px by the mean value
    for m=1:size(pts,1)
        filledRect=uint8(ones(pts(m,4)-pts(m,3)+1,pts(m,2)-pts(m,1)+1).*meanPx);
        imgs{n}(pts(m,3):pts(m,4),pts(m,1):pts(m,2))=filledRect;
    end
end


end