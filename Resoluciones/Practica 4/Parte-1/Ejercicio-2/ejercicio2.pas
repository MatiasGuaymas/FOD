{2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.
a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.
b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.
c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.
e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?
f. Suponga que desea buscar los alumnos que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?}

//A
const
    M = .. //Orden del arbol
type
    alumno = record
        nombre: string;
        apellido: string;
        dni: integer;
        legajo: integer;
        anioIngreso: integer;
    end;
    nodo = record
        cant_claves: integer;
        claves: array[1..M-1] of longint;
        enlaces: array[1..M-1] of integer;
        hijos: array[1..M] of integer;
    end;
    TArchivoDatos = file of alumno;
    arbolB = file of nodo;
var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolB;

{B. N = (M-1) * A + (M-1) * A + M * B + C
    512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4
    512 = 4M - 4 + 4M - 4 + 4M + 4
    512 = 12M - 4
    512 + 4 = 12M
    516 / 12 = M
    M = 43
    
El orden del arbol B es de 43.}

{C. Incrementar el orden del árbol B significa aumentar la cantidad de registros que caben en un nodo, en este caso índices a registros, 
en consecuencia, esto implica que nuestro árbol sea menos profundo, y que se requieran menos accesos (lecturas) a los nodos.}

{D. Se busca en el árbol la clave con DNI 12345678, aprovechando el criterio de orden, moviéndonos a la izquierda si es menor o igual, y en caso 
contrario, a la derecha. Una vez hallada la clave, uso el NRR guardado en el enlace para buscar el registro en el archivo de datos.}

{E. Si se deseara buscar un alumno por su numero de legajo se deberia realizar una búsqueda secuencial hasta encontrar el alumno con el legajo
solicitado. No tendría sentido en este caso, usar el índice que organiza el acceso al archivo de alumnos por DNI. Para brindar acceso indizado
al archivo de alumnos por número de legajos, lo más conveniente sería armar un nuevo árbol B pero con criterio de orden en base al legajo.}

{F. }