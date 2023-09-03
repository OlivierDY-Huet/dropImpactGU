function [pinTab]=getPinnedDropVolMeth(imgS,pxListEdge,pinTab)

for k=1:height(pinTab)
    if ~isempty(pinTab.PinnedDrops{k})
        for p=1:length(pinTab.PinnedDrops{k})
            imgBlack=false(size(imgS)); 
            imgEdge=imgBlack; 
            imgEdge(pxListEdge{pinTab.PinnedDrops{k}(p),pinTab.Frame{k}})=true; %figure,imshow(imgEdge)
            imgEdge=imgEdge.*cat(1,imgS(2:end,:),false(1,size(imgS,2))); % Delete drop-surface limit
            [rows,cols]=find(imgEdge==1);
            pinTab.volMethod{k}{p}=zeros(size(pinTab.Type{k}{p}));
            for pp=1:size(pinTab.Limits{k}{p},1)
                idx=and(cols>=pinTab.Limits{k}{p}(pp,1),cols<=pinTab.Limits{k}{p}(pp,2));
                xy0=cat(2,cols(idx),rows(idx));
                limElBase=2;
                yT=min(xy0(:,limElBase));
                if max(xy0(:,2))-yT>2
                    pinTab.volMethod{k}{p}(pp)=1;
                else
                    pinTab.volMethod{k}{p}(pp)=2;
                end  
            end         
        end
    end
end

end

