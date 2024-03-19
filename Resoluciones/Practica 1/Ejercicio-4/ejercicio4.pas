{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado..}

program ejercicio4;
type
    empleado = record
        numero: integer;
        apellido: string[20];
        nombre: string[15];
        edad: integer;
        dni: integer;
    end;
    archivo = file of empleado;
//-----------------------IMPRIMIR EMPLEADO-----------------------
procedure imprimirEmpleado(e: empleado);
begin
    writeln('Numero=', e.numero, ' Apellido=', e.apellido, ' Nombre=', e.nombre, ' Edad=', e.edad, ' DNI=', e.dni);
end;
//-----------------------CARGAR ARCHIVO-----------------------
procedure leerEmpleado(var e: empleado);
begin
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
    if(e.apellido <> 'fin') then
        begin
            writeln('Ingrese el nombre del empleado');
            readln(e.nombre);
            writeln('Ingrese el numero del empleado');
            readln(e.numero);
            writeln('Ingrese la edad del empleado');
            readln(e.edad);
            writeln('Ingrese el DNI del empleado');
            readln(e.dni);
        end;
end;
procedure cargarEmpleados(var arc: archivo);
var
    e: empleado;
begin
    leerEmpleado(e);
    while(e.apellido <> 'fin') do
        begin
            write(arc, e);
            leerEmpleado(e);
        end;
    close(arc);
end;
//-----------------------APELLIDO o NOMBRE DETERMINADO-----------------------
function cumple(nombre, apellido, texto: string): boolean;
begin
    cumple:= ((nombre = texto) or (apellido = texto));
end;
procedure empleadoApellONombre(var arc: archivo);
var
    texto: string[20];
    e: empleado;
begin
    reset(arc);
    writeln('Ingrese un nombre o un apellido de un empleado');
    readln(texto);
    writeln('Empleados que tienen un nombre o apellido iguales a ', texto, ': ');
    while(not EOF(arc)) do
        begin
            read(arc, e);
            if(cumple(e.nombre, e.apellido, texto)) then
                imprimirEmpleado(e);
        end;
    close(arc);
end;
//-----------------------IMPRIMIR ARCHIVO-----------------------
procedure imprimirArchivo(var arc: archivo);
var
    e: empleado;
begin
    reset(arc);
    write('Archivo completo: ');
    while(not EOF(arc)) do
        begin
            read(arc, e);
            imprimirEmpleado(e);
        end;
    close(arc);
end;
//-----------------------MAYORES 70-----------------------
procedure empleadosMayores70(var arc: archivo);
var
    e: empleado;
begin
    reset(arc);
    writeln('Lista de empleados mayores a 70 de anios, prontos a jubilarse: ');
    while(not EOF(arc)) do
        begin
            read(arc, e);
            if(e.edad > 70) then
                imprimirEmpleado(e);
        end;
    close(arc);
end;
//-----------------------A-----------------------
function controlUnicidad(var arc: archivo; numero: integer): boolean;
var
    e: empleado;
    repetido: boolean;
begin
    repetido:= false;
    while(not EOF(arc)) and (not repetido) do
        begin
            read(arc, e);
            if(e.numero = numero) then
                repetido:= true;
        end;
    controlUnicidad:= repetido;
end;
procedure agregarEmpleados(var arc: archivo);
var
    e: empleado;
begin
    reset(arc);
    leerEmpleado(e);
    while(e.apellido <> 'fin') do
        begin
            if(not(controlUnicidad(arc, e.numero))) then
                begin
                    seek(arc, fileSize(arc));
                    write(arc, e);
                end;
            leerEmpleado(e);
        end;
    close(arc);
end;
//-----------------------B-----------------------
procedure modificarEdad(var arc: archivo);
var
    num, edad: integer;
    e: empleado;
    encontre: boolean;
begin
    reset(arc);
    writeln('Ingrese un numero de empleado');
    readln(num);
    encontre:= false;
    while(not EOF(arc)) and (not encontre) do
        begin
            read(arc, e);
            if(e.numero = num) then
                begin
                    encontre:= true;
                    writeln('Ingrese la nueva edad del empleado');
                    readln(edad);
                    e.edad:= edad;
                    seek(arc, filePos(arc)-1);
                    write(arc, e);
                end;
        end;
    if(encontre) then
        writeln('Se modifico la edad del empleado con numero ', num)
    else
        writeln('No se hallo al empleado con el numero ', num);
    close(arc);
end;
//-----------------------C-----------------------
procedure exportarTexto(var arc: archivo);
var
    archivoTexto: text;
    e: empleado;
begin
    assign(archivoTexto, 'todos_empleados.txt');
    reset(arc);
    rewrite(archivoTexto);
    while(not eof(arc)) do
        begin
            read(arc, e);
            with e do writeln(archivoTexto, ' ', numero, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
        end;
    writeln('Archivo de texto del contenido del archivo exportado correctamente');
    close(arc);
    close(archivoTexto);
end; 
//-----------------------D-----------------------
procedure exportarTextoDNI00(var arc: archivo);
var
    archivoTexto: text;
    e: empleado;
begin
    assign(archivoTexto, 'faltaDNIEmpleado.txt');
    reset(arc);
    rewrite(archivoTexto);
    while(not eof(arc)) do
        begin
            read(arc, e);
            if(e.dni = 00) then
                with e do
                    writeln(archivoTexto, ' ', numero, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
        end;
    writeln('Archivo de texto de los empleados que no tengan cargado el DNI exportado correctamente');
    close(arc);
    close(archivoTexto);
end;
//-----------------------MENU DE OPCIONES-----------------------
procedure menuOpciones(var arc: archivo);
var
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
    writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
    writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
    writeln('Opcion 4: Agregar uno o mas empleados al final del archivo con sus datos ingresados');
    writeln('Opcion 5: Modificar la edad de un empleado dado');
    writeln('Opcion 6: Exportar el contenido del archivo a un archivo de texto llamado todos_empleados.txt');
    writeln('Opcion 7: Exportar a un archivo de texto llamado: faltaDNIEmpleado.txt, los empleados que no tengan cargado el DNI');
    writeln('Opcion 8: Salir del menu y terminar la ejecucion del programa');
    writeln();
    readln(opcion);
    while(opcion <> 8) do
        begin
            case opcion of
                1: empleadoApellONombre(arc);
                2: imprimirArchivo(arc);
                3: empleadosMayores70(arc);
                4: agregarEmpleados(arc);
                5: modificarEdad(arc);
                6: exportarTexto(arc);
                7: exportarTextoDNI00(arc);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
            writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
            writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
            writeln('Opcion 4: Agregar uno o mas empleados al final del archivo con sus datos ingresados');
            writeln('Opcion 5: Modificar la edad de un empleado dado');
            writeln('Opcion 6: Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”');
            writeln('Opcion 7: Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI');
            writeln('Opcion 8: Salir del menu y terminar la ejecucion del programa');
            readln(opcion);
        end;
end;
var
    arc: archivo;
    nombre: string[15];
begin
    writeln('Ingrese un nombre del archivo');
    readln(nombre);
    assign(arc, nombre);
    rewrite(arc);
    cargarEmpleados(arc);
    menuOpciones(arc);
end.