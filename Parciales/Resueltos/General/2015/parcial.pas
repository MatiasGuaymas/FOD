program parcial;
const
    valoralto = 9999;
type
    infoMaestro = record    
        codigoProducto: integer;
        nombre: string;
        descripcion: string;
        codigoBarras: integer;
        categoria: integer;
        stockActual: integer;
        stockMinimo: integer;
    end;
    infoDetalle = record
        codigoProducto: integer;
        cantPedida: integer;
        descripcion: string;
    end;
    arcMaestro = file of infoMaestro;
    arcDetalle = file of infoDetalle;
procedure leer(var det: arcDetalle; var info: infoDetalle);
begin
    if(not eof(det)) then
        read(det, info)
    else
        info.codigoProducto:= valoralto;
end;
procedure minimo(var det1, det2, det3: arcDetalle; var r1, r2, r3, min: infoDetalle);
begin
    if(r1.codigoProducto < r2.codigoProducto) then
        begin
            min:= r1;
            leer(det1, r1);
        end
    else
        if(r2.codigoProducto < r3.codigoProducto) then
            begin
                min:= r2;
                leer(det2, r2);
            end
        else
            begin
                min:= r3;
                leer(det3, r3);
            end;
end;
procedure actualizarMaestro(var mae: arcMaestro; var det1, det2, det3: arcDetalle);
var
    infoM: infoMaestro;
    infoDet1, infoDet2, infoDet3, min: infoDetalle;
begin
    reset(mae);
    reset(det1);
    reset(det2);
    reset(det3);
    leer(det1, infoDet1);
    leer(det2, infoDet2);
    leer(det3, infoDet3);
    minimo(det1, det2, det3, infoDet1, infoDet2, infoDet3, min);
    while(min.codigoProducto <> valoralto) do
        begin
            read(mae, infoM);
            while(infoM.codigoProducto <> min.codigoProducto) do
                read(mae, infoM);
            while(infoM.codigoProducto = min.codigoProducto) do
                begin
                    if(min.cantPedida > infoM.stockActual) then
                        begin
                            writeln('No se pudo satisfacer el pedido por falta de ', min.cantPedida - infoM.stockActual, ' productos');
                            infoM.stockActual:= 0;
                        end
                    else
                        infoM.stockActual:= infoM.stockActual - min.cantPedida;
                    minimo(det1, det2, det3, infoDet1, infoDet2, infoDet3, min);
                end;
            if(infoM.stockActual < infoM.stockMinimo) then
                writeln('Categoria ', infoM.categoria);
            seek(mae, filepos(mae)-1);
            write(mae, infoM);
        end;
    close(mae);
    close(det1);
    close(det2);
    close(det3);
end;
procedure crearMaestro(var mae: arcMaestro; var carga: text);
var
    p: infoMaestro;
begin
    reset(carga);
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    while(not eof(carga)) do
        begin
            readln(carga, p.codigoProducto, p.codigoBarras, p.categoria, p.stockActual, p.stockMinimo, p.nombre);
            readln(carga, p.descripcion);
            write(mae, p);
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: arcDetalle; var carga: text; nombre: string);
var
    p: infoDetalle;
begin
    reset(carga);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            readln(carga, p.codigoProducto, p.cantPedida, p.descripcion);
            write(det, p);
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure imprimirMaestro(var mae: arcMaestro);
var
    p: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do 
        begin
            read(mae, p);
            writeln(p.codigoProducto, ' StockActual=', p.stockActual);
        end;
    close(mae);
end;
var
    det1, det2, det3: arcDetalle;
    mae: arcMaestro;
    txt1, txt2, txt3, txt4: text;
begin
    assign(txt1, 'maestro.txt');
    assign(txt2, 'detalle1.txt');
    assign(txt3, 'detalle2.txt');
    assign(txt4, 'detalle3.txt');
    crearMaestro(mae, txt1);
    crearDetalle(det1, txt2, 'Detalle1');
    crearDetalle(det2, txt3, 'Detalle2');
    crearDetalle(det3, txt4, 'Detalle3');
    actualizarMaestro(mae, det1, det2, det3);
    imprimirMaestro(mae);
end.