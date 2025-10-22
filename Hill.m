%Algoritmo hill climbing
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
incremento=0.001; %Incremento estático en el proceso
tolerancia=0.001; %Valor de tolerancia del sistema
%%
%Proceso iterativo
bandera =1;
eval_fun=subs(f,[x],px); %Evalua la función en el punto inicial
contador=0;
while bandera==1
    psig=px+incremento; %Punto siguiente
    pant=px-incremento; %Punto siguiente
    eval_fun_sig=subs(f,[x],psig); %Evalua la función en el punto siguiente
    eval_fun_ant=subs(f,[x],pant); %Evalua la función en el punto anterior
    if eval_fun_sig < eval_fun
        px=psig;
        eval_fun=eval_fun_sig;%Cambia al punto actual
    else
        if eval_fun_ant<eval_fun
            px=pant;
            eval_fun=eval_fun_ant;%Cambia al punto actual
        end
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