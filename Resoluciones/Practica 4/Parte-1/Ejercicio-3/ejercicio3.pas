{3. Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
considere que por un lado se tiene el archivo que contiene la información de los
alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
siguientes incisos:
a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
encuentran en los nodos internos y que elementos se encuentran en los nodos
hojas?
b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
qué?
c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño.
d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
específico haciendo uso de la estructura auxiliar (índice) que se organiza como
un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
estructurado como un árbol B?
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?}

{A. Todas las claves se encuentran únicamente en los nodos hojas. Los nodos internos
contienen claves que se utilizan para dirigir la búsqueda hacia el nodo hoja correspondiente.}

{B. Los nodos hoja contienen todas las claves del arbol B+ y un enlace adicional que apunta al
siguiente nodo hoja en orden ascendente. Esto permite un recorrido secuencial rápido sobre las claves.}

//C 
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
    lista = ^nodo;
    TArchivoDatos = file of alumno;
    nodo = record
        cant_claves: integer;
        claves: array[1..M-1] of longint;
        enlaces: array[1..M-1] of integer;
        hijos: array[1..M] of integer;
        sig: lista;
        //sig: integer;
    end;
    
    arbolB = file of nodo;
var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolB;

{D. El proceso de busqueda de un alumno con un DNI haciendo uso del árbol B+, consiste en aprovechar el criterio de orden y los 
separadores de los nodos internos, hasta encontrar el dato en una hoja. La diferencia con respecto a un árbol B, es que la búsqueda
siempre termina en un nodo hoja (terminal), y no en los nodos internos, al ser copias.}

{E. }