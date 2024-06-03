program parcial6;
const
    //DF = 30;
    DF = 2;
    valoralto = 9999;
type
    subRango = 1..DF;
    infoDetalle = record
        codigo: integer;
        fecha: string;
        nombre: string;
        cant: integer;
        pago: string;
    end;
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
procedure minimo(var vec: vecDetalles; var vecR: vecRegistros; var min: infoDetalle);
var
    i, pos: subRango;
begin
    min.codigo:= valoralto;
    min.fecha:= 'ZZZ';
    for i:= 1 to DF do
        if((vecR[i].codigo < min.codigo) or ((vecR[i].codigo = min.codigo) and (vecR[i].fecha < min.fecha))) then
            begin
                min:= vecR[i];
                pos:= i;
            end;
    if(min.codigo <> valoralto) then
        leer(vec[pos], vecR[pos]);
end;
procedure maximo1(fecha: string; cant: integer; var fechaMax: string; var max: integer);
begin
    if(cant > max) then
        begin
            max:= cant;
            fechaMax:= fecha;
        end;
end;
procedure maximo2(codigo, cant: integer; var codMax, max: integer);
begin
    if(cant > max) then
        begin
            max:= cant;
            codMax:= codigo;
        end;
end;
procedure incisoAyByC(var v: vecDetalles; var txt: text);
var
    vecR: vecRegistros;
    min: infoDetalle;
    i: subRango;
    codigoActual, cantCodigo, cantFecha, cantContados, max1, max2, codMax: integer;
    nombreActual, fechaActual, fechaMax: string;
begin
    assign(txt, 'informe.txt');
    rewrite(txt);
    for i:= 1 to DF do
        begin
            reset(v[i]);
            leer(v[i], vecR[i]);
        end;
    minimo(v, vecR, min);
    max1:= -1;
    max2:= -1;
    while(min.codigo <> valoralto) do
        begin
            nombreActual:= min.nombre;
            codigoActual:= min.codigo;
            cantCodigo:= 0;
            while(codigoActual = min.codigo) do
                begin
                    fechaActual:= min.fecha;
                    cantFecha:= 0;
                    cantContados:= 0;
                    while((codigoActual = min.codigo) and (fechaActual = min.fecha)) do
                        begin
                            cantFecha:= cantFecha + min.cant;
                            if(min.pago = 'Contado') then
                                cantContados:= cantContados + min.cant;
                            minimo(v, vecR, min);
                        end;
                    writeln(txt, codigoActual, cantFecha, nombreActual);
                    writeln(txt, fechaActual);
                    maximo1(fechaActual, cantContados, fechaMax, max2);
                    cantCodigo:= cantCodigo + cantFecha;
                end;
            maximo2(codigoActual, cantCodigo, codMax, max1);
        end;
    for i:= 1 to DF do
        close(v[i]);
    writeln('El farmaco con mayor cantidad vendida es: ', codMax);
    writeln('La fecha en la que se produjeron mas ventas al contado es: ', fechaMax, ' con ', max2, ' pedidos al contado');
    close(txt);
end;
procedure crearUnSoloDetalle(var det: detalle);
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
                    readln(carga, codigo, cant, nombre);
                    readln(carga, fecha);
                    readln(carga, pago);
                    write(det, infoDet);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure cargarDetalles(var vec: vecDetalles);
var
    i: subRango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle(vec[i]);
end;
var
    v: vecDetalles;
    txt: text;
begin
    cargarDetalles(v);
    incisoAyByC(v, txt);
end.