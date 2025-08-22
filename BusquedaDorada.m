%Algoritmo de optimización búsqueda sección dorada.
%Fernando Aldana
%Agosto 2025
%Ejemplo basado en la función (x-2)^2 en el intervalo [a,b]
%%
%Limpia y cierra
clc;
clear all;
close all;
% Variables
a=0; %Valor inferior del intervalo inicial
b=5; %Valor superior del intervalo inicial
iteraciones=10; %Número de iteraciones
aurea=0.618; %Proporción aurea aproxiamada
%%
%Proceso iterativo
for i=1: iteraciones
    %calcula el primer punto intermedio
    x1=b-(aurea*(b-a));
    %calcula el primer punto intermedio
    x2=a+(aurea*(b-a));
    %Evaluando la función en ambos puntos
    fx1=(x1-2)^2;
    fx2=(x2-2)^2;
    %Verificar las condiciones
    if fx1<fx2
        b=x2;
    else
        a=x1;
    end
end
%Evalua la función en los últimos dos puntos para obtener una respuesta
fa=(a-2)^2;
fb=(b-2)^2;
if fa<fb
    a
    fa
else
    b
    fb
end