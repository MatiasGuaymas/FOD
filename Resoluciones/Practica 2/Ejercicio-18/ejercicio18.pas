{18. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única. Tenga
en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

program ejercicio18;
const
    valoralto = 9999;
    DF = 1;
    //DF = 50;
type
    subrango = 1..DF;
    infoDetalleNac = record
        partida: integer;
        nombre: string;
        apellido: string;
        direccion: string;
        matriculaNacimiento: string;
        nombreApellidoMadre: string;
        dniMadre: integer;
        nombreApellidoPadre: string;
        dniPadre: integer;
    end;
    infoDetalleFall = record
        partida: integer;
        dni: integer;
        nombre: string;
        apellido: string;
        matriculaDeceso: string;
        fechaHora: string;
        lugar: string;
    end;
    infoMaestro = record
        partida: integer;
        nombre: string;    
        apellido: string;
        direccion: string;
        matriculaNacimiento: string;
        nombreApellidoMadre: string;
        dniMadre: integer;
        nombreApellidoPadre: string;
        dniPadre: integer;
        fallecio: boolean;
        matriculaFallecimiento: string;
        fechaHora: string;
        lugar: string;
    end;
    detalleNac = file of infoDetalleNac;
    detalleFall = file of infoDetalleFall;
    maestro = file of infoMaestro;
    vecDetallesNac = array[subrango] of detalleNac;
    vecDetallesFall = array[subrango] of detalleFall;
    vecRegistrosNac = array[subrango] of infoDetalleNac;
    vecRegistrosFall = array[subrango] of infoDetalleFall;
procedure leerPersona1(var infoDetalle: infoDetalleNac);
begin
    writeln('Ingrese el numero de partida:');
    readln(infoDetalle.partida);
    if(infoDetalle.partida <> -1) then
        begin
            writeln('Ingrese el nombre del nacido:');
            readln(infoDetalle.nombre);
            writeln('Ingrese el apellido del nacido:');
            readln(infoDetalle.apellido);
            writeln('Ingrese la direccion:');
            readln(infoDetalle.direccion);
            writeln('Ingrese la matricula de nacimiento:');
            readln(infoDetalle.matriculaNacimiento);
            writeln('Ingrese el nombre y apellido de la madre:');
            readln(infoDetalle.nombreApellidoMadre);
            writeln('Ingrese el DNI de la madre:');
            readln(infoDetalle.dniMadre);
            writeln('Ingrese el nombre y apellido del padre:');
            readln(infoDetalle.nombreApellidoPadre);
            writeln('Ingrese el DNI del padre:');
            readln(infoDetalle.dniPadre);
        end;
end;
procedure leerPersona2(var infoDetalle: infoDetalleFall);
begin
    writeln('Ingrese el numero de partida:');
    readln(infoDetalle.partida);
    if(infoDetalle.partida <> -1) then
        begin
            writeln('Ingrese el dni del fallecido:');
            readln(infoDetalle.dni);
            writeln('Ingrese el nombre del fallecido:');
            readln(infoDetalle.nombre);
            writeln('Ingrese el apellido del fallecido:');
            readln(infoDetalle.apellido);
            writeln('Ingrese la matricula de deceso:');
            readln(infoDetalle.matriculaDeceso);
            writeln('Ingrese la fecha y hora de deceso:');
            readln(infoDetalle.fechaHora);
            writeln('Ingrese el lugar de deceso:');
            readln(infoDetalle.lugar);
        end;
end;
procedure crearUnSoloDetalle1(var det: detalleNac);
var
    infoDet: infoDetalleNac;
    nombre: string;
begin
    writeln('Ingrese el nombre de texto del archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    leerPersona1(infoDet);
    while(infoDet.partida <> -1) do
        begin
            write(det, infoDet);
            leerPersona1(infoDet);
        end;
    writeln('Archivo detalle binario creado');
    close(det);
end;
procedure crearUnSoloDetalle2(var det: detalleFall);
var
    infoDet: infoDetalleFall;
    nombre: string;
begin
    writeln('Ingrese el nombre de texto del archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    leerPersona2(infoDet);
    while(infoDet.partida <> -1) do
        begin
            write(det, infoDet);
            leerPersona2(infoDet);
        end;
    writeln('Archivo detalle binario creado');
    close(det);
end;
procedure crearDetalles1(var vec: vecDetallesNac);
var
    i: subrango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle1(vec[i]);
end;
procedure crearDetalles2(var vec: vecDetallesFall);
var
    i: subrango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle2(vec[i]);
end;
procedure leerFall(var det: detalleFall; var infoDet: infoDetalleFall);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.partida:= valoralto;
end;
procedure leerNac(var det: detalleNac; var infoDet: infoDetalleNac);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.partida:= valoralto;
end;
procedure minimoFall(var vecDet: vecDetallesFall; var vecReg: vecRegistrosFall; var min: infoDetalleFall);
var
    i, pos: subrango;
begin
    min.partida:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].partida < min.partida) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.partida <> valoralto) then
        leerFall(vecDet[pos], vecReg[pos]);
end;
procedure minimoNac(var vecDet: vecDetallesNac; var vecReg: vecRegistrosNac; var min: infoDetalleNac);
var
    i, pos: subrango;
begin
    min.partida:= valoralto;
    for i:= 1 to DF do
        if(vecReg[i].partida < min.partida) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.partida <> valoralto) then
        leerNac(vecDet[pos], vecReg[pos]);
end;
procedure merge(var mae: maestro; var vecDetFall: vecDetallesFall; var vecDetNac: vecDetallesNac);
var
    vecRegNac: vecRegistrosNac;
    vecRegFall: vecRegistrosFall;
    minNacido: infoDetalleNac;
    minFallecido: infoDetalleFall;
    actual: infoMaestro;
    i: subrango;
begin
    for i:= 1 to DF do
        begin
            reset(vecDetFall[i]);
            reset(vecDetNac[i]);
            leerFall(vecDetFall[i], vecRegFall[i]);
            leerNac(vecDetNac[i], vecRegNac[i]);
        end;
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    minimoFall(vecDetFall, vecRegFall, minFallecido);
    minimoNac(vecDetNac, vecRegNac, minNacido);
    while(minNacido.partida <> valoralto) do
        begin
            actual.partida:= minNacido.partida;
            actual.nombre:= minNacido.nombre; 
            actual.apellido:= minNacido.apellido;
            actual.direccion:= minNacido.direccion;
            actual.matriculaNacimiento:= minNacido.matriculaNacimiento;
            actual.nombreApellidoMadre:= minNacido.nombreApellidoMadre;
            actual.dniMadre:= minNacido.dniMadre;
            actual.nombreApellidoPadre:= minNacido.nombreApellidoPadre;
            actual.dniPadre:= minNacido.dniPadre;
            if(minNacido.partida = minFallecido.partida) then
                begin
                    actual.fallecio:= true;
                    actual.matriculaFallecimiento:= minFallecido.matriculaDeceso;
                    actual.fechaHora:= minFallecido.fechaHora;
                    actual.lugar:= minFallecido.lugar;
                end
            else
                actual.fallecio:= false;
            write(mae, actual);
            minimoNac(vecDetNac, vecRegNac, minNacido);
            if(actual.fallecio) then
                minimoFall(vecDetFall, vecRegFall, minFallecido);
        end;
    for i:= 1 to DF do
        begin
            close(vecDetFall[i]);
            close(vecDetNac[i]);
        end;
    close(mae);
end;
procedure imprimirMaestro(var mae: maestro); 
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln();
            write('Partida=', infoMae.partida, ' Nombre=', infoMae.nombre, ' Apellido=', infoMae.apellido, ' ');
            if(infoMae.fallecio) then
                write(' Matricula=', infoMae.matriculaFallecimiento, ' Fecha y Hora=', infoMae.fechaHora, ' Lugar=', infoMae.lugar);
        end;
    close(mae);
end;
procedure exportarTexto(var mae: maestro);
var
    txt: text;
    infoMae: infoMaestro;
begin
    reset(mae);
    assign(txt, 'personas.txt');
    rewrite(txt);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            with infoMae do
                begin
                    writeln(txt, 'Partida=', partida, ' Nombre=', nombre, ' Apellido=', apellido, ' Direccion=', direccion, ' MatNacimiento=', matriculaNacimiento, ' NAMadre=', nombreApellidoMadre, ' DNIMadre=', dniMadre, ' NAPadre=', nombreApellidoPadre, ' DNIPadre=', dniPadre);
                    if(fallecio) then
                        writeln(txt, 'Fallecido', ' MatFallecimiento=', matriculaFallecimiento, ' FechaHora=', fechaHora, ' Lugar=', lugar);
                end;
        end;
    close(mae);
    close(txt);
end;
var
    vecDetNac: vecDetallesNac;
    vecDetFall: vecDetallesFall;
    mae: maestro;
begin
    crearDetalles1(vecDetNac);
    crearDetalles2(vecDetFall);
    merge(mae, vecDetFall, vecDetNac);
    imprimirMaestro(mae);
    exportarTexto(mae);
end.