{7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}
program ejercicio7;
type
    novela = record
        codigo: integer;
        nombre: string;
        genero: string;
        precio: real;
    end;
    archivo = file of novela;
procedure leerOtrosCampos(var nov: novela);
begin
    writeln('Ingrese un nombre de novela');
    readln(nov.nombre);
    writeln('Ingrese un genero de novela');
    readln(nov.genero);
    writeln('Ingrese un precio de novela');
    readln(nov.precio);
end;
procedure leerNovela(var nov: novela);
begin
    writeln('Ingrese un codigo de novela');
    readln(nov.codigo);
    if(nov.codigo <> 0 ) then
        begin
            leerOtrosCampos(nov);
        end;
end;
procedure crearArchivo(var arc: archivo; var carga: text);
var
    nov: novela;
    nombre: string;
begin
    writeln('Ingrese un nombre del archivo a crear');
    readln(nombre);
    assign(arc, nombre);
    reset(carga);
    rewrite(arc);
    while(not eof(carga)) do
        begin
            with nov do 
                begin
                    readln(carga, codigo, precio, genero);
                    readln(carga, nombre);
                    write(arc, nov);
                end;
        end;
    writeln('Archivo binario cargado');
    close(arc);
    close(carga);
end;
procedure agregarNovela(var arc: archivo);
var
    nov: novela;
begin
    reset(arc);
    leerNovela(nov);
    seek(arc, fileSize(arc));
    while(nov.codigo <> 0) do
        begin
            write(arc, nov);
            leerNovela(nov);
        end;
    close(arc);
end;
procedure modificarNovela(var arc: archivo);
var
    nov: novela;
    ok: boolean;
    codigo: integer;
begin
    reset(arc);
    ok:= false;
    writeln('Ingrese el codigo de novela a modificar');
    readln(codigo);
    while(not EOF(arc)) and (not ok) do
        begin
            read(arc, nov);
            if(nov.codigo = codigo) then
                begin
                    ok:= true;
                    leerOtrosCampos(nov);
                    seek(arc, filepos(arc)-1);
                    write(arc, nov);
                    writeln('Se modifico la novela con codigo ', codigo);
                end;
        end;
    close(arc);
    if(not ok) then
        writeln('No se hallo ninguna novela con el codigo ', codigo);
end;
procedure exportarTexto(var arc: archivo; var carga: text);
var
    nov: novela;
begin
    reset(arc);
    rewrite(carga);
    while(not eof(arc)) do
        begin
            read(arc, nov);
            with nov do
                begin
                    writeln(carga, codigo, ' ', precio:0:2, ' ' , genero);
                    writeln(carga, nombre);
                end;
        end;
    close(carga);
    close(arc);
end;
procedure menu(var arc: archivo);
var
    carga: text;
    opcion: integer;
begin
    assign(carga, 'novelas.txt');
    writeln('MENU DE OPCIONES');
    writeln('1: Crear un archivo binario a partir de la informacion almacenada en un archivo de texto');
    writeln('2: Agregar una novela');
    writeln('3: Modificar una novela');
    writeln('4: Exportar a texto el archivo binario');
    writeln('5: Salir del menu');
    readln(opcion);
    while(opcion <> 5) do
        begin
            case opcion of
                1: crearArchivo(arc, carga);
                2: agregarNovela(arc);
                3: modificarNovela(arc);
                4: exportarTexto(arc, carga);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('1: Crear un archivo binario a partir de la informacion almacenada en un archivo de texto');
            writeln('2: Agregar una novela');
            writeln('3: Modificar una novela');
            writeln('4: Exportar a texto el archivo binario');
            writeln('5: Salir del menu');
            readln(opcion);
        end;
end;
var
    arc: archivo;
begin
    menu(arc);
end.