{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program ejercicio1;
const
    valoralto = -1;
type
    empleado = record
        codigo: integer;
        nombre: string;
        monto: real;
    end;

    archivo = file of empleado;
procedure crearArchivo(var arc: archivo; var carga: text);
var
    nombre: string;
    emp: empleado;
begin
    writeln('Ingrese un nombre del archivo a crear');
    readln(nombre);
    assign(arc, nombre);
    reset(carga);
    rewrite(arc);
    while(not eof(carga)) do
        begin
            with emp do
                begin
                    readln(carga, codigo, monto, nombre);
                    write(arc, emp);
                end;
        end;
    writeln('Archivo binario creado');
    close(arc);
    close(carga);
end;
procedure leer(var arc: archivo; var dato: empleado);
begin
    if(not(eof(arc))) then
        read(arc, dato)
    else
        dato.codigo := valoralto;
end;
procedure actualizarMaestro(var arc: archivo; var maestro: archivo);
var
    emp, empTotal, aux: empleado;
    total: real;
begin
    assign(maestro, 'archivoCompactado');
    reset(arc);
    rewrite(maestro);
    leer(arc, emp);
    while(emp.codigo <> valoralto) do
        begin
            aux:= emp;
            total:= 0;
            while(aux.codigo = emp.codigo) do
                begin
                    total:= total + emp.monto;
                    leer(arc, emp);
                end;
            empTotal:= aux;
            empTotal.monto:= total;
            write(maestro, empTotal);
        end;
    close(maestro);
    close(arc);
end;
procedure imprimirMaestro(var maestro: archivo);
var
    emp: empleado;
begin
    reset(maestro);
    while(not EOF(maestro)) do
        begin
            read(maestro, emp);
            writeln('Codigo=', emp.codigo, ' Nombre=', emp.nombre, ' MontoTotal=', emp.monto:0:2);
        end;
    close(maestro);
end;
var
    arc, maestro: archivo;
    carga: text;
begin
    assign(carga, 'empleados.txt');
    crearArchivo(arc, carga);
    actualizarMaestro(arc, maestro);
    imprimirMaestro(maestro);
end.