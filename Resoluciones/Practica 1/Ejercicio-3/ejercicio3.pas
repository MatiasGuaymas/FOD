{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program ejercicio3;
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
//-----------------------A-----------------------
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
//-----------------------B I-----------------------
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
//-----------------------B II-----------------------
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
//-----------------------B III-----------------------
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
//-----------------------MENU DE OPCIONES-----------------------
procedure menuOpciones(var arc: archivo);
var
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
    writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
    writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
    writeln('Opcion 4: Salir del menu y terminar la ejecucion del programa');
    readln(opcion);
    while(opcion <> 4) do
        begin
            case opcion of
                1: empleadoApellONombre(arc);
                2: imprimirArchivo(arc);
                3: empleadosMayores70(arc);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
            writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
            writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
            writeln('Opcion 4: Salir del menu y terminar la ejecucion del programa');
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