function [imgs]=getImgsFiltMed(imgs) %Median filter
%imgs: {images} 

for n=1:length(imgs)
    imgs{n}=medfilt2(imgs{n},'symmetric');
end

end