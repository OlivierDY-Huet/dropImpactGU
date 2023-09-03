function [pinTab]=getPinnedDropLimits(imgS,pxListEdge,pinTab)

for k=1:height(pinTab)
    if ~isempty(pinTab.PinnedDrops{k})
        %Find the minimums
        pinTab.Limits{k}=cell(length(pinTab.PinnedDrops{k}));
        for i=1:length(pinTab.PinnedDrops{k})
            imgEdge=false(size(imgS));
            imgEdge(pxListEdge{pinTab.PinnedDrops{k}(i),pinTab.Frame{k}})=true;
            imgTop=false(size(imgS));
            [row,col]=find(imgEdge==1);
            idx=find(imgEdge==1);
            [colU,~,p]=unique(col);
            for j=1:length(colU)
                idxCol=find(p==j);
                [~,idxMin]=min(row(idxCol));
                imgTop(idx(idxCol(idxMin)))=true;
            end
            [row,col]=find(imgTop==1);
            idx=find(imgTop==1);
            minL=[];
            minR=[];
            dirL=1;
            dirR=1;
            for j=1:length(col)-1
                if dirL==1
                    if row(j+1)<=row(j)
                        minL=[minL;j+1];
                    else
                        dirL=0;
                    end
                else
                    if row(j+1)<row(j)
                        minL=[minL;j+1];
                        dirL=1;
                    end
                end
                j2=length(col)+1-j;
                if dirR==1
                    if row(j2-1)<=row(j2)
                        minR=[minR;j2-1];
                    else
                        dirR=0;
                    end
                else
                    if row(j2-1)<row(j2)
                        minR=[minR;j2-1];
                        dirR=1;
                    end
                end
            end
            colMin=col(~ismember([1:length(col)],unique([minR;minL])));
            
            %Find the limits
            v=find(diff(colMin)>1);
            c=zeros(length(v),2);
            for p=1:length(v)
                if p==1
                    c(p,1)=colMin(1);
                else
                    c(p,1)=colMin(v(p-1)+1);
                end
                if p==length(v)
                    c(p,2)=colMin(length(colMin));
                else
                    c(p,2)=colMin(v(p+1));
                end
            end
            pinTab.Limits{k}{i}=c;
        end
    end
end

end
