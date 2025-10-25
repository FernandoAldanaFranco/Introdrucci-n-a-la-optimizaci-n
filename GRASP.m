%Algoritmo GRASP
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
npuntos=10; %Cantidad de puntos iniciales
puntos=zeros(3,npuntos); %Fila 1 px, fila 2 py, fila 3 evaluación
%Crea los puntos iniciales
for i=1: npuntos
    puntos(1,i)=randi(Resolution)/(Resolution*10); %Punto inicial en X 0 a 10
    if randi(10)>5
        puntos(1,i)=puntos(1,i)*-1; %Lo vuelve negativo
    end
    puntos(2,i)=randi(Resolution)/(Resolution*10); %Punto inicial en X 0 a 10
    if randi(10)>5
        puntos(2,i)=puntos(2,i)*-1; %Lo vuelve negativo
    end
    puntos(3,i)=subs(f,[x,y],[puntos(1,i),puntos(2,i)]); %Evalua la función en los puntos iniciales
end
%rng(0,'philox'); %Inicia números aleatorios
incremento=0.001; %Incremento estático en el proceso
tolerancia=0.001; %Valor de tolerancia del sistema
psig=zeros(2,8); %Guarda los puntos de estrella
eval_fun_puntos=zeros(1,8); %Guarda la evaluación de la estrella
%%
%Proceso iterativo para cada punto
bandera =1;
contador=0;
%eval_fun=subs(f,[x,y],[px,py]); %Evalua la función en el punto inicial
while bandera==1
    for i=1: npuntos
        psig(1,1)=puntos(1,i)+incremento; %Punto siguiente
        psig(2,1)=puntos(2,i); %Punto siguiente
        psig(1,2)=puntos(1,i)-incremento; %Punto siguiente
        psig(2,2)=puntos(2,i); %Punto siguiente
        psig(1,3)=puntos(1,i); %Punto siguiente
        psig(2,3)=puntos(2,i)+incremento; %Punto siguiente
        psig(1,4)=puntos(1,i); %Punto siguiente
        psig(2,4)=puntos(2,i)-incremento; %Punto siguiente
        psig(1,5)=puntos(1,i)+incremento; %Punto siguiente
        psig(2,5)=puntos(2,i)+incremento; %Punto siguiente
        psig(1,6)=puntos(1,i)-incremento; %Punto siguiente
        psig(2,6)=puntos(2,i)+incremento; %Punto siguiente
        psig(1,7)=puntos(1,i)+incremento; %Punto siguiente
        psig(2,7)=puntos(2,i)-incremento; %Punto siguiente
        psig(1,8)=puntos(1,i)-incremento; %Punto siguiente
        psig(2,8)=puntos(2,i)-incremento; %Punto siguiente
        eval_fun_puntos(1,1)=subs(f,[x,y],[psig(1,1),psig(2,1)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,2)=subs(f,[x,y],[psig(1,2),psig(2,2)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,3)=subs(f,[x,y],[psig(1,3),psig(2,3)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,4)=subs(f,[x,y],[psig(1,4),psig(2,4)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,5)=subs(f,[x,y],[psig(1,5),psig(2,5)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,6)=subs(f,[x,y],[psig(1,6),psig(2,6)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,7)=subs(f,[x,y],[psig(1,7),psig(2,7)]); %Evalua la función en el punto siguiente
        eval_fun_puntos(1,8)=subs(f,[x,y],[psig(1,8),psig(2,8)]); %Evalua la función en el punto siguiente
        indice=find(eval_fun_puntos==min(eval_fun_puntos)); %Obtiene el índice del valor mínimo de las evaluaciones
        if eval_fun_puntos(1,indice) < puntos(3,i)
            puntos(1,i)=psig(1,indice);
            puntos(2,i)=psig(2,indice); % Actualiza el valor de y al nuevo punto
            puntos(3,i)=eval_fun_puntos(1,indice);%Cambia al punto actual
        end
        if puntos(3,i) < tolerancia
            bandera=0;
        end
        contador=contador+1;
    end
end
%%
%Imprime los valores finales
double(puntos(:,:)) %Imprime el resultado de la optimización 
contador