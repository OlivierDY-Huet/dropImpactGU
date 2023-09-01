function [imgR]=getMovRaw(directo,format)

ext=['*.' format];

path=[directo filesep ext];
path=fullfile(path);
list=dir(path);

v=VideoReader(fullfile(directo,list(1).name));
imgR=cell(round(v.Duration*v.FrameRate),1); %imgR=cell(1,1);
n=0;
while hasFrame(v)
    n=n+1;
    imgV=readFrame(v);
    if size(imgV,3)==1
        imgR{n,1}=imgV;
    else
        imgR{n,1}=rgb2gray(imgV);
    end
end


end