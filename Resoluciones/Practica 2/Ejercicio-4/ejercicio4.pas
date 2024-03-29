{4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ejercicio4;
const
    valoralto = 'ZZZ';
type
    infoMaestro = record
        nombre: string;
        alfabetizados: integer;
        encuestados: integer;
    end;
    infoDetalle = record
        nombre: string;
        codigo: integer;
        alfabetizados: integer;
        encuestados: integer;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
procedure leer(var det: detalle; var dato: infoDetalle);
begin
    if(not eof(det)) then
        read(det, dato)
    else
        dato.nombre:= valoralto;
end;
procedure minimo(var det1, det2: detalle; var r1, r2, min: infoDetalle);
begin
    if(r1.nombre <= r2.nombre) then
        begin
            min:= r1;
            leer(det1, r1);
        end
    else
        begin
            min:= r2;
            leer(det2, r2);
        end;
end;
procedure actualizarMaestro(var mae: maestro; var det1, det2: detalle);
var
    infoDet1, infoDet2, min: infoDetalle;
    infoMae: infoMaestro;
begin
    reset(mae);
    reset(det1);
    reset(det2);
    leer(det1, infoDet1);
    leer(det2, infoDet2);
    minimo(det1, det2, infoDet1, infoDet2, min);
    while(min.nombre <> valoralto) do
        begin
            read(mae, infoMae);
            while(infoMae.nombre <> min.nombre) do
                read(mae,infoMae);
            while(infoMae.nombre = min.nombre) do
                begin
                    infoMae.alfabetizados:= infoMae.alfabetizados + min.alfabetizados;
                    infoMae.encuestados:= infoMae.encuestados + min.encuestados;
                    minimo(det1, det2, infoDet1, infoDet2, min);
                end;
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
        end;
    close(mae);
    close(det1);
    close(det2);
end;
procedure crearMaestro(var mae: maestro; var carga: text);
var
    nombre: string;
    infoMae: infoMaestro;
begin
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, alfabetizados, encuestados, nombre);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: detalle; var carga: text);
var
    nombre: string;
    infoDet: infoDetalle;
begin
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with infoDet do
                begin
                    readln(carga, codigo, alfabetizados, encuestados, nombre);
                    write(det, infoDet);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure imprimirMaestro(var mae: maestro);
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            with infoMae do
                writeln('Nombre=', nombre, ' Alfabetizados=', alfabetizados, ' Encuestados=', encuestados);
        end;
    close(mae);
end;
var
    mae: maestro;
    det1, det2: detalle;
    cargaDet1, cargaDet2, cargaMae: text;
begin
    assign(cargaMae, 'maestro.txt');
    assign(cargaDet1, 'detalle1.txt');
    assign(cargaDet2, 'detalle2.txt');
    crearMaestro(mae, cargaMae);
    crearDetalle(det1, cargaDet1);
    crearDetalle(det2, cargaDet2);
    writeln('Maestro original:');
    imprimirMaestro(mae);
    writeln('Actualizacion de maestro:');
    actualizarMaestro(mae, det1, det2);
    imprimirMaestro(mae);
end.