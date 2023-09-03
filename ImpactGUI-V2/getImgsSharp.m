function [imgs]=getImgsSharp(imgs) %Median filter
%imgs: {images} 

for n=1:length(imgs)
    imgs{n}=imsharpen(imgs{n});
end

end