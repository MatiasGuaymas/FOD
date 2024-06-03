program parcial2;
type
    tProducto = record
        codigo: integer;
        nombre: string[50];
        presentacion: string[100];
    end;
    tArchProductos = file of tProducto;
procedure agregar(var a: tArchProductos; producto: tProducto);
var 
    cabecera: tProducto;
begin
    reset(a);
    read(a, cabecera);
    if(cabecera.codigo = 0) then
        begin
            seek(a, filesize(a));
            write(a, producto);
        end
    else
        begin
            seek(a, cabecera.codigo * -1);
            read(a, cabecera);
            seek(a, filepos(a)-1);
            write(a, producto);
            seek(a, 0);
            write(a, cabecera);
        end;
    close(a);
end;
function ExisteProducto(var a: tArchProductos; codigo: integer): boolean;
var
    ok: boolean;
    p: tProducto;
begin
    ok:= false;
    reset(a);
    while((not eof(a)) and (not ok)) do
        begin
            read(a, p);
            if(p.codigo = codigo) then
                ok:= true
        end;
    close(a);
    ExisteProducto:= ok;
end;
procedure eliminar(var a: tArchProductos; producto: tProducto);
var
    cabecera, p: tProducto;
begin
    if(ExisteProducto(a, producto.codigo)) then
        begin
            reset(a);
            read(a, cabecera);
            read(a, p);
            while(p.codigo <> producto.codigo) do
                read(a, p);
            seek(a, filepos(a)-1);
            write(a, cabecera);
            p.codigo:= (filepos(a)-1)*-1;
            seek(a, 0);
            write(a, p);
            close(a);
        end;
end;
procedure crearArchivo(var a: tArchProductos);
var
    p: tProducto;
begin
    assign(a, 'ArchivoMaestro');
    rewrite(a);
    p.codigo:= 0;
    write(a, p);
    readln(p.codigo);
    while(p.codigo <> -1) do
        begin
            readln(p.nombre);
            readln(p.presentacion);
            write(a, p);
            readln(p.codigo);
        end;
    close(a);
end;
procedure imprimirArchivo(var a: tArchProductos);
var
    p: tProducto;
begin
    reset(a);
    while(not eof(a)) do
        begin
            read(a, p);
            write(p.codigo, ' ~ ');
        end;
    close(a);
end;
var
    a: tArchProductos;
    p1, p2: tProducto;
begin
    crearArchivo(a);
    p1.codigo:= 33;
    p2.codigo:= 44;
    agregar(a, p1);
    agregar(a, p2);
    imprimirArchivo(a);
    writeln();
    eliminar(a, p1);
    imprimirArchivo(a);
end.