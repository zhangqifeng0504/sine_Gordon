clc;clear all;
m1 = 64;m2=64;n = 100;xa=-30;xb=10;ya=-21;yb=7;ta=0;alpha=1;beta=1;theta=3/4;
h1 = (xb-xa)/m1;
h2 = (yb-ya)/m2;
x = xa:h1:xb; x = x';
y = ya:h2:yb; y = y';

%% 
 u3 =SineG_2DADI3(xa,xb,ya,yb,ta,6,m1,m2,n,alpha,beta,theta);
 u3 = sin(u3'/2);
 contour(x,y,u3, 20, 'LineWidth', 0.8);
 xlabel  ({'$x$'},'FontUnits','points','interpreter','latex','FontSize',15,'FontName','Times')          
 ylabel  ({'$y$'},'FontUnits','points','interpreter','latex','FontSize',15,'FontName','Times')  
 title   ({'$\sin(u/2),t=6$'},'FontUnits','points','interpreter','latex','FontSize',15,'FontName','Times')
set(gca,'XTick',-30:10:10);set(gca,'YTick',-21:7:7);xlim([-30 10]);ylim([-21 7])

colormap(slanCM('rainbow'))