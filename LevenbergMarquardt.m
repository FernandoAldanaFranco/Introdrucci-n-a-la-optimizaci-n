%Algoritmo de optimización Levenberg - Marquadt.
%Fernando Aldana
%Septiembre 2025
%Ejemplo basado en la función (x-2)^2 en el intervalo [a,b]
%%
%Limpia y cierra
clc;
clear all;
close all;
iteraciones=60; %Número de iteraciones
%%
%Declara las funciones como simbólicas
syms a; %Variable simbólica
syms b; %Variable simbólica
syms t; %variable simbólica
y=a*exp(b*t); %Declara la función
fa=diff(y, a); %Primera derivada respecto a x
fb=diff(y, b); %Primera derivada respecto a y
jacobiano=zeros(2,2); %almacena jacobiano evaluado
JT=zeros(2,2); %jacobiano transpuesta
lambda=0.001; %Deifne lambda
ILambda=zeros(2,2); %Matriz identidad por lambda
tiempo=zeros(1,2); %puntos iniciales
tiempo(1,1)=1;
tiempo(1,2)=2;
yt=zeros(1,2); %Y la respuesta de la función
yt(1,1)=3.5;
yt(1,2)=12;
error=zeros(2,1); %Vector de errores
puntos=zeros(2,1);%Puntos iniciales
puntos(1,1)=2;
puntos(2,1)=0.5;
psig=zeros(2,1); %Almacena la aproximación de cada iteración
se=0; %Suma de errores
aproximaciones=zeros(iteraciones,12);%Guarda todas las aproximaciones
%%
%Proceso iterativo
for i=1: iteraciones
    %Guarda los valores de aproximación y lambda
    aproximaciones(i,1)=puntos(1,1);
    aproximaciones(i,2)=puntos(2,1);
    aproximaciones(i,3)=lambda;
    %Calcula los errores para los dos valores de tiempo 
    error(1,1)=yt(1,1)-subs(y,[a,b,t],[puntos(1,1),puntos(2,1),tiempo(1,1)]); 
    error(2,1)=yt(1,2)-subs(y,[a,b,t],[puntos(1,1),puntos(2,1),tiempo(1,2)]);
    se=(error(1,1)^2)+(error(2,1)^2); %Calcula la suma de errores
    %Guarda errores y su suma
    aproximaciones(i,4)=error(1,1);
    aproximaciones(i,5)=error(2,1);
    aproximaciones(i,6)=se;
    %Construye la matriz J
    jacobiano(1,1)=subs(fa,[a,b,t],[puntos(1,1),puntos(2,1),tiempo(1,1)]);
    jacobiano(1,2)=subs(fb,[a,b,t],[puntos(1,1),puntos(2,1),tiempo(1,1)]);
    jacobiano(2,1)=subs(fa,[a,b,t],[puntos(1,1),puntos(2,1),tiempo(1,2)]);
    jacobiano(2,2)=subs(fb,[a,b,t],[puntos(1,1),puntos(2,1),tiempo(1,2)]);
    %Matriz transpuesta
    JT(1,1)=jacobiano(1,1);
    JT(1,2)=jacobiano(2,1);
    JT(2,1)=jacobiano(1,2);
    JT(2,2)=jacobiano(2,2);
    %Matriz identidad por lambda
    ILambda(1,1)=lambda;
    ILambda(2,2)=lambda;
    %Calcula aproximación
    psig=puntos+(inv((JT*jacobiano)+ILambda))*(JT)*(error);
    %Calcula los errores para las dos aproximaciones 
    error(1,1)=yt(1,1)-subs(y,[a,b,t],[psig(1,1),psig(2,1),tiempo(1,1)]); 
    error(2,1)=yt(1,2)-subs(y,[a,b,t],[psig(1,1),psig(2,1),tiempo(1,2)]);
    seaprox=(error(1,1)^2)+(error(2,1)^2); %Calcula la suma de errores de la aproximación
    aproximaciones(i,7)=psig(1,1);
    aproximaciones(i,8)=psig(2,1);
    aproximaciones(i,9)=error(1,1);
    aproximaciones(i,10)=error(2,1);
    aproximaciones(i,11)=seaprox;
    if se<seaprox
        %Rechazar la aproximación y aumentar lambda
        lambda=lambda*10;
    else
        %Aceptar la aproximación y disminuir lambda
        puntos(1,1)=psig(1,1);
        puntos(2,1)=psig(2,1);
        lambda=lambda/10;
        aproximaciones(i,12)=1;
    end
end
%%
%Imprime los valores finales
double(puntos(1,1)) %Imprime el resultado de la optimización 
double(puntos(2,1)) %En una representación decimal
double(se) %tipo double

