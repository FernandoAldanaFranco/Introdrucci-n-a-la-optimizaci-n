%AGG Versión 1.0
%Fernando Aldana Franco
%13 de marzo de 2025
%%
clc; %limpia línea de comandos
clear all; %Limpia espacio de trabajo
close all; %Cierra ventanas abiertas
%%
%Variables del programa
%De la función
syms x; %Variable simbólica
syms y; %Variable simbólica
syms z; %Variable simbólica
syms w; %Variable simbólica
f=(x-1)^2+(y-1)^2+(z-1)^2+(w-1)^2; %Declara la función
Resolution=100000; %Resolución de los pesos
nvariables=4;
%Del AG
NumberIndividuals=3; %Cantidad de individuos en una generación
NumberGenerations=100; %Número de generaciones
MutationRate=5; %Porcentaje de mutación (1%-3%)
fitness=zeros(1,NumberIndividuals); %Guarda la aptitud de la generación
fitnessSons=zeros(1,NumberIndividuals); %Guarda la aptitud de la generación de hijos
parents=ones(NumberIndividuals,3); %Guarda lista de padres y puntos de cruza
stats=zeros(NumberGenerations,3); %Guarda las estadísticas de todo el proceso: best, average & worst
theBest=zeros(1,nvariables);%Guarda al mejor en cada generación
individual=zeros(NumberIndividuals,nvariables); %Guarda a los individuos de una generación
nextGeneration=zeros(3,NumberIndividuals*2);%Guarda los índices de la siguiente generación
bestIndividuals=zeros(3,NumberIndividuals);
best=1; %Índice del mejor individuo por generación
worst=1; %Índice del peor individuo por generación
%%
%Inicia la población
%rng(0,'twister'); %Inicia números aleatorios
rng(7,'philox');
for ci=1:NumberIndividuals %CI es contador de individuos
    for cw=1:nvariables %CW es contador de variables
        individual(ci,cw)=(10*randi(Resolution))/Resolution; %Genera pesos aleatorios
        if randi(10)>5
            individual(ci,cw)=-1*individual(ci,cw); %Cambia el signo
        end
    end
end
%%
%Ciclo principal
for cg=1: NumberGenerations %CG es el contador de generaciones
    %Prueba cada red de la generación de padres
    for ci=1: NumberIndividuals
        %Prueba cada solución
        eval_fun=subs(f,[x,y,z,w],[individual(ci,1),individual(ci,2),individual(ci,3),individual(ci,4)]); %Evalua la función en el punto siguiente
        fitness(1,ci)=(100-double(eval_fun));%Guarda el fitness. Si el valor obtenido es mínimo, el fitness se incrementa
    end
    %Operador de selección
    for ci=1:NumberIndividuals
        %Padre 1
        pa=randi(NumberIndividuals);%Sortea padre potencial A
        pb=randi(NumberIndividuals);%Sortea padre potencial B
        if pa==pb %Verifica si los padres son el mismo
            if pb>NumberIndividuals
                pb=pb-1;
            else
                if pb==1
                    pb=pb+1;
                else
                    pb=pb-1;
                end
            end
        end
        parents(ci,1)=pa; %Supone que el padre a es el mejor
        if fitness(1,pb)>fitness(1,pa)%Verifica si el fitness del padre b es mayor al del padre a
            parents(ci,1)=pb;%Acualiza al padre b
        end
        %Padre 2
        pa=randi(NumberIndividuals);%Sortea padre potencial A
        pb=randi(NumberIndividuals);%Sortea padre potencial B
        if pa==pb %Verifica si los padres son el mismo
            if pb>NumberIndividuals
                pb=pb-1;
            else
                if pb==1
                    pb=pb+1;
                else
                    pb=pb-1;
                end
            end
        end
        parents(ci,2)=pa; %Supone que el padre a es el mejor
        if fitness(1,pb)>fitness(1,pa)%Verifica si el fitness del padre b es mayor al del padre a
            parents(ci,2)=pb;%Acualiza al padre b
        end
    end
    %Cross Over
    for ci=1: NumberIndividuals
        cp=randi(nvariables);%Sortea punto de cruza
        parents(ci,3)=cp;%Guarda punto de cruza
    end
    %Guarda la población de padres
    individualParents=zeros(NumberIndividuals,nvariables); %Guarda temporalmente a los individuos de la generación actual
    individualParents(:,:)=individual(:,:);%Copia la nueva generación
    %Cruza
    for ci=1: NumberIndividuals
        for cw=1: nvariables
            if cw<=parents(ci,3)
                individual(ci,cw)=individualParents(parents(ci,1),cw);
            else
                individual(ci,cw)=individualParents(parents(ci,2),cw);
            end
        end
    end
    %Mutación
    %Calcula el total de mutaciones máximas por generación
    mut_index=int16(nvariables*NumberIndividuals*(MutationRate/100));
    %Recorreo individuos y pesos para aplicar mutación
    for ci=1:NumberIndividuals 
        for cw=1: nvariables %Recorre todos los pesos de la generación
            if mut_index>0 %Si aún queda espacio para mutaciones
                if randi(10)<5 %Sortea si a ese peso se le aplica mutación
                    individual(ci,cw)=(10*randi(Resolution))/Resolution; %Sortea el valor de mutación
                    if randi(10)>5 %Sortea cambio de signo
                        individual(ci,cw)=individual(ci,cw)*-1;
                    end
                    mut_index=mut_index-1;%decrementa la mutación
                end
            end
        end
    end
    %Prueba la generación de hijos
    %Prueba cada red de la generación de padres
    for ci=1: NumberIndividuals
        %Prueba cada solución
        eval_fun=subs(f,[x,y,z,w],[individual(ci,1),individual(ci,2),individual(ci,3),individual(ci,4)]); %Evalua la función en el punto siguiente
        fitness(1,ci)=(100-double(eval_fun));%Guarda el fitness. Si el valor obtenido es mínimo, el fitness se incrementa
    end
    %Reemplazo
    %Copia a todos los individuos en un mismo arreglo
    for ci=1: NumberIndividuals
       nextGeneration(1,ci)=fitness(1,ci);
       nextGeneration(2,ci)=ci;
       nextGeneration(3,ci)=1; %padre
       nextGeneration(1,ci+NumberIndividuals)=fitnessSons(1,ci);
       nextGeneration(2,ci+NumberIndividuals)=ci;
       nextGeneration(3,ci+NumberIndividuals)=2; %padre
    end
    temporal=zeros(3,1);
    for i=1:NumberIndividuals*2
        for ci=1:NumberIndividuals*2
            if ci~=i
                if nextGeneration(1,ci)<nextGeneration(1,i)
                    temporal(1,1)=nextGeneration(1,ci);
                    temporal(2,1)=nextGeneration(2,ci);
                    temporal(3,1)=nextGeneration(3,ci);
                    nextGeneration(1,ci)=nextGeneration(1,i);
                    nextGeneration(2,ci)=nextGeneration(2,i);
                    nextGeneration(3,ci)=nextGeneration(3,i);
                    nextGeneration(1,i)=temporal(1,1);
                    nextGeneration(2,i)=temporal(2,1);
                    nextGeneration(3,i)=temporal(3,1);
                end
            end
        end
    end
    %Forma la nueva generación
    individualTemp=zeros(NumberIndividuals,nvariables);
    for ci=1:NumberIndividuals
        ind=nextGeneration(2,ci);%Selecciona al individuo a copiar
        tabla=nextGeneration(3,ci);%Selecciona si es padre o hijo
        for cw=1:nvariables %CW es contador de pesos
            if tabla==1
                individualTemp(ci,cw)=individualParents(ind,cw);%Copia padre
            else
                individualTemp(ci,cw)=individual(ind,cw);%Copia hijo
            end
        end
    end
    individual(:,:)=individualTemp(:,:);%Copia la nueva generación
    %Estadísticas de la generación
    stats(cg,1)=nextGeneration(1,1);%Mejor
    stats(cg,3)=nextGeneration(1,(NumberIndividuals*2));%Peor
    aux=0;%Auxiliar
    for ci=1:(NumberIndividuals*2) %Recorre el fitness de cada individuo
        aux=aux+nextGeneration(1,ci);%Suma el fitness del individiuo
        fitness(1,ci)=0;%Limpia fitness
        fitnessSons(1,ci)=0;%Limpia fitness
    end
    stats(cg,2)=aux/(NumberIndividuals*2);%Calcula el promedio
end
plot((1:NumberGenerations),stats(:,2));
hold on;
plot((1:NumberGenerations),stats(:,1));
plot((1:NumberGenerations),stats(:,3));
hold off;