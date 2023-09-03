function [pinTab]=getLastFramePinning(rNew,d,mainDrop,classTab,pinTab)

varCol=pinTab.Properties.VariableNames;
pinTab=array2table(cell(1,length(varCol)),'VariableNames',varCol);
pinTab.Frame{1}=length(rNew);
pinTab.PinnedDrops{1}=[];

idx=[rNew{length(rNew)}.dropID];
idx=idx([rNew{length(rNew)}.SurfContact]);
idx=intersect(idx,find(classTab.OnSurf==1));
if ~isempty(idx)
    for k=1:length(idx)
        f=find(d(idx(k),:)>0);
        f=f(f>mainDrop.Frame(1));
        cond=0;
        for n=1:length(f)
            if rNew{f(n)}(d(idx(k),f(n))).SurfContact
                cond=0;
                break
            else
                cond=1;
            end
        end
        if cond==1
            pinTab.PinnedDrops{1}=cat(1,pinTab.PinnedDrops{1},idx(k));
        end
    end
end

end