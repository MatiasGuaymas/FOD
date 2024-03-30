{7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de Buenos Aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

program ejercicio7;
const
    valoralto = 999;
    DF = 3;
    //DF = 10;
type
    subRango = 1..DF;
    infoDetalle = record
        localidad: integer;
        cepa: integer;
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
    end;
    infoMaestro = record
        localidad: integer;
        cepa: integer;
        cantActivos: integer;
        cantNuevos: integer;
        cantRecuperados: integer;
        cantFallecidos: integer;
        nombreCepa: string;
        nombreLocalidad: string;
    end;
    detalle = file of infoDetalle;
    maestro = file of infoMaestro;
    vecDetalles = array [subRango] of detalle;
    vecRegistros = array [subRango] of infoDetalle;
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
                    readln(carga, localidad, cepa, cantActivos, cantNuevos, cantRecuperados, cantFallecidos);
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
        infoDet.localidad := valoralto;
end;
procedure minimo(var vec: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, pos: subrango;
begin
    min.localidad := valoralto;
    for i:= 1 to DF do
        begin
            if (vecReg[i].localidad < min.localidad) or ((vecReg[i].localidad = min.localidad) and (vecReg[i].cepa < min.cepa)) then
                begin
                    min:= vecReg[i];
                    pos:= i;
                end;
        end;
    if(min.localidad <> valoralto) then
        leer(vec[pos], vecReg[pos]);
end;
procedure actualizarMaestro(var mae: maestro; var vec: vecDetalles);
var
    min: infoDetalle;
    infoMae: infoMaestro;
    vecReg: vecRegistros;
    i: subrango;
    cantCasosLocalidad, cantLocalidades: integer;
begin
    reset(mae);
    for i:= 1 to DF do
        begin
            reset(vec[i]);
            leer(vec[i], vecReg[i]);
        end;
    minimo(vec, vecReg, min);
    cantLocalidades:= 0;
    read(mae, infoMae);
    while(min.localidad <> valoralto) do
        begin
            cantCasosLocalidad:= 0;
            while(infoMae.localidad <> min.localidad) do
                read(mae, infoMae);
            while(infoMae.localidad = min.localidad) do
                begin
                    while(infoMae.cepa <> min.cepa) do
                        read(mae, infoMae);
                    while(infoMae.localidad = min.localidad) and (infoMae.cepa = min.cepa) do
                        begin
                            infoMae.cantFallecidos:= infoMae.cantFallecidos + min.cantFallecidos;
                            infoMae.cantRecuperados:= infoMae.cantRecuperados + min.cantRecuperados;
                            cantCasosLocalidad:= cantCasosLocalidad + min.cantActivos;
                            infoMae.cantActivos:= min.cantActivos;
                            infoMae.cantNuevos:= min.cantNuevos;
                            minimo(vec, vecReg, min);
                        end;
                    seek(mae, filepos(mae)-1);
                    write(mae, infoMae);
                end;
            writeln('Cantidad de casos en la localidad: ', cantCasosLocalidad);
            if(cantCasosLocalidad > 50) then
                cantLocalidades:= cantLocalidades + 1;
        end;
    close(mae);
    for i:= 1 to DF do
        close(vec[i]);
    writeln('La cantidad de localidades con mas de 50 casos activos es: ', cantLocalidades);
end;
procedure imprimirMaestro(var mae: maestro);
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln('Localidad=', infoMae.localidad, ' Cepa=', infoMae.cepa, ' CA=', infoMae.cantActivos, ' CN=', infoMae.cantNuevos, ' CR=', infoMae.cantRecuperados, ' CF=', infoMae.cantFallecidos, ' NombreCepa=', infoMae.nombreCepa, ' NombreLocalidad=', infoMae.nombreLocalidad);
        end;
    close(mae);
end;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    infoMae: infoMaestro;
    nombre: string;
begin
    assign(txt, 'casos.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with infoMae do
                begin
                    readln(txt, localidad, cepa, cantActivos, cantNuevos, cantRecuperados, cantFallecidos, nombreCepa);
                    readln(txt, nombreLocalidad);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
var
    vecDet: vecDetalles;
    mae: maestro;
begin
    crearDetalles(vecDet);
    crearMaestro(mae);
    actualizarMaestro(mae, vecDet);
    imprimirMaestro(mae);
end.