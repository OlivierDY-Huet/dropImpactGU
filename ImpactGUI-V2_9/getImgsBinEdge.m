function [pxList]=getImgsBinEdge(ImgsB,ImgL,r,d)
%All the pixels are connected by a leaast one side (not the case using the fonction 'bwperim')

pxList=cell(size(d));
s=size(ImgsB{1});
imgBlack=false(s+2);

for n=1:length(ImgsB)
    %Find edge
    imgMask=imgBlack;
    for i= 0:2
        for j=0:2
            imgMask((1:s(1))+i,(1:s(2))+j)=or(imgMask((1:s(1))+i,(1:s(2))+j),~ImgsB{n});
        end
    end
    imgEdge=and(imgMask(2:s(1)+1,2:s(2)+1),ImgsB{n}); %figure,imshow(imfuse(ImgsB{n},imgEdge))
    %Create pixel list
    imgEdgeL=imgEdge.*ImgL{n};
    k=unique(imgEdgeL);
    k=k(k>0);
    if ~isempty(k)
        for t=1:length(k)
            pxList{r{n}(k(t)).dropID,n}=cat(1,pxList{r{n}(k(t)).dropID,n},find(imgEdgeL==k(t)));
        end
    end
end

end