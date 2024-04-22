{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ejercicio7;
const
    valoralto = 9999;
type
    aves = record
        codigo: integer;
        nombre: string;
        familia: string;
        descripcion: string;
        zona: string;
    end;
    archivo = file of aves;
procedure leerAve(var a: aves);
begin
    writeln('Ingrese el codigo de especie');
    readln(a.codigo);
    if(a.codigo <> -1) then
        begin
            writeln('Ingrese el nombre de la especie');
            readln(a.nombre);
            writeln('Ingrese la familia de ave');
            readln(a.familia);
            writeln('Ingrese la descripcion de la especie');
            readln(a.descripcion);
            writeln('Ingrese la zona geografica de la especie');
            readln(a.zona);
        end;
end;
procedure crearArchivo(var arc: archivo);
var
    a: aves;
begin
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    leerAve(a);
    while(a.codigo <> -1) do
        begin
            write(arc, a);
            leerAve(a);
        end;
    close(arc);
end;
procedure imprimirArchivo(var arc: archivo);
var
    a: aves;
begin
    reset(arc);
    while (not eof(arc)) do
        begin
            read(arc, a);
            writeln('Codigo=', a.codigo, ' Nombre=', a.nombre);
        end;
    close(arc);
end;
procedure borradoLogico(var arc: archivo);
var
    a: aves;
    cod: integer;
    ok: boolean;
begin
    reset(arc);
    writeln('Ingrese el codigo de especie a borrar');
    readln(cod);
    while(cod <> valoralto) do
        begin
            ok:= false;
            while(not eof(arc)) and (not ok) do
                begin
                    read(arc, a);
                    if(a.codigo = cod) then
                        ok:= true;
                end;
            if(ok) then
                begin
                    writeln('Se elimino la especie con codigo ', cod);
                    a.codigo:= -1;
                    seek(arc, filepos(arc)-1);
                    write(arc, a)
                end
            else
                writeln('No se encontro la especie con codigo ', cod);
            writeln('Ingrese el codigo de especie a borrar');
            readln(cod);
        end;
    close(arc);
end;
procedure leer(var arc: archivo; var a: aves);
begin
    if(not eof(arc)) then
        read(arc, a)
    else
        a.codigo:= valoralto;
end;
procedure compactarArchivo(var arc: archivo);
var
    a: aves;
    pos: integer;
begin
    reset(arc);
    leer(arc, a);
    while(a.codigo <> valoralto) do
        begin
            if(a.codigo < 0) then
                begin
                    pos:= (filepos(arc)-1);
                    seek(arc, filesize(arc)-1);
                    read(arc, a);
                    if(filepos(arc)-1 <> 0) then
                        while(a.codigo < 0) do //Puede pasar que los ultimos tambien se tengan que borrar, por ende ya los voy eliminando, una vez que encontre uno que no se tenga que borrar salgo del while
                            begin
                                seek(arc, filesize(arc)-1);
                                truncate(arc);
                                seek(arc, filesize(arc)-1);
                                read(arc, a);
                            end;
                    seek(arc, pos);
                    write(arc, a);
                    seek(arc, filesize(arc)-1);
                    truncate(arc);
                    seek(arc, pos);
                end;
            leer(arc, a);
        end;
    close(arc);
end;
var
    arc: archivo;
begin
    crearArchivo(arc);
    writeln('Archivo original');
    imprimirArchivo(arc);
    borradoLogico(arc);
    compactarArchivo(arc);
    writeln('Archivo compactado');
    imprimirArchivo(arc);
end.