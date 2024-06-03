program parcialTema2;
type
    info = record
        dni: integer;
        nombre: string;
        apellido: string;
        edad: integer;
        domicilio: string;
        fecha: string;
    end;
    archivo = file of info;
procedure leerEmpleado(var e: info);
begin
    writeln('Ingrese el dni del empleado');
    readln(e.dni);
    writeln('Ingrese el nombre del empleado');
    readln(e.nombre);
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
    writeln('Ingrese la edad del empleado');
    readln(e.edad);
    writeln('Ingrese el domicilio del empleado');
    readln(e.domicilio);
    writeln('Ingrese la fecha de nacimiento del empleado');
    readln(e.fecha);
end;
function ExisteEmpleado(var a: archivo; dni: integer): boolean;
var
    ok: boolean;
    e: info;
begin
    reset(a);
    ok:= false;
    while((not eof (a)) and (not ok)) do
        begin
            read(a, e);
            if(e.dni = dni) then
                ok:= true;
        end;
    close(a);
    ExisteEmpleado:= ok;
end;
procedure agregarProducto(var a: archivo);
var
    e, cabecera: info;
begin
    leerEmpleado(e);
    if(not ExisteEmpleado(a, e.dni)) then
        begin
            reset(a);
            read(a, cabecera);
            if(cabecera.dni = 0) then
                begin
                    seek(a, filesize(a));
                    write(a, e);
                end
            else
                begin
                    seek(a, cabecera.dni * -1);
                    read(a, cabecera);
                    seek(a, filepos(a)-1);
                    write(a, e);
                    seek(a, 0);
                    write(a, cabecera);
                end;
            close(a);
        end
    else
        writeln('El empleado ingresado ya existe');
end;
procedure eliminarProducto(var a: archivo);
var
    dni: integer;
    cabecera, e: info;
begin
    writeln('Ingrese un dni de empleado');
    readln(dni);
    if(ExisteEmpleado(a, dni)) then
        begin
            reset(a);
            read(a, cabecera);
            read(a, e);
            while(e.dni <> dni) do
                read(a, e);
            seek(a, filepos(a)-1);
            write(a, cabecera);
            cabecera.dni:= (filepos(a)-1)*-1;
            seek(a, 0);
            write(a, cabecera);
            close(a);
        end
    else
        writeln('El dni de empleado no existe');
end;
procedure crearArchivo(var a: archivo);
var
    e: info;
    i: integer;
begin
    assign(a, 'ArchivoMaestro');
    rewrite(a);
    e.dni:= 0;
    write(a, e);
    for i:= 1 to 2 do
        begin
            leerEmpleado(e);
            write(a, e);
        end;
    close(a);
end;
procedure imprimirArchivo(var a: archivo);
var
    e: info;
begin
    reset(a);
    while(not eof(a)) do
        begin
            read(a, e);
            write(e.dni, ' ~ ');
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