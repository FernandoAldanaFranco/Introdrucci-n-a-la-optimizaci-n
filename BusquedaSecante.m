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
punto=5; %Valor inicial
puntoprevio=6;
a=0;
b=5; %Rango
iteraciones=7; %Número de iteraciones
e=0.1;
%%
%Declara las funciones como simbólicas
syms x; %Variable simbólica
f=(x-2)^2; %Declara la función
fx=diff(f, x); %Primera derivada
%%
%Proceso iterativo
for i=1: iteraciones
    
    s=subs(fx,x,punto); %primera derivada y
    t=subs(fx,x,puntoprevio); %segunda derivada
    temporal=punto;
    punto=punto-(s*(punto-puntoprevio)/(s-t));%Calcula nuevo punto
    %Verifica si el punto aproximado está dentro de los límites de búsqueda
    if punto<a
        punto=a;
    end
    if punto>b
        punto=b;
    end
    if s==0 %Punto crítico
       punto=temporal;%No actualiza le punto calculado
    end
end
%Evalua la función en los últimos dos puntos para obtener una respuesta
punto
subs(f,x,punto)