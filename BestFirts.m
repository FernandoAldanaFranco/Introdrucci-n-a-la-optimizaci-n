%Algoritmo firts best
%Fernando Aldana
%Octubre 2025
close all;
clear all;
clc;
%%
syms x; %Variable simbólica
f=(x-1)^2; %Declara la función
Resolution=100000; %Resolución de los pesos
rng(0,'philox'); %Inicia números aleatorios
px=randi(Resolution)/(Resolution*10); %Punto inicial en X 0 a 10
if randi(10)>5
    px=px*-1; %Lo vuelve negativo
end
incremento_a=0.001; %Incremento estático en el proceso
incremento_b=0.01; %Incremento estático en el proceso
incremento_c=0.1; %Incremento estático en el proceso
tolerancia=0.001; %Valor de tolerancia del sistema
psig=zeros(1,6);
eval_fun_puntos=zeros(1,6);
%%
%Proceso iterativo
bandera =1;
eval_fun=subs(f,[x],px); %Evalua la función en el punto inicial
contador=0;
while bandera==1
    psig(1,1)=px+incremento_a; %Punto siguiente
    psig(1,2)=px-incremento_a; %Punto siguiente
    psig(1,3)=px+incremento_b; %Punto siguiente
    psig(1,4)=px+incremento_b; %Punto siguiente
    psig(1,5)=px+incremento_c; %Punto siguiente
    psig(1,6)=px-incremento_c; %Punto siguient
    eval_fun_puntos(1,1)=subs(f,[x],psig(1,1)); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,2)=subs(f,[x],psig(1,2)); %Evalua la función en el punto anterior
    eval_fun_puntos(1,3)=subs(f,[x],psig(1,3)); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,4)=subs(f,[x],psig(1,4)); %Evalua la función en el punto anterior
    eval_fun_puntos(1,5)=subs(f,[x],psig(1,5)); %Evalua la función en el punto siguiente
    eval_fun_puntos(1,6)=subs(f,[x],psig(1,6)); %Evalua la función en el punto anterior
    indice=find(eval_fun_puntos==min(eval_fun_puntos)); %Obtiene el índice del valor mínimo de las evaluaciones
    if eval_fun_puntos(1,indice) < eval_fun
        px=psig(1,indice);
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
double(eval_fun) %En una representación decimal
contador