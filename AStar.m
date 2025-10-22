%Algoritmo A*
%Fernando Aldana
%Octubre 2025
close all;
clear all;
clc;
%%
syms x; %Variable simbólica
syms y; %Variable simbólica
f=(x-1)^2+(y-1)^2; %Declara la función
Resolution=100000; %Resolución de los pesos
rng(0,'philox'); %Inicia números aleatorios
px=randi(Resolution)/(Resolution*10); %Punto inicial en X 0 a 10
if randi(10)>5
    px=px*-1; %Lo vuelve negativo
end
rng(0,'philox'); %Inicia números aleatorios
py=randi(Resolution)/(Resolution*10); %Punto inicial en X 0 a 10
if randi(10)>5
    py=py*-1; %Lo vuelve negativo
end
incremento=0.001; %Incremento estático en el proceso
tolerancia=0.001; %Valor de tolerancia del sistema
psig=zeros(2,8); %Guarda los puntos de estrella
eval_fun_puntos=zeros(1,8); %Guarda la evaluación d ela estrella
%%
%Proceso iterativo
bandera =1;
eval_fun=subs(f,[x,y],[px,py]); %Evalua la función en el punto inicial
contador=0;
while bandera==1
    psig(1,1)=px+incremento; %Punto siguiente
    psig(2,1)=py; %Punto siguiente
    psig(1,2)=px-incremento; %Punto siguiente
    psig(2,2)=py; %Punto siguiente
    psig(1,3)=px; %Punto siguiente
    psig(2,3)=py+incremento; %Punto siguiente
    psig(1,4)=px; %Punto siguiente
    psig(2,4)=py-incremento; %Punto siguiente
    psig(1,5)=px+incremento; %Punto siguiente
    psig(2,5)=py+incremento; %Punto siguiente
    psig(1,6)=px-incremento; %Punto siguiente
    psig(2,6)=py+incremento; %Punto siguiente
    psig(1,7)=px+incremento; %Punto siguiente
    psig(2,7)=py-incremento; %Punto siguiente
    psig(1,8)=px-incremento; %Punto siguiente
    psig(2,8)=py-incremento; %Punto siguiente
    eval_fun_puntos(1,1)=subs(f,[x,y],[psig(1,1),psig(2,1)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,2)=subs(f,[x,y],[psig(1,2),psig(2,2)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,3)=subs(f,[x,y],[psig(1,3),psig(2,3)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,4)=subs(f,[x,y],[psig(1,4),psig(2,4)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,5)=subs(f,[x,y],[psig(1,5),psig(2,5)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,6)=subs(f,[x,y],[psig(1,6),psig(2,6)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,7)=subs(f,[x,y],[psig(1,7),psig(2,7)]); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,8)=subs(f,[x,y],[psig(1,8),psig(2,8)]); %Evalua la función en el punto siguiente
    indice=find(eval_fun_puntos==min(eval_fun_puntos)); %Obtiene el índice del valor mínimo de las evaluaciones
    if eval_fun_puntos(1,indice) < eval_fun
        px=psig(1,indice);
        py=psig(2,indice); % Actualiza el valor de y al nuevo punto
        eval_fun=eval_fun_puntos(1,indice);%Cambia al punto actual
    end
    if eval_fun < tolerancia
        bandera=0;
    end
    contador=contador+1;
end
%%
%Imprime los valores finales
double(px) %Imprime el resultado de la optimización 
double(py) %Imprime el resultado de la optimización 
double(eval_fun) %En una representación decimal
contador