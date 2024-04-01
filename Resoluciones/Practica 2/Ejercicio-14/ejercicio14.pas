{14. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}

program ejercicio14;
const
    DF = 3;
    //DF = 10;
    valoralto = 9999;
type
    subRango = 1..DF;
    infoMaestro = record
        provincia: integer;
        nombreProvincia: string;
        localidad: integer;
        nombreLocalidad: string;
        sinLuz: integer;
        sinGas: integer;
        chapa: integer;
        sinAgua: integer;
        sinSanitarios: integer;
    end;
    infoDetalle = record
        provincia: integer;
        localidad: integer;
        conLuz: integer;
        construidas: integer;
        conAgua: integer;
        conGas: integer;
        sanitarios: integer;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vecDetalles = array [subRango] of detalle;
    vecRegistros = array [subRango] of infoDetalle;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    infoMae: infoMaestro;
    nombre: string;
begin
    assign(txt, 'provincias.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with infoMae do
                begin
                    readln(txt, provincia, nombreProvincia);
                    readln(txt, localidad, sinLuz, sinGas, chapa, sinAgua, sinSanitarios, nombreLocalidad);
                    write(mae, infoMae);
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
                    readln(carga, provincia, localidad, conLuz, construidas, conAgua, conGas, sanitarios);
                    write(det, infoDet);
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
procedure leer(var det: detalle; var infoDet: infoDetalle);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.provincia := valoralto;
end;
procedure minimo(var vec: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, pos: subrango;
begin
    min.provincia:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].provincia < min.provincia) or ((vecReg[i].provincia = min.provincia) and (vecReg[i].localidad < min.localidad)) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.provincia <> valoralto) then
        leer(vec[pos], vecReg[pos]);
end;
procedure actualizarMaestro(var mae: maestro; var vec: vecDetalles);
var
    min: infoDetalle;
    infoMae: infoMaestro;
    vecReg: vecRegistros;
    i: subrango;
    aux, cantLocalidad: integer;
begin
    cantLocalidad:= 0;
    reset(mae);
    for i:= 1 to DF do
        begin
            reset(vec[i]);
            leer(vec[i], vecReg[i]);
        end;
    minimo(vec, vecReg, min);
    read(mae, infoMae);
    while(min.provincia <> valoralto) do
        begin
            while(min.provincia <> infoMae.provincia) do
                read(mae, infoMae);
            while(min.provincia = infoMae.provincia) do
                begin
                    while(min.localidad <> infoMae.localidad) do
                        read(mae, infoMae);
                    while(min.provincia = infoMae.provincia) and (infoMae.localidad = min.localidad) do
                        begin
                            infoMae.sinLuz:= infoMae.sinLuz - min.conLuz;
                            infoMae.sinAgua:= infoMae.sinAgua - min.conAgua;
                            infoMae.sinGas:= infoMae.sinGas - min.conGas;
                            infoMae.sinSanitarios:= infoMae.sinSanitarios - min.sanitarios;
                            infoMae.chapa:= infoMae.chapa - min.construidas;
                            minimo(vec, vecReg, min);
                        end;
                    if(infoMae.chapa = 0) then
                        cantLocalidad:= cantLocalidad + 1;
                    seek(mae, filepos(mae)-1);
                    write(mae, infoMae);
                end;
        end;
    writeln('Cantidad de localidades sin viviendas de chapa: ', cantLocalidad);
    close(mae);
    for i:= 1 to DF do
        close(vec[i]);
end;
procedure imprimirMaestro(var mae: maestro);
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln('CodProv=', infoMae.provincia, ' CodLocalidad=', infoMae.localidad, ' SinLuz=', infoMae.sinLuz, ' SinGas=', infoMae.sinGas, ' CantChapas=', infoMae.chapa, ' SinAgua=', infoMae.sinAgua, ' SinSanatorios=', infoMae.sinSanitarios);
        end;
    close(mae);
end;
var
    vecDet: vecDetalles;
    mae: maestro;
begin
    crearMaestro(mae);
    crearDetalles(vecDet);
    actualizarMaestro(mae, vecDet);
    imprimirMaestro(mae);
end.