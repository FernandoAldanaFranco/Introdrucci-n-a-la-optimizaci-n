%Algoritmo de optimización búsqueda de Newton.
%Fernando Aldana
%Agosto 2025
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
alpha=0.1; %tasa de aprendizaje
%%
%Proceso iterativo
for i=1: iteraciones
    %dx=subs(f,x,y,punto); %Evalua función, 
    dx=-1*subs(fx,[x,y],[a,b]); %componente x del vector d
    dy=-1*subs(fy,[x,y],[a,b]); %componente y del vector d
    a=a+(alpha*dx); %Actuaiza valores en x
    b=b+(alpha*dy); %En y
end
%%
%Imprime los valores finales
double(a) %Imprime el resultado de la optimización 
double(b) %En una representación decimal
double(subs(f,[x,y],[a,b])) %tipo double
