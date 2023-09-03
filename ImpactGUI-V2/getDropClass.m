function [dropsClass]=getDropClass(rNew2,d,obsTab,FrameDmax,dropsClass)

varCol=dropsClass.Properties.VariableNames;
dropsClass=array2table(false(size(d,1),length(varCol)),'VariableNames',varCol);

edgeLim=[rNew2{FrameDmax(2)}(d(1,FrameDmax(2))).BoundingBox(1),rNew2{FrameDmax(2)}(d(1,FrameDmax(2))).BoundingBox(1)+rNew2{FrameDmax(2)}(d(1,FrameDmax(2))).BoundingBox(3)];
centLim=[rNew2{obsTab.Frame(1)-1}(d(1,obsTab.Frame(1)-1)).BoundingBox(1),rNew2{obsTab.Frame(1)-1}(d(1,obsTab.Frame(1)-1)).BoundingBox(1)+rNew2{obsTab.Frame(1)-1}(d(1,obsTab.Frame(1)-1)).BoundingBox(3)]...
    +[+1,-1].*(rNew2{obsTab.Frame(1)-1}(d(1,obsTab.Frame(1)-1)).BoundingBox(3)/4);


for m=1:size(d,1)
    firstF=find(d(m,:)>0,1,'first');
    if m==1
        cond=1;
        for n=firstF:find(d(m,:)>0,1,'last')
            if rNew2{n}(d(1,n)).SurfContact==0
                cond=0;
                break
            end
        end
        if cond==1
            dropsClass.OnSurf(m)=true;
            dropsClass.Upwards(m)=false;
        else
            dropsClass.OnSurf(m)=false;
            dropsClass.Upwards(m)=true;
        end
    else
        if firstF<FrameDmax(2) %Satellite?
            if or(rNew2{firstF}(d(m,firstF)).Centroid(1)<rNew2{firstF-1}(d(1,firstF-1)).BoundingBox(1),...
                    rNew2{firstF}(d(m,firstF)).Centroid(1)>rNew2{firstF-1}(d(1,firstF-1)).BoundingBox(1)+rNew2{firstF-1}(d(1,firstF-1)).BoundingBox(3))
                dropsClass.Sattelite(m)=true;
            end
        else
            if rNew2{firstF}(d(m,firstF)).SurfContact==true %Created on the surface
                dropsClass.OnSurf(m)=true;
            else
                if and(rNew2{firstF}(d(m,firstF)).Centroid(1)>edgeLim(1),rNew2{firstF}(d(m,firstF)).Centroid(1)<edgeLim(2))
                    if and(rNew2{firstF}(d(m,firstF)).Centroid(1)>centLim(1),rNew2{firstF}(d(m,firstF)).Centroid(1)<centLim(2))
                        dropsClass.Upwards(m)=true;
                    else
                        dropsClass.OnSurf(m)=true;
                    end
                end
            end
        end
    end
end

dropsClass.Ignore(sum(table2array(dropsClass),2)==0)=true;

% for m=1:size(d,1)
%     idxF=find(d(m,:)>0);
%     if idxF(end)==size(d,2)
%     dropsClass.pinned(m)=true;
%     for n=length(idxF):-1:1        
%         dropsClass.pinned(m)=and(dropsClass.pinned(m),rNew2{idxF(n)}(d(m,idxF(n))).SurfContact);
%         if dropsClass.pinned(m)==0
%             break
%         end
%     end
%     else
%         dropsClass.pinned(m)=false;
%     end
% end



end