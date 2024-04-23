{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}

program ejercicio1;
const 
    valoralto = 9999;
type
    producto = record
        codigo: integer;
        nombre: string;
        precio: real;
        stock: integer;
        stockMin: integer;
    end;
    venta = record
        codigo: integer;
        cant: integer;
    end;
    maestro = file of producto;
    detalle = file of venta;
procedure actualizar(var mae: maestro; var det: detalle);
var
    v: venta;
    p: producto;
    cantActual: integer;
begin
    reset(mae);
    reset(det);
    while(not eof(mae)) do
        begin
            read(mae, p);
            cantActual:= 0;
            while(not eof(det)) do
                begin
                    read(det, v);
                    if(v.codigo = p.codigo) then
                        begin
                            cantActual:= cantActual + v.cant;
                        end;
                end;
            seek(det, 0);
            if(cantActual > 0) then
                begin
                    p.stock:= p.stock - cantActual;
                    seek(mae, filepos(mae)-1);
                    write(mae, p);
                end;
        end;
    close(mae);
    close(det);
end;
procedure crearMaestro(var mae: maestro; var carga: text);
var
    nombre: string;
    p: producto;
begin
    reset(carga);
    nombre:= 'ArchivoMaestro';
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with p do
                begin
                    readln(carga, codigo, precio, stock, stockMin, nombre);
                    write(mae, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: detalle; var carga: text);
var
    nombre: string;
    v: venta;
begin
    reset(carga);
    nombre:= 'ArchivoDetalle';
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with v do
                begin
                    readln(carga, codigo, cant);
                    write(det, v);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure imprimirMaestro(var mae: maestro);
var
    p: producto;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            with p do
                writeln('Codigo=', codigo, ' Precio=', precio:0:2, ' StockActual=', stock, ' StockMin=', stockMin, ' Nombre=', nombre);
        end;
    close(mae);
end;
var
    mae: maestro;
    det: detalle;
    cargaMae, cargaDet: text;
begin
    assign(cargaMae, 'maestro.txt');
    crearMaestro(mae, cargaMae);
    assign(cargaDet, 'detalle.txt');
    crearDetalle(det, cargaDet);
    actualizar(mae, det);
    imprimirMaestro(mae);
end.