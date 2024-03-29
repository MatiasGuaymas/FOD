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
type
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
    detalle = file of infoDetalle;
    maestro = file of producto;
    vecDetalles = array [1..30] of detalle;
procedure cargarInfoDet(var infoDet: infoDetalle);
begin
    writeln('Ingrese un codigo del producto');
    readln(infoDet.codigo);
    if(infoDet.codigo <> -1) then
        readln(infoDet.cant);
end;
procedure cargarArchivoDetalle(var det: detalle);
var
    infoDet: infoDetalle;
    nombre: string;
begin
    rewrite(det);
    cargarInfoDet(infoDet);
    while(infoDet.codigo <> -1) do
        begin
            write(det, infoDet);
            cargarInfoDet(infoDet);
        end;
    close(det);
end;
procedure leer(var det: detalle; var infoDet: infoDetalle);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.codigo := valoralto;
end;
procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
    infoDet: infoDetalle;
    infoMae: producto;
begin
    reset(mae);
    reset(det);
    leer(det, infoDet);
    while(infoDet <> valoralto) do
        begin
            read(mae, infoMae);
            while(infoMae.codigo <> infoDet.codigo) do
                read(mae, infoMae);
            while(infoMae.codigo = infoDet.codigo) do
                begin
                    if(infoMae.stockDisp < infoDet.cant) then
                        infoMae.stockDisp := 0
                    else
                        infoMae.stockDisp := infoMae.stockDisp - infoDet.cant;
                    leer(det, infoDet);
                end;
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
        end;
    close(mae);
    close(det);
end;