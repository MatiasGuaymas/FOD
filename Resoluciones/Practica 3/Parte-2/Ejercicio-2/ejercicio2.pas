{2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad              Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.}

program ejercicio2;
type
    localidad = record
        codigo: integer;
        mesa: integer;
        cant: integer;
    end;
    archivo = file of localidad;
procedure corteDeControl(var arc: archivo; var arcAux: archivo; var cantTotal: integer);
var
    l, aux: localidad;
    ok: boolean;
begin
    reset(arc);
    assign(arcAux, 'ArchivoAuxiliar');
    rewrite(arcAux);
    cantTotal:= 0;
    while(not eof(arc)) do
        begin
            read(arc, l);
            ok:= false;
            seek(arcAux, 0);
            while(not eof(arcAux) and (not ok)) do
                begin
                    read(arcAux, aux);
                    if(aux.codigo = l.codigo) then
                        ok:= true;
                end;
            if(ok) then
                begin
                    aux.cant:= aux.cant + l.cant;
                    seek(arcAux, filepos(arcAux)-1);
                    write(arcAux, aux);
                end
            else
                write(arcAux, l);
            cantTotal:= cantTotal + l.cant;
        end;
    close(arc);
    close(arcAux);
end;
procedure cargarArchivo(var arc: archivo);
var
    txt: text;
    l: localidad;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    while(not eof(txt)) do
        begin
            with l do
                begin
                    readln(txt, codigo, mesa, cant);
                    write(arc, l);
                end;
        end;
    writeln('Archivo maestro generado');
    close(arc);
    close(txt);
end;
procedure imprimirArchivo(var arc: archivo; cantTotal: integer);
var
    l: localidad;
begin
    reset(arc);
    writeln('Codigo de Localidad          Total de Votos');
    while(not eof(arc)) do
        begin
            read(arc, l);
            writeln(l.codigo, '                                ', l.cant);
        end;
    writeln('Total General de Votos: ', cantTotal);
    close(arc);
end;
var
    arc, arcAux: archivo;
    cantTotal: integer;
begin
    cargarArchivo(arc);
    corteDeControl(arc, arcAux, cantTotal);
    imprimirArchivo(arcAux, cantTotal);
end.