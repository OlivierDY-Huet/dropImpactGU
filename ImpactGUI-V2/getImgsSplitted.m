function [imgs1,imgs2]=getImgsSplitted(imgs0,splitPxY,cropPosi) %Split the raw images into side and underneath ones
%imgs: {images}


if splitPxY ~=0
    splitPxY = splitPxY - cropPosi(3)+1;
    imgs1=cell(size(imgs0));
    imgs2=cell(size(imgs0));
    s=size(imgs0{1});
    for n=1:length(imgs0)
        imgs2{n}=imgs0{n}(splitPxY:s(1),:);
        imgs1{n}=imgs0{n}(1:splitPxY-1,:);
    end
    
else
    imgs1=imgs0;
    imgs2=cell(1,1);
end

end