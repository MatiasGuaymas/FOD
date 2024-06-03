program parcial3;
const
    valoralto = 9999;
    DF = 2;
    //DF = 25;
type
    subRango = 1..DF;
    infoDetalle = record
        num: integer;
        codigo: integer;
        cant: integer;
    end;
    infoMaestro = record    
        codigo: integer;
        descripcion: string;
        cantActual: integer;
        stockMin: integer;
        precio: real;
    end;
    arcMaestro = file of infoMaestro;
    arcDetalle = file of infoDetalle;
    vecDetalles = array[subRango] of arcDetalle;
    vecRegistros = array[subRango] of infoDetalle;
procedure crearMaestro(var mae: arcMaestro);
var
    txt: text;
    infoMae: infoMaestro;
begin
    assign(txt, 'maestro.txt');
    reset(txt);
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with infoMae do
                begin
                    readln(txt, codigo, cantActual, stockMin, precio, descripcion);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
procedure crearUnSoloDetalle(var det: arcDetalle);
var
    carga: text;
    nombre: string;
    infoDet: infoDetalle;
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
            with infoDet do
                begin
                    readln(carga, num, codigo, cant);
                    write(det, infoDet);
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
procedure leer(var det: arcDetalle; var r: infoDetalle);
begin
    if(not eof(det)) then
        read(det, r)
    else
        r.codigo:= valoralto;
end;
procedure minimo(var vecD: vecDetalles; var vecR: vecRegistros; var min: infoDetalle);
var
    i, pos: subRango;
begin
    min.codigo:= valoralto;
    for i:= 1 to DF do
        if(vecR[i].codigo < min.codigo) then
            begin
                min:= vecR[i];
                pos:= i;
            end;
    if(min.codigo <> valoralto) then
        leer(vecD[pos], vecR[pos]);
end;
procedure imprimirMaestro(var mae: arcMaestro);
var
    info: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, info);
            writeln(info.codigo, ' CantActual=', info.cantActual);
        end;
    close(mae);
end;
procedure actualizarMaestro(var mae: arcMaestro; var vecDet: vecDetalles);
var
    monto, montoTotal: real;
    vecReg: vecRegistros;
    comprados: integer;
    infoMae: infoMaestro;
    min: infoDetalle;
    i: subRango;
begin
    montoTotal:= 0;
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
            monto:= 0;
            comprados:= 0;
            while(infoMae.codigo = min.codigo) do
                begin
                    if(min.cant > infoMae.cantActual) then 
                        begin
                            comprados:= comprados + infoMae.cantActual;
                            infoMae.cantActual:= 0;
                        end
                    else
                        begin
                            comprados:= comprados + min.cant;
                            infoMae.cantActual:= infoMae.cantActual - min.cant;
                        end;
                    minimo(vecDet, vecReg, min);
                end;
            monto:= infoMae.precio * comprados;
            if(infoMae.cantActual < infoMae.stockMin) then
                writeln(infoMae.codigo, ' CantActual=', infoMae.cantActual);
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
            montoTotal:= montoTotal + monto;
            writeln(infoMae.codigo, ' Desc=', infoMae.descripcion, ' Monto=', monto);
        end;
    close(mae);
    for i:= 1 to DF do
        close(vecDet[i]);
    writeln('El monto total recaudado es: ', montoTotal:0:2);
end;
var
    mae: arcMaestro;
    vecDet: vecDetalles;
begin
    crearMaestro(mae);
    crearDetalles(vecDet);
    actualizarMaestro(mae, vecDet);
    imprimirMaestro(mae);
end.