{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
/Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente/
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}

{5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
/Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente/
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

program ejercicio4y5;
type
    reg_flor = record
        nombre: string[45];
        codigo: integer;
    end;
    tArchFlores = file of reg_flor;
procedure leerFlor(var f: reg_flor);
begin
    writeln('Ingrese el codigo de flor');
    readln(f.codigo);
    if(f.codigo <> -1) then
        begin
            writeln('Ingrese el nombre de flor');
            readln(f.nombre);
        end;
end;
procedure crearArchivo(var arc: tArchFlores);
var
    f: reg_flor;
begin
    assign(arc, 'ArchivoFlores');
    rewrite(arc);
    f.codigo:= 0;
    f.nombre:= 'Cabecera';
    write(arc, f);
    leerFlor(f);
    while(f.codigo <> -1) do
        begin
            write(arc, f);
            leerFlor(f);
        end;
    close(arc);
end;
procedure agregarFlor(var a: tArchFlores; nombre: string; codigo: integer);
var
    f, cabecera: reg_flor;
begin
    reset(a);
    read(a, cabecera);
    f.nombre:= nombre;
    f.codigo:= codigo;
    if(cabecera.codigo = 0) then
        begin
            seek(a, filesize(a));
            write(a, f);
        end
    else
        begin
            seek(a, cabecera.codigo * -1);
            read(a, cabecera);
            seek(a, filepos(a)-1);
            write(a, f);
            seek(a, 0);
            write(a, cabecera);
        end;
    writeln('Se realizo un alta de la flor con codigo ', f.codigo);
    close(a);
end;
procedure eliminarFlor(var arc: tArchFlores; flor: reg_flor);
var
    f, cabecera: reg_flor;
    ok: boolean;
begin
    ok:= false;
    reset(arc);
    read(arc, cabecera);
    while(not eof(arc) and (not ok)) do
        begin
            read(arc, f);
            if(f.codigo = flor.codigo) then
                begin
                    ok:= true;
                    seek(arc, filepos(arc)-1);
                    write(arc, cabecera);
                    cabecera.codigo:= (filepos(arc)-1) * -1;
                    seek(arc, 0);
                    write(arc, cabecera);
                end;
        end;
    close(arc);
    if(ok) then
        writeln('Se elimino la novela con codigo ', flor.codigo)
    else
        writeln('No se encontro la novela con codigo ', flor.codigo);
end;
procedure imprimirArchivo(var arc: tArchFlores);
var
    f: reg_flor;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, f);
            if(f.codigo > 0) then
                writeln('Codigo=', f.codigo, ' Nombre=', f.nombre);
        end;
    close(arc);
end;
var
    arc: tArchFlores;
    f: reg_flor;
begin
    crearArchivo(arc);
    imprimirArchivo(arc);
    agregarFlor(arc, 'Margarita', 10);
    imprimirArchivo(arc);
    f.codigo:= 10;
    eliminarFlor(arc, f);
    imprimirArchivo(arc);
    agregarFlor(arc, 'Rosa', 20);
    imprimirArchivo(arc);
end.