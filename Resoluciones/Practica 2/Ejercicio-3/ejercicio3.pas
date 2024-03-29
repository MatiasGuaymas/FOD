{3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program ejercicio3;
const
    valoralto = 999;
type
    producto = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMin: integer;
    end;
    venta = record
        codigo: integer;
        cant: integer;
    end;
    maestro = file of producto;
    detalle = file of venta;
procedure leer(var det: detalle; var v: venta);
begin
    if(not(eof(det))) then
        read(det, v)
    else
        v.codigo:= valoralto;
end;
procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
    v: venta;
    p: producto;
begin
    reset(mae);
    reset(det);
    leer(det, v);
    while(v.codigo <> valoralto) do
        begin
            read(mae, p);
            while(p.codigo <> v.codigo) do
                read(mae, p);
            while(p.codigo = v.codigo) do
                begin
                    if(v.cant >= p.stockActual) then
                        p.stockActual:= 0
                    else
                        p.stockActual:= p.stockActual - v.cant;
                    leer(det, v);
                end;
            seek(mae, filepos(mae)-1);
            write(mae, p);
        end;
    close(mae);
    close(det);
end;
procedure exportarTexto(var mae: maestro);
var
    p: producto;
    txt: text;
begin
    assign(txt, 'stock_minimo.txt');
    rewrite(txt);
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            if(p.stockActual < p.stockMin) then
                with p do
                    writeln(txt, 'Codigo=', codigo, ' Precio=', precio:0:2, ' StockActual=', stockActual, ' StockMin=', stockMin, ' Nombre=', nombre);
        end;
    writeln('Archivo exportado a TXT - stockMin');
    close(mae);
    close(txt);
end;
procedure crearMaestro(var mae: maestro; var carga: text);
var
    nombre: string;
    p: producto;
begin
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with p do
                begin
                    readln(carga, codigo, precio, stockActual, stockMin, nombre);
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
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
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
                writeln('Codigo=', codigo, ' Precio=', precio:0:2, ' StockActual=', stockActual, ' StockMin=', stockMin, ' Nombre=', nombre);
        end;
    close(mae);
end;
procedure menu;
var
    mae: maestro;
    det: detalle;
    cargaMae, cargaDet: text;
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('1. Generar archivos binarios maestro y detalle de txt');
    writeln('2. Actualizar el archivo maestro con el archivo detalle');
    writeln('3. Listar en un archivo de texto llamado stock_minimo.txt aquellos productos cuyo stock actual esta por debajo del stock minimo permitido');
    writeln('4. Salir del menu de opciones');
    readln(opcion);
    while(opcion <> 4) do
        begin
            case opcion of
                1: begin
                    assign(cargaMae, 'maestro.txt');
                    assign(cargaDet, 'detalle.txt');
                    crearMaestro(mae, cargaMae);
                    crearDetalle(det, cargaDet);
                end;
                2: begin
                    actualizarMaestro(mae, det);
                    writeln('Actualizacion de maestro realizada');
                    imprimirMaestro(mae);
                end;
                3: exportarTexto(mae);
                else
                    writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
                end;
            writeln('MENU DE OPCIONES');
            writeln('1. Generar archivos binarios maestro y detalle de txt');
            writeln('2. Actualizar el archivo maestro con el archivo detalle');
            writeln('3. Listar en un archivo de texto llamado stock_minimo.txt aquellos productos cuyo stock actual esta por debajo del stock minimo permitido');
            writeln('4. Salir del menu de opciones');
            readln(opcion);
        end;
end;
begin
    menu();
end.