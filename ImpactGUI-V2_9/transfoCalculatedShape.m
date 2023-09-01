function [pxList]=transfoCalculatedShape(pinTab)

pxList=cell(3,height(pinTab));
for k=1:height(pinTab)
    if ~isempty(pinTab.PinnedDrops{k})
        for p=1:length(pinTab.PinnedDrops{k})    
            for pp=1:size(pinTab.Limits{k}{p},1)
              pxList{pinTab.Type{k}{p}(pp),k}=cat(1,pxList{pinTab.Type{k}{p}(pp),k},pinTab.CalculatedShape{k}{p}{pp});
            end
        end   
    end
end

end