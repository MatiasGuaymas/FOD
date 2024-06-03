program parcial;
const
    valoralto = 9999;
    DF = 2;
    //DF = 20;
type
    subRango = 1..DF;
    infoMaestro = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;
    infoDetalle = record    
        codigo: integer;
        cant: integer;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vecDetalles = array[subRango] of detalle;
    vecRegistros = array[subRango] of infoDetalle;
procedure leer(var det: detalle; var info: infoDetalle);
begin
    if(not eof(det)) then
        read(det, info)
    else
        info.codigo:= valoralto;
end;
procedure minimo(var vecDet: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, pos: subRango;
begin
    min.codigo:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].codigo < min.codigo) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.codigo <> valoralto) then
        leer(vecDet[pos], vecReg[pos]);
end;
procedure actualizarMaestro(var mae: maestro; var vecDet: vecDetalles; var txt: text);
var
    vecReg: vecRegistros;
    infoMae: infoMaestro;
    i: subRango;
    min: infoDetalle;
    productosComprados, stockActual: integer;
    precioActual: real;
begin
    assign(txt, 'informe.txt');
    rewrite(txt);
    for i:= 1 to DF do
        begin
            reset(vecDet[i]);
            leer(vecDet[i], vecReg[i]);
        end;
    reset(mae);
    minimo(vecDet, vecReg, min);
    while(min.codigo <> valoralto) do
        begin
            read(mae, infoMae);
            while(infoMae.codigo <> min.codigo) do
                read(mae, infoMae);
            productosComprados:= 0;
            precioActual:= infoMae.precio;
            stockActual:= infoMae.stockActual;
            while(infoMae.codigo = min.codigo) do
                begin
                    if(stockActual > min.cant) then
                        begin
                            productosComprados:= productosComprados + min.cant;
                            stockActual:= stockActual - min.cant;
                        end
                    else
                        begin
                            productosComprados:= productosComprados + stockActual;
                            stockActual:= 0;
                        end;
                    minimo(vecDet, vecReg, min);
                end;
            infoMae.stockActual:= stockActual;
            if(productosComprados * precioActual > 10000) then
                writeln(txt, infoMae.codigo, ' ', precioActual:0:2, ' ', infoMae.stockActual, ' ', infoMae.stockMinimo, infoMae.nombre);
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
        end;
    for i:= 1 to DF do
        close(vecDet[i]);
    close(mae);
    close(txt);
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
    i: subRango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle(vec[i]);
end;
procedure imprimirMaestro(var mae: maestro);
var
    p: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            writeln('Codigo=', p.codigo, ' StockActual=', p.stockActual, ' StockMin=', p.stockMinimo, ' Precio=', p.precio:0:2, ' Nombre=', p.nombre);
        end;
    close(mae);
end;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    p: infoMaestro;
begin
    assign(txt, 'productos.txt');
    reset(txt);
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with p do
                begin
                    readln(txt, codigo, stockActual, stockMinimo, precio, nombre);
                    write(mae, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
var
    mae: maestro;
    vecDet: vecDetalles;
    txt: text;
begin
    crearMaestro(mae);
    crearDetalles(vecDet);
    actualizarMaestro(mae, vecDet, txt);
    imprimirMaestro(mae);
end.