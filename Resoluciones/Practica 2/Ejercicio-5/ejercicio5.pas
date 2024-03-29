{5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto}

program ejercicio5;
const
    valoralto = 999;
    DF = 3;
    //DF = 30;
type
    subrango = 1..DF;
    producto = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        stockDisp: integer;
        stockMin: integer;
        precio: real;
    end;
    infoDetalle = record
        codigo: integer;
        cant: integer;
    end;
    maestro = file of producto;
    detalle = file of infoDetalle;
    vecDetalles = array [subrango] of detalle;
    vecRegistros = array [subrango] of infoDetalle;
procedure leer(var det: detalle; var infoDet: infoDetalle);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.codigo := valoralto;
end;
procedure minimo(var vec: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, pos: subrango;
begin
    min.codigo:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].codigo < min.codigo) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.codigo <> valoralto) then
        leer(vec[pos], vecReg[pos]);
end;
procedure reporte(var mae: maestro);
var
    p: producto;
    txt: text;
begin
    assign(txt, 'reporte.txt');
    reset(mae);
    rewrite(txt);
    while(not eof(mae)) do
        begin
            read(mae, p);
            if(p.stockDisp < p.stockMin) then
                writeln(txt, p.nombre,' ', p.descripcion,' ', p.stockDisp, ' ', p.precio:0:2);
        end;
    close(txt);
end;
procedure actualizarMaestro(var mae: maestro; var vec: vecDetalles);
var
    min: infoDetalle;
    infoMae: producto;
    vecReg: vecRegistros;
    i: subrango;
    aux, cant: integer;
begin
    reset(mae);
    for i:= 1 to DF do
        begin
            reset(vec[i]);
            leer(vec[i], vecReg[i]);
        end;
    minimo(vec, vecReg, min);
    while(min.codigo <> valoralto) do
        begin
            aux:= min.codigo;
            cant:= 0;
            while(min.codigo <> valoralto) and (min.codigo = aux) do
                begin
                    cant:= cant + min.cant;
                    minimo(vec, vecReg, min);
                end;
            read(mae, infoMae);
            while(infoMae.codigo <> aux) do
                read(mae, infoMae);
            seek(mae, filepos(mae)-1);
            infoMae.stockDisp:= infoMae.stockDisp - cant;
            write(mae, infoMae);
        end;
    reporte(mae);
    close(mae);
    for i:= 1 to DF do
        close(vec[i]);
end;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    p: producto;
    nombre: string;
begin
    assign(txt, 'productos.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with p do
                begin
                    readln(txt, codigo, stockDisp, stockMin, precio, nombre);
                    readln(txt, descripcion);
                    write(mae, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
procedure crearUnSoloDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    p: infoDetalle;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with p do
                begin
                    readln(carga, codigo, cant);
                    write(det, p);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure crearDetalles(var vec: vecDetalles);
var
    i: subrango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle(vec[i]);
end;
procedure imprimirMaestro(var mae: maestro);
var
    p: producto;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            writeln('Codigo=', p.codigo, ' StockDisp=', p.stockDisp, ' StockMin=', p.stockMin, ' Precio=', p.precio:0:2, ' Nombre=', p.nombre, ' Desc=', p.descripcion);
        end;
    close(mae);
end;
var
    vec: vecDetalles;
    mae: maestro;
begin
    crearMaestro(mae);
    crearDetalles(vec);
    actualizarMaestro(mae, vec);
    imprimirMaestro(mae);
end.