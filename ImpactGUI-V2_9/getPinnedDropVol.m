function [pinTab]=getPinnedDropVol(D0,imgS,pxListEdge,pinTab)

Vol0=(1/6)*pi*D0^3;

for k=1:height(pinTab)
    if ~isempty(pinTab.PinnedDrops{k})
        for p=1:length(pinTab.PinnedDrops{k})
            imgBlack=false(size(imgS)); 
            imgEdge=imgBlack; 
            imgEdge(pxListEdge{pinTab.PinnedDrops{k}(p),pinTab.Frame{k}})=true; %figure,imshow(imgEdge)
            [rows,~]=find(imgEdge==1);
            rowMax=max(rows); %Take it here and not latter in case of irregular surfaces
            imgEdge=imgEdge.*cat(1,imgS(2:end,:),false(1,size(imgS,2))); % Delete drop-surface limit
            [rows,cols]=find(imgEdge==1);
            pinTab.CalculatedShape{k}{p}=cell(size(pinTab.Type{k}{p}));
            pinTab.RelVol{k}{p}=zeros(size(pinTab.Type{k}{p}));
            for pp=1:size(pinTab.Limits{k}{p},1)             
                idx=and(cols>=pinTab.Limits{k}{p}(pp,1),cols<=pinTab.Limits{k}{p}(pp,2));
                [VolM,fitEdge,Vol]=fitEllipse(pinTab.volMethod{k}{p}(pp),cat(2,cols(idx),rows(idx)),rowMax,imgBlack);
                pinTab.volMethod{k}{p}(pp)=VolM;
                pinTab.CalculatedShape{k}{p}{pp}=(fitEdge(:,1)-1)*size(imgS,1)+fitEdge(:,2);
                pinTab.RelVol{k}{p}(pp)=Vol/Vol0;     
            end         
        end
    end
end

end


%--------------------------------------------------------------------------

function [volM,xyEl,vol]=fitEllipse(volM,xy0,yB,imgBlack)

limElBase=2;
yT=min(xy0(:,limElBase));

if and(max(xy0(:,2))-yT>2,volM==1) %Check if enough information for fitting a ellipse
    %Build the ellipse base
    xy=xy0(xy0(:,2)-yT<=limElBase,:);
    sideOn=[1,1];
    [sideOn]=checkPxSide(xy,sideOn);
    shape.centre=[NaN,NaN]; %[x,y]
    shape.radius=[NaN,NaN]; %[a,b] Ellipse: (x^2/a^2)+(y^2/b^2)=1
    [shape]=getCircle(xy,imgBlack,shape); %Initiallisation with a circle
    [shape]=getEllipse(xy,shape);
    
    %Find the ellipse parameters
    for y=yT+limElBase+1:yB
        
        xy2add=xy0(xy0(:,2)==y,:);
        xy2addSub=cell(1,2);
        if sum(sideOn)==2
            idxSep=find(diff(xy2add(:,1))>1);
            if ~isempty(idxSep)
                xy2addSub{1}=xy2add(1:idxSep(1),:);
                xy2addSub{2}=xy2add(idxSep(end)+1:end,:);
            end
        else
            if sideOn(1)==1
                xy2addSub{1}=xy2add(xy2add(:,1)<shape.radius(1),:);
            else
                xy2addSub{2}=xy2add(xy2add(:,1)>shape.radius(1),:);
            end
        end
        for s=find(sideOn==1)
            if isempty(xy2addSub{s})
                sideOn(s)=0;
            else
                %calculate if part of ellipse
                [YN]=checkBelongToEllipse(xy2addSub{s}(:,1),y,shape);
                if YN
                    xy=cat(1,xy,xy2addSub{s});
                else
                    sideOn(s)=0;
                end
            end
            
        end

        if sum(sideOn)==0
            break
        end
        [shape]=getEllipse(xy,shape);
    end
    
    %Create shape     
    [X,Y]=meshgrid(1:size(imgBlack,2),1:size(imgBlack,1));  
    fillEll=and((((X-shape.centre(1)).^2)/((shape.radius(1)-0.5)^2)+((Y-shape.centre(2)).^2)/((shape.radius(2)-0.5)^2))>1,...
        (((X-shape.centre(1)).^2)/((shape.radius(1)+0.5)^2)+((Y-shape.centre(2)).^2)/((shape.radius(2)+0.5)^2))<1); %figure, imshow(fillEll)
    [yFill,xFill]=find(fillEll==1);
    xyEl=cat(2,xFill(yFill<=yB),yFill(yFill<=yB));
    
    %Calculate volume
    vol=pi*((shape.radius(1)+0.5)^2)*((yB-yT+1)^2)*(3*(shape.radius(2)+0.5)-(yB-yT+1))/(3*((shape.radius(2)+0.5)^2));
       
else %Small info
    volM=2;
    y=yT;
    xyEl=xy0(xy0(:,2)==y,:);
    xMin=min(xy0(xy0(:,2)==y,1));
    xMax=max(xy0(xy0(:,2)==y,1));
    vol=pi*(xMax-xMin+1)^2;
    for y=yT+1:yB
        xLeft=min(xy0(xy0(:,2)==y,1));
        xRight=max(xy0(xy0(:,2)==y,1));
        if ~isempty(xLeft)
            xMin=min(xLeft,xMin);
            xMax=max(xRight,xMax);
        end
        vol=vol+pi*(xMax-xMin+1)^2;
        xyEl=cat(1,xyEl,[xMin,y],[xMax,y]);
    end  
end

% A=imgBlack;
% B=imgBlack;
% A((xy0(:,1)-1)*size(imgBlack,1)+xy0(:,2))=true;
% B((xyEl(:,1)-1)*size(imgBlack,1)+xyEl(:,2))=true;
% figure,imshow(imfuse(A,B))

end

function [sideOn]=checkPxSide(xyEl,sideOn)
xMax=xyEl(xyEl(:,2)==max(xyEl(:,2)),1);
xUp=xyEl(xyEl(:,2)==max(xyEl(:,2))-1,1);
if isempty(xMax)
    sideOn=[0,0];
else
    idxSep=find(diff(xMax(:,1))>1);
    if isempty(idxSep)
        if ~isempty(intersect(xMax,xUp))
            sideOn=1*sideOn;
        else
            sideOn=0*sideOn;
        end
    else
        if ~isempty(intersect(xMax(1:idxSep(1)),xUp))
            sideOn(1)=1*sideOn(1);
        else
            sideOn(1)=0;
        end
        if ~isempty(intersect(xMax(idxSep(end)+1:end),xUp))
            sideOn(2)=1*sideOn(2);
        else
            sideOn(2)=0;
        end
    end
end
end

function [shape]=getCircle(xyEl,img2fit,shape)

img2fit((xyEl(:,1)-1)*size(img2fit,1)+xyEl(:,2))=true; %figure,imshow(img2fit)
boxInfo=imOrientedBox(img2fit); %[centre box x,centre box y, major length, minor length, angle:(0)-(+180)]
if boxInfo(5)>90
    boxInfo(5)=boxInfo(5)-180; % angle: (0)-(+180) -> (-90)-(+90) -> sin:-1 to +1 and cos 0 to +1
end
% Theoric Radius (Intersecting chords theorem)
W=boxInfo(3);
H=boxInfo(4);
if H<W/2
    shape.radius(1)=((W^2)/(8*H))+(H/2);
else
    shape.radius(1)=W/2;
end
shape.radius(2)=shape.radius(1);

% Theoric Centre
shape.centre(1)=boxInfo(1)-(shape.radius(1)-boxInfo(4)/2)*sind(boxInfo(5));
shape.centre(2)=boxInfo(2)+(shape.radius(1)-boxInfo(4)/2)*cosd(boxInfo(5));


end

function [shape]=getEllipse(xyEl,shape)

% Radius and centre
func=@(E) distEllipse(E,xyEl);
res=fminsearch(func,[shape.centre,shape.radius]);
shape.centre=res(1:2);
shape.radius=res(3:4);

end


%Distance Ellipse
function [F]=distEllipse(E,PxList) %E=[c,r]
dist=zeros(size(PxList,1),3);
dist(:,1)=sqrt(((PxList(:,1)-E(1)).^2)+((PxList(:,2)-E(2)).^2)); %Distance Centre ellipse - Pixel
gamma=atand(abs(PxList(:,2)-E(2))./abs(PxList(:,1)-E(1)));
dist(:,2)=sqrt((E(3)*cosd(gamma)).^2+(E(4)*sind(gamma)).^2); %Distance theoric ellipse
dist(:,3)=(dist(:,1)-dist(:,2)); %Diff between two distances
F = sum(dist(:,3).^2);
end

%Check part of ellipse
function [YN]=checkBelongToEllipse(x,y,shape)
YN=false;
x_cross=shape.radius(1)*sqrt(1-((y-shape.centre(2))/shape.radius(2))^2)+shape.centre(1);
if isreal(x_cross)
    x_cross=x_cross-shape.centre(1);
    x=abs(x-shape.centre(1));
    e=0.5;
    if and(x_cross>min(x)-e,x_cross<max(x)+e)
        YN=true;
    end
end
end

%==========================================================================
%Imported function
function [rect,labels] = imOrientedBox(img, varargin)
%IMORIENTEDBOX Minimum-area oriented bounding box of particles in image
%
%   OBB = imOrientedBox(IMG);
%   Computes the minimum area oriented bounding box of labels in image IMG.
%   IMG is either a binary or a label image. The result OBB is a N-by-5
%   array, containing the center, the length, the width, and the
%   orientation of the bounding box of each particle in image.
%
%   The orientation is given in degrees, in the direction of the greatest
%   box axis.
%
%   OBB = imOrientedBox(IMG, NDIRS);
%   OBB = imOrientedBox(IMG, DIRSET);
%   Specifies either the number of directions to use for computing boxes
%   (default is 180 corresponding to one direction by degree), or the set
%   of directions (in degrees). 
%
%   OBB = imOrientedBox(..., SPACING);
%   OBB = imOrientedBox(..., SPACING, ORIGIN);
%   Specifies the spatial calibration of image. Both SPACING and ORIGIN are
%   1-by-2 row vectors. SPACING = [SX SY] contains the size of a pixel.
%   ORIGIN = [OX OY] contains the center position of the top-left pixel of
%   image. 
%   If no calibration is specified, spacing = [1 1] and origin = [1 1] are
%   used. If only the sapcing is specified, the origin is set to [0 0].
%
%   OBB = imOrientedBox(..., PNAME, PVALUE);
%   Specify optional arguments as parameter pair-values. Available names
%   are:
%   * 'spacing' the sapcing bewteen pixels
%   * 'origin'  the position of the first pixel
%   * 'angles'  the array of angles used for computation
%   * 'labels'  restrict the computation to the set of specified labels,
%           given as a N-by-1 array
%
%   Example
%   % Compute and display the oriented box of several particles
%     img = imread('rice.png');
%     img2 = img - imopen(img, ones(30, 30));
%     lbl = bwlabel(img2 > 50, 4);
%     boxes = imOrientedBox(lbl);
%     imshow(img); hold on;
%     drawOrientedBox(boxes, 'linewidth', 2, 'color', 'g');
%
%   See also
%   imFeretDiameter, imInertiaEllipse, imMaxFeretDiameter
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-02-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.
%   HISTORY
%   2011-03-30 use degrees for angles
%   2014-06-17 add psb to specify labels
% ------
% Extract number of orientations
theta = 180;
if ~isempty(varargin) && ~ischar(varargin{1})
    var1 = varargin{1};
    if isscalar(var1)
        % Number of directions given as scalar
        theta = var1;
        varargin(1) = [];
        
    elseif ndims(var1) == 2 && sum(size(var1) ~= [1 2]) ~= 0 %#ok<ISMAT>
        % direction set given as vector
        theta = var1;
        varargin(1) = [];
    end
end
% ------
% Extract spatial calibration
% default values
spacing = [1 1];
origin  = [1 1];
calib   = false;
% extract spacing (for backward compatibility)
if ~isempty(varargin) && ~ischar(varargin{1})
    spacing = varargin{1};
    varargin(1) = [];
    calib = true;
    origin = [0 0];
end
% extract origin (for backward compatibility)
if ~isempty(varargin) && ~ischar(varargin{1})
    origin = varargin{1};
end
labels  = [];
while length(varargin) > 1 && ischar(varargin{1})
    paramName = varargin{1};
    switch lower(paramName)
        case 'angles'
            theta = varargin{2};
        case 'spacing'
            spacing = varargin{2};
        case 'origin'
            origin = varargin{2};
        case 'labels'
            labels = varargin{2};
        otherwise
            error(['Can not handle param name: ' paramName]);
    end
    
    varargin(1:2) = [];
end
% ------
% Initialisations
% if theta is scalar, create an array of directions (in degrees)
if isscalar(theta)
    theta = linspace(0, 180, theta+1);
    theta = theta(1:end-1);
end
nTheta = length(theta);
% extract the set of labels is necessary, without the background
if isempty(labels)
    labels = imFindLabels(img);
end
nLabels = length(labels);
% allocate memory for result
rect = zeros(nLabels, 5);
% ------
% Iterate over labels
for i = 1:nLabels
    % extract points of the current particle
    [y, x] = find(img==labels(i));
    if isempty(x)
        continue;
    end
    
    % transform to physical space if needed
    if calib
        x = (x-1) * spacing(1) + origin(1);
        y = (y-1) * spacing(2) + origin(2);
    end
    
    % keep only points of the convex hull
    try
        inds = convhull(x, y);
        x = x(inds);
        y = y(inds);
    catch ME %#ok<NASGU>
        % an exception can occur if points are colinear.
        % in this case we transform all points
    end
    % compute convex hull centroid, that corresponds to approximate
    % location of rectangle center
    xc = mean(x);
    yc = mean(y);
    
    % recenter points (should be better for numerical accuracy)
    x = x - xc;
    y = y - yc;
    % allocate memory for result of Feret Diameter computation
    fd = zeros(1, nTheta);
    % iterate over orientations
    for t = 1:nTheta
        % convert angle to radians, and change sign (to make transformed
        % points aligned along x-axis)
        theta2 = -theta(t) * pi / 180;
        % compute only transformed x-coordinate
        x2  = x * cos(theta2) - y * sin(theta2);
        % compute diameter for extreme coordinates
        xmin    = min(x2);
        xmax    = max(x2);
        % store result (add 1 pixel to consider pixel width)
        dl      = spacing(1) * abs(cos(theta2)) + spacing(2) * abs(sin(theta2));
        fd(t)   = xmax - xmin + dl;
    end
    % compute area of enclosing rectangles with various orientations
    feretArea = fd(:, 1:end/2) .* fd(:, end/2+1:end);
    
    % find the orientation that produces to minimum area rectangle
    [minArea, indMinArea] = min(feretArea, [], 2); %#ok<ASGLU>
    % convert index to angle (still in degrees)
    indMin90 = indMinArea + nTheta/2;
    if fd(indMinArea) < fd(indMin90)
        thetaMax = theta(indMin90);
    else
        thetaMax = theta(indMinArea);
    end
    % pre-compute trigonometric functions
    cot = cosd(thetaMax);
    sit = sind(thetaMax);
    
    % elongation in direction of rectangle length
    x2  =   x * cot + y * sit;
    y2  = - x * sit + y * cot;
    % compute extension along main directions
    xmin = min(x2);    xmax = max(x2);
    ymin = min(y2);    ymax = max(y2);
    % position of the center with respect to the centroid compute before
    dl = (xmax + xmin) / 2;
    dw = (ymax + ymin) / 2;
    % change  coordinate from rectangle to user-space
    dx  = dl * cot - dw * sit;
    dy  = dl * sit + dw * cot;
    % coordinates of rectangle center
    xc2 = xc + dx;
    yc2 = yc + dy;
    
    dsx = spacing(1) * abs(cot) + spacing(2) * abs(sit);
    dsy = spacing(1) * abs(sit) + spacing(2) * abs(cot);
        
    % size of the rectangle
    rectLength  = xmax - xmin + dsx;
    rectWidth   = ymax - ymin + dsy;
    % concatenate rectangle data
    rect(i,:) = [xc2 yc2 rectLength rectWidth thetaMax];
end
end

function labels = imFindLabels(img)
%IMFINDLABELS  Find unique labels in a label image
%
%   LABELS = imFindLabels(IMG)
%   Finds the unique labels in the label image IMG. The result can be
%   obtained using the unique function, but a special processing is added
%   to avoid using too much memory.
%
%   Example
%   imFindLabels
%
%   See also
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-07-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.
if islogical(img)
    labels = 1;
    return;
end
if isfloat(img)
    labels = unique(img(:));
    labels(labels==0) = [];
    return;
end
maxLabel = double(max(img(:)));
labels = zeros(maxLabel, 1);
nLabels = 0;
for i = 1:maxLabel
    if any(img(:) == i)
        nLabels = nLabels + 1;
        labels(nLabels) = i;
    end
end
labels = labels(1:nLabels);
end