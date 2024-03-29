{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.}

program ejercicio2;
const
    valoralto = 999;
type
    regAlumno = record
        codigo: integer;
        materiasSinFinal: integer;
        materiasConFinal: integer;
        nombreApellido: string;
    end;
    regDetalle = record
        codigo: integer;
        nota: integer;
    end;
    detalle = file of regDetalle;
    maestro = file of regAlumno;
procedure crearArchivoMaestro(var arc: maestro; var carga: text);
var
    nombre: string;
    alu: regAlumno;
begin
    writeln('Ingrese un nombre del archivo a crear');
    readln(nombre);
    assign(arc, nombre);
    reset(carga);
    rewrite(arc);
    while(not eof(carga)) do
        begin
            with alu do
                begin
                    readln(carga, codigo, materiasSinFinal, materiasConFinal, nombreApellido);
                    write(arc, alu);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(arc);
    close(carga);
end;
procedure crearArchivoDetalle(var arc: detalle; var carga: text);
var
    nombre: string;
    det: regDetalle;
begin
    writeln('Ingrese un nombre del archivo a crear');
    readln(nombre);
    assign(arc, nombre);
    reset(carga);
    rewrite(arc);
    while(not eof(carga)) do
        begin
            with det do
                begin
                    readln(carga, codigo, nota); //Al parecer no puedo leer booleans
                    write(arc, det);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(arc);
    close(carga);
end;
procedure leer(var det: detalle; var reg: regDetalle);
begin
    if(not eof(det)) then
        read(det, reg)
    else
        reg.codigo := valoralto;
end;
procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
    regDet: regDetalle;
    alu: regAlumno;
begin
    reset(mae);
    reset(det);
    leer(det, regDet);
    while(regDet.codigo <> valoralto) do
        begin
            read(mae, alu);
            while(regDet.codigo <> alu.codigo) do
                read(mae, alu);
            while(regDet.codigo = alu.codigo) do
                begin
                    if(regDet.nota >= 6) then
                        begin
                            alu.materiasConFinal := alu.materiasConFinal + 1;
                            alu.materiasSinFinal := alu.materiasSinFinal - 1;
                        end
                    else if(regDet.nota >= 4) then
                        begin
                            alu.materiasSinFinal := alu.materiasSinFinal + 1;
                        end;
                    leer(det, regDet);
                end;
            seek(mae, filepos(mae)-1);
            write(mae, alu);
        end;
    close(mae);
    close(det);
end;
procedure exportarTxt(var mae: maestro);
var
    txt: text;
    nombre: string;
    alu: regAlumno;
begin
    reset(mae);
    writeln('Ingrese el nombre para el archivo .txt');
    readln(nombre);
    assign(txt, nombre);
    rewrite(txt);
    while(not eof(mae)) do
        begin
            read(mae, alu);
            if(alu.materiasConFinal > alu.materiasSinFinal) then
                begin
                    with alu do
                        writeln(txt, 'Codigo=', codigo,' NombreApellido=', alu.nombreApellido ,' MateriasConFinal=', alu.materiasConFinal, ' MateriasSinFinal=', alu.materiasSinFinal);
                end;
        end;
    writeln('TXT exportado');
    close(mae);
    close(txt);
end;
procedure imprimirMaestro(var mae: maestro);
var
    alu: regAlumno;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, alu);
            writeln('Codigo=', alu.codigo, ' NombreApellido=', alu.nombreApellido ,' MateriasSinFinal=', alu.materiasSinFinal, ' MateriasConFinal=', alu.materiasConFinal);
        end;
    close(mae);
end;
procedure menu;
var
    mae: maestro;
    det: detalle;
    cargaMae, cargaDet: text;
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('1. Generar archivos binarios maestro y detalle de txt');
    writeln('2. Actualizar el archivo maestro con el archivo detalle');
    writeln('3. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados que materias sin finales aprobados');
    writeln('4. Salir del menu de opciones');
    readln(opcion);
    while(opcion <> 4) do
        begin
            case opcion of
                1: begin
                    assign(cargaMae, 'maestro.txt');
                    assign(cargaDet, 'detalle.txt');
                    crearArchivoMaestro(mae, cargaMae);
                    crearArchivoDetalle(det, cargaDet);
                end;
                2: begin
                    actualizarMaestro(mae, det);
                    writeln('Actualizacion de maestro realizada');
                    imprimirMaestro(mae);
                end;
                3: exportarTxt(mae);
                else
                    writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
                end;
            writeln('MENU DE OPCIONES');
            writeln('1. Generar archivos binarios maestro y detalle de txt');
            writeln('2. Actualizar el archivo maestro con el archivo detalle');
            writeln('3. Listar en un archivo de texto llamado stock_minimo.txt aquellos productos cuyo stock actual esta por debajo del stock minimo permitido');
            writeln('4. Salir del menu de opciones');
            readln(opcion);
        end;
end;
begin
    menu();
end.