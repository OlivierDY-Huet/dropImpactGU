function [imgsRGB]=getImgsRGB(imgs)
%imgs: 1 or cell of images (grayscale or binary)

% Grayscale or logical?
if islogical(imgs{1})
    for n=1:length(imgs)
        imgs{n}=uint8(imgs{n}*255);
    end
end

% Color space
imgsRGB=cell(size(imgs));
for n=1:length(imgs)
    imgsRGB{n}=repmat(imgs{n},1,1,3); % OR imgs2RGB{n}=cat(3,imgs2{n},imgs2{n},imgs2{n});
end


end