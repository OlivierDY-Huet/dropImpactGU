function    [imgsRGB]=drawBWonRaw(imgsBW,imgsR,colorDrops)

imgsRGB=cell(size(imgsBW));
s=size(imgsBW{1});
for n=1:length(imgsBW)
    imgsBW{n}=uint8(imgsBW{n});
    imgsRGB{n}=cat(3,imgsBW{n}.*colorDrops(1),imgsBW{n}.*colorDrops(2),imgsBW{n}.*colorDrops(3)); 
    idx=find(imgsBW{n}==0);
    imgsRGB{n}(idx)=imgsR{n}(idx);
    imgsRGB{n}(idx+s(1)*s(2))=imgsR{n}(idx);
    imgsRGB{n}(idx+2*s(1)*s(2))=imgsR{n}(idx);
end

end