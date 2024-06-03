program parcialTema1;
type
    info = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        precioCompra: real;
        precioVenta: real;
        ubicacion: string;
    end;
    archivo = file of info;
procedure leerProducto(var p: info);
begin
    writeln('Ingrese el codigo del producto');
    readln(p.codigo);
    writeln('Ingrese el nombre del producto');
    readln(p.nombre);
    writeln('Ingrese la descripcion del producto');
    readln(p.descripcion);
    writeln('Ingrese el precio de compra del producto');
    readln(p.precioCompra);
    writeln('Ingrese el precio de venta del producto');
    readln(p.precioVenta);
    writeln('Ingrese la ubicacion del producto');
    readln(p.ubicacion);
end;
function ExisteProducto(var a: archivo; codigo: integer): boolean;
var
    ok: boolean;
    p: info;
begin
    reset(a);
    ok:= false;
    while((not eof (a)) and (not ok)) do
        begin
            read(a, p);
            if(p.codigo = codigo) then
                ok:= true;
        end;
    close(a);
    ExisteProducto:= ok;
end;
procedure agregarProducto(var a: archivo);
var
    p, cabecera: info;
begin
    leerProducto(p);
    if(not ExisteProducto(a, p.codigo)) then
        begin
            reset(a);
            read(a, cabecera);
            if(cabecera.codigo = 0) then
                begin
                    seek(a, filesize(a));
                    write(a, p);
                end
            else
                begin
                    seek(a, cabecera.codigo * -1);
                    read(a, cabecera);
                    seek(a, filepos(a)-1);
                    write(a, p);
                    seek(a, 0);
                    write(a, cabecera);
                end;
            close(a);
        end
    else
        writeln('El producto ingresado ya existe');
end;
procedure eliminarProducto(var a: archivo);
var
    codigo: integer;
    cabecera, p: info;
begin
    writeln('Ingrese un codigo de producto');
    readln(codigo);
    if(ExisteProducto(a, codigo)) then
        begin
            reset(a);
            read(a, cabecera);
            read(a, p);
            while(p.codigo <> codigo) do
                read(a, p);
            seek(a, filepos(a)-1);
            write(a, cabecera);
            cabecera.codigo:= (filepos(a)-1)*-1;
            seek(a, 0);
            write(a, cabecera);
            close(a);
        end
    else
        writeln('El codigo de producto ingresado no existe');
end;
procedure crearArchivo(var a: archivo);
var
    p: info;
    i: integer;
begin
    assign(a, 'ArchivoMaestro');
    rewrite(a);
    p.codigo:= 0;
    write(a, p);
    for i:= 1 to 2 do
        begin
            leerProducto(p);
            write(a, p);
        end;
    close(a);
end;
procedure imprimirArchivo(var a: archivo);
var
    p: info;
begin
    reset(a);
    while(not eof(a)) do
        begin
            read(a, p);
            write(p.codigo, ' ~ ');
        end;
end;
var
    a: archivo;
begin
    crearArchivo(a);
    writeln('ALTAS');
    agregarProducto(a);
    imprimirArchivo(a);
    writeln();
    writeln('BAJAS');
    eliminarProducto(a);
    writeln();
    imprimirArchivo(a);
    writeln();
    writeln('ALTAS');
    agregarProducto(a);
    imprimirArchivo(a);
end.