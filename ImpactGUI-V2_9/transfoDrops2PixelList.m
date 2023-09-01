function [pxList]=transfoDrops2PixelList(d,rNew)

pxList=cell(size(d));
for n=1:size(d,2)
    if ~isempty(rNew{n})
        idx=find(isnan(cat(1,rNew{n}.dropID))==0);
        if numel(idx)>0
            for k=1:length(idx)
                pxList{rNew{n}(idx(k)).dropID,n}=rNew{n}(idx(k)).PixelIdxList; 
            end
        end
    end
end

end