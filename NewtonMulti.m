%Algoritmo de optimización búsqueda de Newton (multivariable).
%Fernando Aldana
%Septiembre 2025
%Ejemplo basado en la función (x-2)^2 en el intervalo [a,b]
%%
%Limpia y cierra
clc;
clear all;
close all;
% Variables
a=-2;
b=-2; %Rango
iteraciones=60; %Número de iteraciones
%%
%Declara las funciones como simbólicas
syms x; %Variable simbólica
syms y; %Variable simbólica
syms p; %variable simbólica
f=(x-2)^2+(y-3)^2; %Declara la función
fx=diff(f, x); %Primera derivada respecto a x
fy=diff(f, y); %Primera derivada respecto a y
gradiente=zeros(2,1); %almacena vector gradiente evaluado
fxx=diff(fx, x); %Segunda derivada respecto a x
fxy=diff(fx, y); %Segunda derivada respecto a y
fyx=diff(fy, x); %Segunda derivada respecto a x
fyy=diff(fy, y); %Segunda derivada respecto a y
hessiano=zeros(2,2); %Guarda el hessiano de la función evaluado
fprevio=subs(f,[x,y],[a,b]); %Evalua la función en el punto inicial
%%
%Proceso iterativo
for i=1: iteraciones
    gradiente(1,1)=subs(fx,[x,y],[a,b]); %Evalua la derivada de la función, 
    gradiente(2,1)=subs(fy,[x,y],[a,b]); %en ambas direcciones 
    hessiano(1,1)=subs(fxx,[x,y],[a,b]); %Evalua segundas derivadas en las
    hessiano(1,2)=subs(fxy,[x,y],[a,b]); %4 direcciones posibles
    hessiano(2,1)=subs(fyx,[x,y],[a,b]); 
    hessiano(2,2)=subs(fyy,[x,y],[a,b]);
    punto=zeros(2,1);
    punto(1,1)=a; %El punto inicial lo convierte en un vector columna
    punto(2,1)=b;
    punto=punto-(inv(hessiano)*gradiente);%aproxima el siguiente punto
    aa=punto(1,1); %punto siguiente
    bb=punto(2,1); 
    fsig=subs(f,[x,y],[aa,bb]); 
    if(fprevio>fsig) %Si se redujo el valor de la función
        fprev=fsig; %Actualiza puntos
        a=punto(1,1);
        b=punto(2,1);
    else
        i=100; %En caso contario, termina la búsqueda
    end
end
%%
%Imprime los valores finales
double(a) %Imprime el resultado de la optimización 
double(b) %En una representación decimal
double(subs(f,[x,y],[a,b])) %tipo double
