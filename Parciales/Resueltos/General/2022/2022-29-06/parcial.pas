program parcial;
type
    infoArchivo = record
        nombre: string;
        descripcion: string;
        cantHabitantes: integer;
        mts2: real;
        anio: integer;
    end;
    archivo = file of infoArchivo;
function ExisteMunicipio(var a: archivo; nombre: string): boolean;
var
    ok: boolean;
    info: infoArchivo;
begin
    ok:= false;
    reset(a);
    while(not eof(a) and not ok) do
        begin
            read(a, info);
            if(info.nombre = nombre) then
                ok:= true;
        end;
    close(a);
    ExisteMunicipio:= ok;
end;
procedure leerMunicipio(var m: infoArchivo);
begin
    writeln('Ingrese el nombre del municipio');
    readln(m.nombre);
    if(m.nombre <> 'ZZZ') then
        begin
            writeln('Ingrese la descripcion del municipio');
            readln(m.descripcion);
            writeln('Ingrese la cantidad de habitantes del municipio');
            readln(m.cantHabitantes);
            writeln('Ingrese la cantidad de mts2 del municipio');
            readln(m.mts2);
            writeln('Ingrese el anio de creacion del municipio');
            readln(m.anio);
        end;
end;
procedure AltaMunicipio(var a: archivo);
var
    m, cabecera: infoArchivo;
begin
    leerMunicipio(m);
    if(not ExisteMunicipio(a, m.nombre)) then
        begin
            reset(a);
            read(a, cabecera);
            if(cabecera.cantHabitantes = 0) then
                begin
                    seek(a, filesize(a));
                    write(a, m);
                end
            else
                begin
                    seek(a, cabecera.cantHabitantes * -1);
                    read(a, cabecera);
                    seek(a, filepos(a)-1);
                    write(a, m);
                    seek(a, 0);
                    write(a, cabecera);
                end;
            close(a);
        end
    else
        writeln('Ya existe el municipio en el archivo');
end;
procedure BajaMunicipio(var a: archivo);
var
    info, cabecera: infoArchivo;
    nombre: string;
begin
    writeln('Ingrese un nombre a borrar del archivo');
    readln(nombre);
    if(ExisteMunicipio(a, nombre)) then
        begin
            reset(a);
            read(a, cabecera);
            read(a, info);
            while(info.nombre <> nombre) do
                read(a, info);
            seek(a, filepos(a)-1);
            write(a, cabecera);
            info.cantHabitantes:= (filepos(a)-1)*-1;
            seek(a, 0);
            write(a, info);
            close(a);
        end
    else
        writeln('Municipio no existe');
end;
procedure cargarArchivo(var a: archivo);
var
    m: infoArchivo;
begin
    assign(a, 'ArchivoMaestro');
    rewrite(a);
    m.cantHabitantes:= 0;
    write(a, m);
    leerMunicipio(m);
    while(m.nombre <> 'ZZZ') do
        begin
            write(a, m);
            leerMunicipio(m);
        end;
    close(a);
end;
procedure imprimirArchivo(var a: archivo);
var
    m: infoArchivo;
begin
    reset(a);
    while(not eof(a)) do
        begin
            read(a, m);
            write(m.cantHabitantes, ' ~ ');
        end;
    close(a);
end;
var
    a: archivo;
begin
    cargarArchivo(a);
    AltaMunicipio(a);
    imprimirArchivo(a);
    writeln();
    BajaMunicipio(a);
    imprimirArchivo(a);
end.