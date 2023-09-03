function [imgsRGB]=drawOnRGB(imgsRGB,type,posi,colorLine,thickness,dn) % Draw a line
%imgsRGB: image RGB
%posi: position of the line extremities [x1,y1;...;xn,yn]
%colorLine: color RGB

% Type: Point/Line/Box
T=0;
switch type
    case 'Point'
        T=1;
    case 'Box'
        T=2;
    case 'Line'
        T=3;
end

% Initialisation
pix2color=cell(length(posi),1);
colorVal=cell(length(posi),1);
s=size(imgsRGB{1});
[X,Y]=meshgrid(1:s(2),1:s(1));
imgBW0=false(s(1),s(2));

% Information into px 
for n=1:length(posi)
    
    imgBW=imgBW0;
    
    % Create a binary image and add seperate info
    [posi2]=splitArray(posi{n}); %Split if NaN
    
    for c=1:size(posi2,1)
        switch T
            case 1
                for k=1:size(posi2{c},1)      
                    [imgBW]=addPoint(imgBW,X,Y,posi2{c}(k,:),thickness);
                end
            case 2
                posi2{c}(end+1,:)=posi2{c}(1,:); %Close the box
                for k=1:size(posi2{c},1)-1
                    [imgBW]=addLine(imgBW,X,Y,posi2{c}(k,:),posi2{c}(k+1,:),thickness);
                end
            case 3 
                if size(posi2{c},1)>1
                    for k=1:size(posi2{c},1)-1
%                         celldisp(posi2)

                        [imgBW]=addLine(imgBW,X,Y,posi2{c}(k,:),posi2{c}(k+1,:),thickness);
                    end
                end
        end
    end
    
    % Merge BW info
    rp=regionprops('table',imgBW,'PixelIdxList');
    if size(rp,1)>1
        for r=size(rp,1):-1:2
            rp.PixelIdxList{1,1}=cat(1,rp.PixelIdxList{1,1},rp.PixelIdxList{r,1});
            rp(r,:)=[];
        end
    end
    
    % BW into RGB
    if ~isempty(rp)
        pxList=rp.PixelIdxList{1,1};
        h=length(pxList);
        pix2color{n}=cat(1,pxList,pxList+s(1)*s(2),pxList+2*s(1)*s(2));
        colorVal{n}=uint8(reshape(colorLine.*ones(h,3),h*3,1));
    end
    
end

% Fuse info between images if necessary
if T==3
    for n=length(posi):-1:1
        minF=max(1,n-dn);
        pix2color{n}=cat(1,pix2color{minF:n});
        colorVal{n}=cat(1,colorVal{minF:n});
    end
end

% Multiple the case if necessary
if length(posi)<size(imgsRGB,1)
    pix2color=repmat(pix2color,size(imgsRGB));
    colorVal=repmat(colorVal,size(imgsRGB));
end

% Draw on the RGB images
for n=1:length(imgsRGB)
    imgsRGB{n}(pix2color{n})=colorVal{n};
end

% 
% 'test'
% figure, imshow(imgsRGB{3})


end

function [BW]=addPoint(BW,X,Y,pt,thickness)

Cond=(sqrt((X-pt(1)).^2+(Y-pt(2)).^2)<(sqrt(2)*thickness)); % Short distance from the line

BW=or(BW,Cond);
end

function [BW]=addLine(BW,X,Y,pt1,pt2,thickness)
Cond=cell(3,1);

Cond{1}=and(X<=max([pt1(1),pt2(1)]),X>=min([pt1(1),pt2(1)])); % Inside x limite
Cond{2}=and(Y<=max([pt1(2),pt2(2)]),Y>=min([pt1(2),pt2(2)])); % Inside y limite
Cond{3}=(abs((pt2(1)-pt1(1))*(Y-pt1(2))-(pt2(2)-pt1(2))*(X-pt1(1)))/sqrt((pt2(2)-pt1(2))^2+(pt2(1)-pt1(1))^2))<(sqrt(2)*thickness/2); % Short distance from the line

BW=or(BW,and(and(Cond{1},Cond{2}),Cond{3}));
end

function [C]=splitArray(M)

index=find(~isnan(M(:,1)));
idx=find(diff(index)~=1);
if ~isempty(idx)
A=[idx(1);diff(idx);numel(index)-idx(end)];
C=mat2cell(M(~isnan(M(:,1)),:),A,size(M,2));
else
    C{1}=M;
end

end