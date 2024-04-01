{13. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}

program ejercicio13;
const
    valoralto = 'ZZZ';
type
    infoMaestro = record
        destino: string;
        fecha: string;
        hora: string;
        cant: integer;
    end;
    infoDetalle = record
        destino: string;
        fecha: string;
        hora: string;
        cant: integer;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
procedure crearMaestro(var mae: maestro);
var
    nombre: string;
    infoMae: infoMaestro;
    carga: text;
begin
    assign(carga, 'maestro.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, cant, destino);
                    readln(carga, fecha);
                    readln(carga, hora);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: detalle);
var
    nombre: string;
    infoDet: infoDetalle;
    carga: text;
begin
    writeln('Ingrese el nombre de la ruta del detalle');
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
                    readln(carga, cant, destino);
                    readln(carga, fecha);
                    readln(carga, hora);
                    write(det, infoDet);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure leer(var det: detalle; var dato: infoDetalle);
begin
    if(not eof(det)) then
        read(det, dato)
    else
        dato.destino:= valoralto;
end;
procedure minimo(var det1, det2: detalle; var r1, r2, min: infoDetalle);
begin
    if(r1.destino < r2.destino) then
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
    txt: text;
    cant: integer;
begin
    writeln('Ingrese una cantidad especifica de asientos');
    readln(cant);
    assign(txt, 'listadoVuelos.txt');
    rewrite(txt);
    reset(mae);
    reset(det1);
    reset(det2);
    leer(det1, infoDet1);
    leer(det2, infoDet2);
    minimo(det1, det2, infoDet1, infoDet2, min);
    while(min.destino <> valoralto) do
        begin
            read(mae, infoMae);
            while(infoMae.destino <> min.destino) do
                read(mae,infoMae);
            while(infoMae.destino = min.destino) do
                begin
                    while(infoMae.fecha <> min.fecha) do
                        read(mae, infoMae);
                    while(infoMae.destino = min.destino) and (infoMae.fecha = min.fecha) do
                        begin
                            while(infoMae.hora <> min.hora) do
                                read(mae, infoMae);
                            while(infoMae.destino = min.destino) and (infoMae.fecha = min.fecha) and (infoMae.hora = min.hora) do
                                begin
                                    infoMae.cant:= infoMae.cant - min.cant;
                                    minimo(det1, det2, infoDet1, infoDet2, min);
                                end;
                            if(infoMae.cant < cant) then
                                writeln(txt, infoMae.destino, ' ', infoMae.fecha, ' ', infoMae.hora);
                            seek(mae, filepos(mae)-1);
                            write(mae, infoMae);
                        end;
                end;
        end;
    close(txt);
    close(mae);
    close(det1);
    close(det2);
end;
procedure informarMaestro(var mae: maestro);
var
    infoMae: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln('Destino=', infoMae.destino, ' Fecha=', infoMae.fecha, ' Hora=', infoMae.hora, ' CantDisp=', infoMae.cant);
        end;
    close(mae);
end;
var
    mae: maestro;
    det1, det2: detalle;
begin
    crearMaestro(mae);
    crearDetalle(det1);
    crearDetalle(det2);
    actualizarMaestro(mae, det1, det2);
    informarMaestro(mae);
end.