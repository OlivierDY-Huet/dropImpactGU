function [ImgP]=getImgPinning(ImgS,rNew,d,pinTab)

ImgP=cell(height(pinTab),1);
for k=1:height(pinTab)
    ImgP{k}=uint8(zeros(size(ImgS)));
    if ~isempty(pinTab.PinnedDrops{k})
        for p=1:length(pinTab.PinnedDrops{k})
            ImgP{k}(rNew{pinTab.Frame{k}}(d(pinTab.PinnedDrops{k},pinTab.Frame{k})).PixelIdxList)=uint8(round(255/4));
            for pp=1:size(pinTab.Limits{k}{p},1)
                ImgP{k}(:,(pinTab.Limits{k}{p}(pp,1):pinTab.Limits{k}{p}(pp,2)))=uint8(round(ImgP{k}(:,(pinTab.Limits{k}{p}(pp,1):pinTab.Limits{k}{p}(pp,2)))*255));
            end
            for pp=1:size(pinTab.Limits{k}{p},1)
                if pp<size(pinTab.Limits{k}{p},1)
                    ImgP{k}(:,(pinTab.Limits{k}{p}(pp+1,1):pinTab.Limits{k}{p}(pp,2)))=uint8(round(ImgP{k}(:,(pinTab.Limits{k}{p}(pp+1,1):pinTab.Limits{k}{p}(pp,2)))*255/2));
                end
            end
        end
%         figure, imshow(ImgP{k})   
    end
end

end