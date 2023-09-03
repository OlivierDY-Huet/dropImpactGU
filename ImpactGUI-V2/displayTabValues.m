function []=displayTabValues(T,xCol,xName,y1Col,y1Name,y2Col,y2Name)

varNames=T.Properties.VariableNames;
A=table2array(T);
s=size(A);

figure,
%First y axis
if ~(y2Col(1)==0)
    yyaxis left
end
for j=y1Col
    plot(A(:,xCol),A(:,j)),hold on
end
legCol=y1Col;
ylabel(y1Name)

%Second y axis
if ~(y2Col(1)==0)
    yyaxis right
    for j=y2Col
        plot(A(:,xCol),A(:,j)),hold on
    end
    legCol=[legCol,y2Col];
    ylabel(y2Name)
end

% x axis and legend
xlabel(xName)
legend(varNames(legCol),'Location','south')
end