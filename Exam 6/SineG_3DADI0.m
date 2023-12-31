function error = SineG_3DADI0(xa,xb,ya,yb,za,zb,ta,tb,m1,m2,m3,n,alpha,beta,gamma,theta)
tic
format short e;
%% mesh
h1 = (xb-xa)/m1;
h2 = (yb-ya)/m2;
h3 = (zb-za)/m3;
dt = (tb-ta)/n;
x = xa:h1:xb; x = x';
y = ya:h2:yb; y = y';
z = za:h2:zb; z = z';
t = ta:dt:tb; t = t';
a = 1/12-alpha*theta*dt^2/h1^2; b = 10/12+2*alpha*theta*dt^2/h1^2;
c = alpha/(12*h1^2)+beta/(12*h2^2); d = -2*alpha/(12*h1^2)+10*beta/(12*h2^2);
e = 10*alpha/(12*h1^2)-2*beta/(12*h2^2);
f = 1/12-beta*theta*dt^2/h2^2; g = 10/12+2*beta*theta*dt^2/h2^2;
u = zeros(m1+1,m2+1,m3+1,n+1);
a1 = 1/12-alpha*dt^2/(2*h1^2); b1 = 10/12+2*alpha*dt^2/(2*h1^2);
f1 = 1/12-beta*dt^2/(2*h2^2); g1 = 10/12+2*beta*dt^2/(2*h2^2);
f2 = 1/(12^2)-beta*dt^2/(24*h2^2) -gamma*dt^2/(24*h3^2)+beta*gamma*dt^4/(4*h2^2*h3^2); 
g2 = 10/(12^2)-10*beta*dt^2/(24*h2^2) +gamma*dt^2/(12*h3^2)-beta*gamma*dt^4/(2*h2^2*h3^2); 
f3 = 10/(12^2)+beta*dt^2/(12*h2^2) -10*gamma*dt^2/(24*h3^2)-beta*gamma*dt^4/(2*h2^2*h3^2); 
g3 = 10/(12^2)+20*beta*dt^2/(24*h2^2) +20*gamma*dt^2/(24*h3^2)+beta*gamma*dt^4/(h2^2*h3^2); 
q1 = 1/12-gamma*dt^2/(2*h3^2); p1 = 10/12+2*gamma*dt^2/(2*h3^2);
q11 = 1/12-gamma*theta*dt^2/(h3^2); p11 = 10/12+2*gamma*theta*dt^2/(h3^2);

f21 = 1/(12^2)-beta*theta*dt^2/(12*h2^2) -gamma*theta*dt^2/(12*h3^2)+beta*gamma*theta^2*dt^4/(h2^2*h3^2); 
g21 = 10/(12^2)-10*beta*theta*dt^2/(12*h2^2) +gamma*theta*dt^2/(6*h3^2)-2*beta*gamma*theta^2*dt^4/(h2^2*h3^2); 
f31 = 10/(12^2)+beta*theta*dt^2/(6*h2^2) -10*gamma*theta*dt^2/(12*h3^2)-2*beta*gamma*theta^2*dt^4/(h2^2*h3^2); 
g31 = 10/(12^2)+20*beta*theta*dt^2/(12*h2^2) +20*gamma*theta*dt^2/(12*h3^2)+4*beta*gamma*theta^2*dt^4/(h2^2*h3^2); 

%% 
Rfun = @(x,y,z,t)  2*sin(exp(-t).*(1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z)))+...
   exp(-t).*(1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z))- alpha*pi^2*exp(-t).*(1-cos(pi*y)).*cos(pi*x).*(1-cos(pi*z))-...
    beta*pi^2*exp(-t).*(1-cos(pi*x)).*cos(pi*y).*(1-cos(pi*z))- gamma*pi^2*exp(-t).*(1-cos(pi*y)).*cos(pi*z).*(1-cos(pi*x));
varphi = @(x,y,z) (1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z));
psi = @(x,y,z) -(1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z));
xi =  @(x,y,z) 2;
psixx = @(x,y,z) -pi^2*cos(pi*x).*(1-cos(pi*y)).*(1-cos(pi*z));
psiyy = @(x,y,z) -pi^2*cos(pi*y).*(1-cos(pi*x)).*(1-cos(pi*z));
psizz = @(x,y,z) -pi^2*cos(pi*z).*(1-cos(pi*x)).*(1-cos(pi*y));
Rfunt = @(x,y,z)  -2*cos((1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z))).*(1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z))-...
   (1-cos(pi*x)).*(1-cos(pi*y)).*(1-cos(pi*z))+ pi^2*(alpha*(1-cos(pi*y)).*cos(pi*x).*(1-cos(pi*z))+...
    beta*(1-cos(pi*x)).*cos(pi*y).*(1-cos(pi*z))+gamma*(1-cos(pi*y)).*cos(pi*z).*(1-cos(pi*x)));

%% 
u(:,1,:,:) = 0; u(:,m2+1,:,:) = 0;
u(1,:,:,:) = 0; u(m1+1,:,:,:) = 0;
u(:,:,1,:) = 0; u(:,:,m3+1,:) = 0;
%% Operator matrix
e1 = ones(m1-1,1);e2 = ones(m2-1,1);e3 = ones(m3-1,1);
A1 = spdiags(1/12*e1,-1,m1-1,m1-1)+spdiags(5/6*e1,0,m1-1,m1-1)+spdiags(1/12*e1,1,m1-1,m1-1); % mathcal(A)x_{m1*m1}
A2 = spdiags(1/12*e2,-1,m2-1,m2-1)+spdiags(5/6*e2,0,m2-1,m2-1)+spdiags(1/12*e2,1,m2-1,m2-1); % mathcal(A)y_{m2*m2}
B1 = (spdiags(e1,-1,m1-1,m1-1)+spdiags(-2*e1,0,m1-1,m1-1)+spdiags(e1,1,m1-1,m1-1))/h1^2; % delta_x^2_{m1*m1}
B2 = (spdiags(e2,-1,m2-1,m2-1)+spdiags(-2*e2,0,m2-1,m2-1)+spdiags(e2,1,m2-1,m2-1))/h2^2; % delta_y^2_{m2*m2}
C1 = spdiags(a*e1,-1,m1-1,m1-1)+spdiags(b*e1,0,m1-1,m1-1)+spdiags(a*e1,1,m1-1,m1-1); %
C2 = spdiags(c*e1,-1,m1-1,m1-1)+spdiags(d*e1,0,m1-1,m1-1)+spdiags(c*e1,1,m1-1,m1-1); %
C3 = spdiags(e*e1,-1,m1-1,m1-1)+spdiags(-20*c*e1,0,m1-1,m1-1)+spdiags(e*e1,1,m1-1,m1-1); %
C4 = spdiags(f*e2,-1,m2-1,m2-1)+spdiags(g*e2,0,m2-1,m2-1)+spdiags(f*e2,1,m2-1,m2-1); %
C11 = spdiags(a1*e1,-1,m1-1,m1-1)+spdiags(b1*e1,0,m1-1,m1-1)+spdiags(a1*e1,1,m1-1,m1-1); %
C41 = spdiags(f1*e2,-1,m2-1,m2-1)+spdiags(g1*e2,0,m2-1,m2-1)+spdiags(f1*e2,1,m2-1,m2-1); %
C51 = spdiags(q1*e3,-1,m3-1,m3-1)+spdiags(p1*e3,0,m3-1,m3-1)+spdiags(q1*e3,1,m3-1,m3-1); %
C511 = spdiags(q11*e3,-1,m3-1,m3-1)+spdiags(p11*e3,0,m3-1,m3-1)+spdiags(q11*e3,1,m3-1,m3-1); 

%% k=1 _st level
uu = zeros(m1+1,m2+1,m3+1); 
uuu = zeros(m1+1,m2+1,m3+1);
w = zeros(m1+1,m2+1,m3+1);
ww = zeros(m1+1,m2+1,m3+1);
pp = zeros(m1+1,m2+1,m3+1); 
p = zeros(m1+1,m2+1,m3+1);
s1 = zeros(m1+1,m2+1,m3+1,n+1);
s2 = zeros(m1+1,m2+1,m3+1,n+1);
s3 = zeros(m1+1,m2+1,m3+1,n+1);
s4 = zeros(m1+1,m2+1,m3+1,n+1);

%% 
for i= 1:m1+1
    for j=1:m2+1
        for l=1:m3+1
        w(i,j,l)=xi(x(i),y(j),z(l));
        u(i,j,l,1) = (1-cos(pi*x(i)))*(1-cos(pi*y(j)))*(1-cos(pi*z(l)));
        U(i,j,l) = (1-cos(pi*x(i)))*(1-cos(pi*y(j)))*(1-cos(pi*z(l)))*exp(-t(n+1));
        ww(i,j,l)=varphi(x(i),y(j),z(l))+dt*psi(x(i),y(j),z(l))-(dt^3/3)*(alpha*psixx(x(i),y(j),z(l))+beta*psiyy(x(i),y(j),z(l))+gamma*psizz(x(i),y(j),z(l))-...
            xi(x(i),y(j),z(l))*cos(varphi(x(i),y(j),z(l)))*psi(x(i),y(j),z(l))+Rfunt(x(i),y(j),z(l)))-...
            (dt^2/2)*xi(x(i),y(j),z(l))*sin(varphi(x(i),y(j),z(l))+dt*psi(x(i),y(j),z(l)))+(dt^2/2)*Rfun(x(i),y(j),z(l),t(1));
        end
    end
end

%% 1_st
ww(1:m1+1,2:m2,2:m3)=1/(12^2)*(ww(1:m1+1,3:m2+1,3:m3+1)+10*ww(1:m1+1,2:m2,3:m3+1)+ww(1:m1+1,1:m2-1,3:m3+1)+...
    10*ww(1:m1+1,3:m2+1,2:m3)+10^2*ww(1:m1+1,2:m2,2:m3)+10*ww(1:m1+1,1:m2-1,2:m3)+...
    ww(1:m1+1,3:m2+1,1:m3-1)+10*ww(1:m1+1,2:m2,1:m3-1)+ww(1:m1+1,1:m2-1,1:m3-1));
pp(1,2:m2,2:m3) = f2*u(1,3:m2+1,3:m3+1,2)+g2*u(1,3:m2+1,2:m3,2)+f2*u(1,3:m2+1,1:m3-1,2)+...
     f3*u(1,2:m2,3:m3+1,2)+g3*u(1,2:m2,2:m3,2)+f3*u(1,2:m2,1:m3-1,2)+...
      f2*u(1,1:m2-1,3:m3+1,2)+g2*u(1,1:m2-1,2:m3,2)+f2*u(1,1:m2-1,1:m3-1,2);%u^**
pp(m1+1,2:m2,2:m3) = f2*u(m1+1,3:m2+1,3:m3+1,2)+g2*u(m1+1,3:m2+1,2:m3,2)+f2*u(m1+1,3:m2+1,1:m3-1,2)+...
     f3*u(m1+1,2:m2,3:m3+1,2)+g3*u(m1+1,2:m2,2:m3,2)+f3*u(m1+1,2:m2,1:m3-1,2)+...
      f2*u(m1+1,1:m2-1,3:m3+1,2)+g2*u(m1+1,1:m2-1,2:m3,2)+f2*u(m1+1,1:m2-1,1:m3-1,2);%u^**
 
  for l = 2:m3
      for j = 2:m2
          HH = zeros(m1-1,1);
          HH(1) = -a1*pp(1,j,l)+ww(1,j,l)/12;       
          HH(m1-1) = -a1*pp(m1+1,j,l)+ww(m1+1,j,l)/12;
         
          pp(2:m1,j,l) = C11\(A1*ww(2:m1,j,l)+HH);
      end
  end

p(1,2:m2,2:m3) = q1*u(1,2:m2,3:m3+1,2)+p1*u(1,2:m2,2:m3,2)+q1*u(1,2:m2,1:m3-1,2);%u^*
p(m1+1,2:m2,2:m3) = q1*u(m1+1,2:m2,3:m3+1,2)+p1*u(m1+1,2:m2,2:m3,2)+q1*u(m1+1,2:m2,1:m3-1,2);%u^*
  
  for l = 2:m3
      for i = 2:m1
          G = zeros(1,m2-1);
          G(1) = -f1*p(i,1,l);
          G(m2-1) =  -f1*p(i,m2+1,l);
    
          p(i,2:m2,l) =  C41\(pp(i,2:m2,l)+G)';
      end
  end
 
  for j = 2:m2
      for i = 2:m1
          GG = zeros(m3-1,1);
          GG(1) = -q1*u(i,j,1,2);
          GG(m3-1) =  -q1*u(i,j,m3+1,2);
          
          o(1:m3-1,1)=p(i,j,2:m3);         
          u(i,j,2:m3,2) =  C51\(o+GG);
      end
  end

%% k>1
for k = 2:n
    uu(1,2:m2,2:m3) = (f21*(u(1,3:m2+1,3:m3+1,k+1)-2*u(1,3:m2+1,3:m3+1,k)+u(1,3:m2+1,3:m3+1,k-1))+...
    +g21*(u(1,3:m2+1,2:m3,k+1)-2*u(1,3:m2+1,2:m3,k)+u(1,3:m2+1,2:m3,k-1))+f21*(u(1,3:m2+1,1:m3-1,k+1)-2*u(1,3:m2+1,1:m3-1,k)+u(1,3:m2+1,1:m3-1,k-1))+...
     f31*(u(1,2:m2,3:m3+1,k+1)-2*u(1,2:m2,3:m3+1,k)+u(1,2:m2,3:m3+1,k-1))+g31*(u(1,2:m2,2:m3,k+1)-2*u(1,2:m2,2:m3,k)+u(1,2:m2,2:m3,k-1))+...
    +f31*(u(1,2:m2,1:m3-1,k+1)-2*u(1,2:m2,1:m3-1,k)+u(1,2:m2,1:m3-1,k-1))+f21*(u(1,1:m2-1,3:m3+1,k+1)-2*u(1,1:m2-1,3:m3+1,k)+u(1,1:m2-1,3:m3+1,k-1))+...
    +g21*(u(1,1:m2-1,2:m3,k+1)-2*u(1,1:m2-1,2:m3,k)+u(1,1:m2-1,2:m3,k-1))+f21*(u(1,1:m2-1,1:m3-1,k+1)-2*u(1,1:m2-1,1:m3-1,k)+u(1,1:m2-1,1:m3-1,k-1)))/(dt^2); %u^*2  

    uu(m1+1,2:m2,2:m3) = (f21*(u(m1+1,3:m2+1,3:m3+1,k+1)-2*u(m1+1,3:m2+1,3:m3+1,k)+u(m1+1,3:m2+1,3:m3+1,k-1))+...
    +g21*(u(m1+1,3:m2+1,2:m3,k+1)-2*u(m1+1,3:m2+1,2:m3,k)+u(m1+1,3:m2+1,2:m3,k-1))+f21*(u(m1+1,3:m2+1,1:m3-1,k+1)-2*u(m1+1,3:m2+1,1:m3-1,k)+u(m1+1,3:m2+1,1:m3-1,k-1))+...
     f31*(u(m1+1,2:m2,3:m3+1,k+1)-2*u(m1+1,2:m2,3:m3+1,k)+u(m1+1,2:m2,3:m3+1,k-1))+g31*(u(m1+1,2:m2,2:m3,k+1)-2*u(m1+1,2:m2,2:m3,k)+u(m1+1,2:m2,2:m3,k-1))+...
    +f31*(u(m1+1,2:m2,1:m3-1,k+1)-2*u(m1+1,2:m2,1:m3-1,k)+u(m1+1,2:m2,1:m3-1,k-1))+f21*(u(m1+1,1:m2-1,3:m3+1,k+1)-2*u(m1+1,1:m2-1,3:m3+1,k)+u(m1+1,1:m2-1,3:m3+1,k-1))+...
    +g21*(u(m1+1,1:m2-1,2:m3,k+1)-2*u(m1+1,1:m2-1,2:m3,k)+u(m1+1,1:m2-1,2:m3,k-1))+f21*(u(m1+1,1:m2-1,1:m3-1,k+1)-2*u(m1+1,1:m2-1,1:m3-1,k)+u(m1+1,1:m2-1,1:m3-1,k-1)))/(dt^2);   
for l= 2:m3
    for j = 2:m2
        H = zeros(m1-1,1);
        s1(1:m1+1,j,l,k) = 1/(12^2)*((u(1:m1+1,j+1,l+1,k))+10*(u(1:m1+1,j,l+1,k))+(u(1:m1+1,j-1,l+1,k))+...
            10*(u(1:m1+1,j+1,l,k))+10^2*(u(1:m1+1,j,l,k))+10*(u(1:m1+1,j-1,l,k))+...
            (u(1:m1+1,j+1,l-1,k))+10*(u(1:m1+1,j,l-1,k))+(u(1:m1+1,j-1,l-1,k)));%A_YA_Zu
        s2(1:m1+1,j,l,k) = 1/(12*h2^2)*((u(1:m1+1,j+1,l+1,k))+10*(u(1:m1+1,j+1,l,k))+(u(1:m1+1,j+1,l-1,k))...
            -2*((u(1:m1+1,j,l+1,k))+10*(u(1:m1+1,j,l,k))+(u(1:m1+1,j,l-1,k)))+...
            (u(1:m1+1,j-1,l+1,k))+10*(u(1:m1+1,j-1,l,k))+(u(1:m1+1,j-1,l-1,k)));%A_zdeta_y^2 u
        s3(1:m1+1,j,l,k) = 1/(12*h3^2)*((u(1:m1+1,j+1,l+1,k))+10*(u(1:m1+1,j,l+1,k))+(u(1:m1+1,j-1,l+1,k))...
            -2*((u(1:m1+1,j+1,l,k))+10*(u(1:m1+1,j,l,k))+(u(1:m1+1,j-1,l,k)))+...
            (u(1:m1+1,j+1,l-1,k))+10*(u(1:m1+1,j,l-1,k))+(u(1:m1+1,j-1,l-1,k)));%A_ydeta_z^2 u
        for i=1:m1+1
        s4(i,j,l,k)=-1/(12^2)*(xi(x(i),y(j+1),z(l+1))*sin(u(i,j+1,l+1,k))+10*xi(x(i),y(j),z(l+1))*sin(u(i,j,l+1,k))+xi(x(i),y(j-1),z(l+1))*sin(u(i,j-1,l+1,k))+...
            10*xi(x(i),y(j+1),z(l))*sin(u(i,j+1,l,k))+10^2*xi(x(i),y(j),z(l))*sin(u(i,j,l,k))+10*xi(x(i),y(j-1),z(l))*sin(u(i,j-1,l,k))+...
            xi(x(i),y(j+1),z(l-1))*sin(u(i,j+1,l-1,k))+10*xi(x(i),y(j),z(l-1))*sin(u(i,j,l-1,k))+xi(x(i),y(j-1),z(l-1))*sin(u(i,j-1,l-1,k)))+...
            1/(12^2)*(Rfun(x(i),y(j+1),z(l+1),t(k))+10*Rfun(x(i),y(j),z(l+1),t(k))+Rfun(x(i),y(j-1),z(l+1),t(k))+...
            10*Rfun(x(i),y(j+1),z(l),t(k))+10^2*Rfun(x(i),y(j),z(l),t(k))+10*Rfun(x(i),y(j-1),z(l),t(k))+...
            Rfun(x(i),y(j+1),z(l-1),t(k))+10*Rfun(x(i),y(j),z(l-1),t(k))+Rfun(x(i),y(j-1),z(l-1),t(k)));
        end
        H(1) = -a*uu(1,j,l)+alpha/(h1^2)* s1(1,j,l,k)+...
            +beta/(12)*(s2(1,j,l,k))+gamma/(12)*(s3(1,j,l,k))+...
            1/(12)*s4(1,j,l,k);
        
        H(m1-1) =  -a*uu(m1+1,j,l)+alpha/(h1^2)* s1(m1+1,j,l,k)+...
            +beta/(12)*(s2(m1+1,j,l,k))+gamma/(12)*(s3(m1+1,j,l,k))+1/(12)*s4(m1+1,j,l,k);
        
        uu(2:m1,j,l) = C1\(alpha*B1*s1(2:m1,j,l,k)+beta*A1*s2(2:m1,j,l,k)+gamma*A1*s3(2:m1,j,l,k)+...
            A1*s4(2:m1,j,l,k)+H);
    end
end
    
p(1,2:m2,2:m3) = (q11*(u(1,2:m2,3:m3+1,k+1)-2*u(1,2:m2,3:m3+1,k)+u(1,2:m2,3:m3+1,k-1))+...
p11*(u(1,2:m2,2:m3,k+1)-2*u(1,2:m2,2:m3,k)+u(1,2:m2,2:m3,k-1))+q11*(u(1,2:m2,1:m3-1,k+1)-2*u(1,2:m2,1:m3-1,k)+u(1,2:m2,1:m3-1,k-1)))/(dt^2);%u^**2_0
p(m1+1,2:m2,2:m3) = (q11*(u(m1+1,2:m2,3:m3+1,k+1)-2*u(m1+1,2:m2,3:m3+1,k)+u(m1+1,2:m2,3:m3+1,k-1))+...
p11*(u(m1+1,2:m2,2:m3,k+1)-2*u(m1+1,2:m2,2:m3,k)+u(m1+1,2:m2,2:m3,k-1))+q11*(u(m1+1,2:m2,1:m3-1,k+1)-2*u(m1+1,2:m2,1:m3-1,k)+u(m1+1,2:m2,1:m3-1,k-1)))/(dt^2);%u^**2_0
  
  for l = 2:m3
      for i = 2:m1
          G = zeros(1,m2-1);
          G(1) = -f*p(i,1,l);
          G(m2-1) =  -f*p(i,m2+1,l);
    
          p(i,2:m2,l) =  C4\(uu(i,2:m2,l)+G)';
      end
  end
 
  for j = 2:m2
      for i = 2:m1
          GG = zeros(m3-1,1);
          GG(1) = -q11*(u(1,j,1,k+1)-2*u(1,j,1,k)+u(1,j,1,k-1))/(dt^2);
          GG(m3-1) = -q11*(u(m1+1,j,1,k+1)-2*u(m1+1,j,1,k)+u(m1+1,j,1,k-1))/(dt^2);
          
          o(1:m3-1,1)=p(i,j,2:m3);         
          uuu(i,j,2:m3) =  C511\(o+GG);
          u(i,j,2:m3,k+1) = dt^2*uuu(i,j,2:m3)+2*u(i,j,2:m3,k)-u(i,j,2:m3,k-1);
      end
  end
end

 %%error
error = max(max(max(abs(U(2:m1,2:m2,2:m3)-u(2:m1,2:m2,2:m3,n+1)))));