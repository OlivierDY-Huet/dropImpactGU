function [imgsT]=getImgsMainDrop(imgsB,d,rNew)

imgsT=imgsB;
for n=1:length(imgsB)   
    imgsT{n}=uint8(255*imgsB{n}/2);
    if and(d(1,n)~=0,~isnan(d(1,n)))     
        imgsT{n}(rNew{n}(d(1,n)).PixelIdxList)=255*ones(length(rNew{n}(d(1,n)).PixelIdxList),1); %figure,imshow(imgsT{n})    
    end
end

end

