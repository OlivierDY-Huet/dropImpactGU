function [pinTab]=getPinnedDropClass(rNew,d,mainDrop,betaMaxF,pinTab)

limitClass(1,:)=[rNew{betaMaxF}(d(1,betaMaxF)).BoundingBox(1),rNew{betaMaxF}(d(1,betaMaxF)).BoundingBox(1)+rNew{betaMaxF}(d(1,betaMaxF)).BoundingBox(3)]+0.5;
limitClass(2,:)=[rNew{mainDrop.Frame(1)-1}(d(1,mainDrop.Frame(1)-1)).BoundingBox(1),rNew{mainDrop.Frame(1)-1}(d(1,mainDrop.Frame(1)-1)).BoundingBox(1)+rNew{mainDrop.Frame(1)-1}(d(1,mainDrop.Frame(1)-1)).BoundingBox(3)]+0.5;
limitClass(3,:)=(limitClass(2,:)+mean(limitClass(2,:)))/2;

for k=1:height(pinTab)
    if ~isempty(pinTab.PinnedDrops{k})
        pinTab.Type{k}=cell(length(pinTab.PinnedDrops{k}),1);
        for p=1:length(pinTab.PinnedDrops{k})
            pinTab.Type{k}{p}=zeros(length(pinTab.Limits{k}{p}),1);
            creatF=find(d(pinTab.PinnedDrops{k},:)>0,1,'first');
            if creatF<mainDrop.Frame(1)
                creatF=mainDrop.Frame(1);
            end
            cond(1)=and(rNew{creatF}(d(pinTab.PinnedDrops{k},creatF)).BoundingBox(1)+0.5<=limitClass(1,2),...
                rNew{creatF}(d(pinTab.PinnedDrops{k},creatF)).BoundingBox(1)+0.5+rNew{creatF}(d(pinTab.PinnedDrops{k},creatF)).BoundingBox(3)>=limitClass(1,1));
            cond(2)=and(rNew{pinTab.Frame{k}}(d(pinTab.PinnedDrops{k},pinTab.Frame{k})).BoundingBox(1)+0.5<=limitClass(1,2),...
                rNew{pinTab.Frame{k}}(d(pinTab.PinnedDrops{k},pinTab.Frame{k})).BoundingBox(1)+0.5+rNew{pinTab.Frame{k}}(d(pinTab.PinnedDrops{k},pinTab.Frame{k})).BoundingBox(3)>=limitClass(1,1));
            if and(cond(1),cond(2)) %Check if drops are inside the Dmax zone
                pinTab.Type{k}{p}=2*ones(length(pinTab.Limits{k}{p}),1);
                if and(rNew{creatF}(d(pinTab.PinnedDrops{k},creatF)).Centroid(1)>=limitClass(2,1),rNew{creatF}(d(pinTab.PinnedDrops{k},creatF)).Centroid(1)<=limitClass(2,2))
                    idxSize=(diff(pinTab.Limits{k}{p},1,2)>=(diff(limitClass(2,:),1,2)/2)); % Central pinning conditions depend on the drop size 
                    condLarge=and(idxSize,and(pinTab.Limits{k}{p}(:,1)<=mean(limitClass(2,:)),pinTab.Limits{k}{p}(:,2)<=mean(limitClass(2,:))));
                    condSmall=and(~idxSize,and(pinTab.Limits{k}{p}(:,1)>=limitClass(3,1),pinTab.Limits{k}{p}(:,2)<=limitClass(3,2)));                    
                    pinTab.Type{k}{p}(or(condLarge,condSmall))=1;
                end
            else
                pinTab.Type{k}{p}=3*ones(length(pinTab.Limits{k}{p}),1);
            end
        end
    end
end

end
