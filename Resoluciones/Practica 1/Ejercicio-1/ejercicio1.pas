{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.}

program ejercicio1;
type
    archivo = file of integer;
procedure agregarNumeros(var arc: archivo);
var
    nro: integer;
begin
    writeln('Ingrese un numero de teclado');
    readln(nro);
    while(nro <> 30000) do
        begin
            write(arc, nro);
            readln(nro);
        end;
    close(arc);
end;
var
    nombre: string[15];
    arc: archivo;
begin
    writeln('Ingrese un nombre de archivo');
    readln(nombre);
    assign(arc, nombre);
    rewrite(arc);
    agregarNumeros(arc);
end.