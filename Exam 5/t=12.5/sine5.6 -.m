clc;clear all;
m1 = 64;m2=64;n = 100;xa=-30;xb=10;ya=-30;yb=10;ta=0;alpha=1;beta=1;theta=2/3;
h1 = (xb-xa)/m1;
h2 = (yb-ya)/m2;
x = xa:h1:xb; x = x';
y = ya:h2:yb; y = y';

%%

 u2 =SineG_2DADI3(xa,xb,ya,yb,ta,12.5,m1,m2,n,alpha,beta,theta);
 u2 = sin(u2'/2);
 contour(x,y,u2, 20, 'LineWidth', 0.8);
 xlabel  ({'$x$'},'FontUnits','points','interpreter','latex','FontSize',15,'FontName','Times')        
 ylabel  ({'$y$'},'FontUnits','points','interpreter','latex','FontSize',15,'FontName','Times')    
 title   ({'$\sin(u/2),t=12.5$'},'FontUnits','points','interpreter','latex','FontSize',15,'FontName','Times')
set(gca,'XTick',-30:10:10);set(gca,'YTick',-30:10:10);xlim([-30 10]);ylim([-30 10])

colormap(slanCM('rainbow'))