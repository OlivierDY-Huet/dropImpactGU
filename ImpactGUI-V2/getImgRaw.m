function [imgR]=getImgRaw(directo,format)

ext=['*.' format]; %example '*.tif'

path=[directo filesep ext];
path=fullfile(path);
list=dir(path);
imgR=cell(length(list),1);
for n=1:length(imgR)
    imgR{n}=imread(fullfile(directo,list(n).name),ext(3:end));
end

end