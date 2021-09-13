El Script  "run_analysis.R"  contiene la secuenca de cada uno de los pasos requeridos en actividad final del curso. 

(1) Lo primero que hace es descargar los datos con la funcion "download.file" y descomprimirlos con la funcion "unzip"

(2) Seguidamente el Scrip carga los datos que fueron descargados en la carpeta "UCI HAR Dataset" y los asigna a distintos data.frames como se 
describe a continuacion: 


(3) 

features<-read.csv("features.txt") : Tiene 561 filas y  2 columnas, y trae el nombre de las distintas mediciones realizada a partir de un acelerometro (accelerometer) 
y un giroscopio (gyroscope) en los dintios ejes X, Y y Z 

xtrain < read.csv("X_train.txt") Contiene  7352 filas y 561 columnas y abarca todos los registros el conjunto "training"
ytrain<-read.csv("y_train.txt") 7352 filas y 1 columna. Contiene el codigo de cada una de las actividades en el conjunto de entrenamiento. 

xtest<-read.csv("X_test.txt") 2947 filas y  561 columnas. Abarca todos los registros del conjunto de pruebas "test"
ytest<-read.csv("y_test.txt") 2947 filas y una columna.  Contiene el codigo de cada una de las actividades en el conjunto de prueba "test".
activ <- read.csv("activity_labels.txt") : Tiene 6 filas y 2 columnas e identifica el nombre de cada unas de las 6 actividades y su codigo que formaron parte del experimento.

subject_test <- read.csv("subject_test.txt") 2947 filas y 1 columna. Contiene la identificacion del 30% de los sujetos (9/30) que fueron seleccionados como conjunto de  "Test"
subject_train<- read.csv("subject_train.txt") 7352 filas y , 1 columna. Contiene la identificacion del 70% de los sujetos (21/30) que fueron seleccionados como conjunto de  "Training"


(4) Union de los conjuntos "Train" y "Test" en un solo conjunto de datos

A traves de las funciones  X<-rbind(xtrain, xtest); Y<-rbind(ytrain, ytest);  subject<-rbind(subject_train,subject_test) y merged_data<-cbind(subject, Y, X)
se unen en una sola base los conjuntos "train" y "test" con toda la identificaion necesaria. 

(5) Extraccion de las mediciones sobre la media (mean) y desviacion estandar (std)

Para ello se combina la funcion "select" y "contains" de DPLYR como sigue:

extracted<-merged_data%>%select(subject,id_activity, contains(c("mean","std")))

(6) usar nombres descrptivos de las actividades 

Se utiliza como referencia de indice la columna id_activity 
extracted$id_activity <-activ[extracted$id_activity, 2]

(7) Etiquetar apropiadamente las actividades con nombres descriptivos.

Se utiliza la funcion "gsub" en R para buscar un "patron" y reemplazarlo por un nombre mas apropiado

"Acc" por "Accelerometer"; "Gyro" por "Gyroscope"; ...etc
"Si comienza en "t" se reemplza por "Time"
"Si comienza en "f" se reemplza por "Frecuency".... y asi sucesivamente.

(8) Creacion de un segundo conjunto de datos independiente con el promedio (average) de cada variable para cada actividad y sujeto

Para ello se combinan las funcines "group_by" y "summarise_all" de DPLYR  como sigue:

extracted_average<-extracted%>%group_by(activity,subject)%>%summarise_all(mean)

La base de datos final obtenida se reduce a 180 filas  (30 sujetos x 6 actividades) y 88 columnas (solo las relacionadas a "mean" y "std")

(9) Se exporta este conjunto de datos un archivo llamado "FinalDataBase.txt" con la funcion write.table
