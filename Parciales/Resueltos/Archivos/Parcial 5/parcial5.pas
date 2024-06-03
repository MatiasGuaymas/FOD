program parcial5;
type
    infoMaestro = record
        codigo: integer;
        descripcion: string;
        colores: string;
        tipo: string;
        stock: integer;
        precioUnitario: real;
    end;
    arcMaestro = file of infoMaestro;
    arcDetalle = file of integer;
procedure bajasLogicas(var mae: arcMaestro; var det: arcDetalle);
var
    infoMae: infoMaestro;
    codigo: integer;
begin
    reset(mae);
    reset(det);
    while(not eof(det)) do
        begin
            read(det, codigo);
            seek(mae, 0);
            read(mae, infoMae);
            while(infoMae.codigo <> codigo) do
                read(mae,infoMae);
            seek(mae, filepos(mae)-1);
            infoMae.stock:= -1;
            write(mae, infoMae);
        end;
    close(mae);
    close(det);
end;
procedure compactacion(var arc: arcMaestro);
var
    a: infoMaestro;
    pos: integer;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, a);
            if(a.stock < 0) then
                begin
                    pos:= filepos(arc)-1;
                    seek(arc, filesize(arc)-1);
                    read(arc, a);
                    if(filepos(arc)-1 <> 0) then
                        while(a.stock < 0) do //Puede pasar que los ultimos tambien se tengan que borrar, por ende ya los voy eliminando, una vez que encontre uno que no se tenga que borrar salgo del while
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
        end;
    close(arc);
end;
procedure cargarArchivo(var a: arcMaestro);
var
    infoMae: infoMaestro;
begin
    assign(a, 'ArchivoMaestro');
    rewrite(a);
    writeln('Ingrese codigo');
    readln(infoMae.codigo);
    while(infoMae.codigo <> -1) do
        begin
            writeln('Ingrese stock');
            readln(infoMae.stock);
            write(a, infoMae);
            writeln('Ingrese codigo');
            readln(infoMae.codigo);
        end;
    close(a);
end;
procedure cargarDetalle(var a: arcDetalle);
var
    codigo: integer;
begin
    assign(a, 'Detalle');
    rewrite(a);
    writeln('Ingrese codigo');
    readln(codigo);
    while(codigo <> -1) do
        begin
            write(a, codigo);
            writeln('Ingrese codigo');
            readln(codigo);
        end;
    close(a);
end;
procedure imprimirArchivo(var a: arcMaestro);
var
    infoMae: infoMaestro;
begin
    reset(a);
    while(not eof(a)) do
        begin
            read(a, infoMae);
            writeln(infoMae.codigo, ' Stock=', infoMae.stock);
        end;
    close(a);
end;
var
    mae: arcMaestro;
    det: arcDetalle;
begin
    cargarArchivo(mae);
    cargarDetalle(det);
    bajasLogicas(mae, det);
    imprimirArchivo(mae);
    writeln();
    compactacion(mae);
    imprimirArchivo(mae);
end.