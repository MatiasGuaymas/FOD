{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}

program ejercicio5;
type
    celular = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        marca: string;
        precio: real;
        stockMin: integer;
        stock: integer;
    end;
    archivo = file of celular;
//-----------------------IMPRIMIR CELULAR-----------------------
procedure imprimirCelular(c: celular);
begin
    with c do
        writeln('Codigo=', codigo, ' Nombre=', nombre, ' Descripcion=', descripcion, ' Marca=', marca, ' Precio=', precio:0:2, ' StockMin=', stockMin, ' Stock=', stock);
end;
//-----------------------A-----------------------
procedure crearArchivo(var arc: archivo; var carga: text);
var
    cel: celular;
    nombre: string;
begin
    writeln('Ingrese un nombre del archivo a crear');
    readln(nombre);
    assign(arc, nombre);
    reset(carga);
    rewrite(arc);
    while(not eof(carga)) do
        begin
            with cel do 
                begin
                    readln(carga, codigo, precio, marca);
                    readln(carga, stock, stockMin, descripcion);
                    readln(carga, nombre);
                    write(arc, cel);
                end;
        end;
    writeln('Archivo binario cargado');
    close(arc);
    close(carga);
end;
//-----------------------B-----------------------
procedure listarCelularesMenosStock(var arc: archivo);
var
    c: celular;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, c);
            if(c.stock < c.stockMin) then
                imprimirCelular(c);
        end;
    close(arc);
end;
//-----------------------C-----------------------
procedure listarCelularesMismaDesc(var arc: archivo);
var
    c: celular;
    descripcion: string;
begin
    reset(arc);
    writeln('Ingrese una descripcion');
    readln(descripcion);
    while(not eof(arc)) do
        begin
            read(arc, c);
            if(descripcion = c.descripcion) then
                imprimirCelular(c);
        end;
    close(arc);
end;
//-----------------------D-----------------------
procedure exportarTexto(var arc: archivo; var carga: text);
var
    c: celular;
begin
    reset(arc);
    rewrite(carga);
    while(not eof(arc)) do
        begin
            read(arc, c);
            with c do
                begin
                    writeln(carga, codigo, ' ', precio:0:2, marca);
                    writeln(carga, stock, ' ', stockMin, descripcion);
                    writeln(carga, nombre);
                end;
        end;
    close(carga);
    close(arc);
end;
//-----------------------MENU DE OPCIONES-----------------------
procedure menuDeOpciones(var arc: archivo; var carga: text);
var
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
    writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
    writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
    writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
    writeln('Opcion 5: Salir del menu y terminar la ejecucion del programa');
    readln(opcion);
    while(opcion <> 5) do
        begin
            case opcion of
                1: crearArchivo(arc, carga);
                2: listarCelularesMenosStock(arc);
                3: listarCelularesMismaDesc(arc);
                4: exportarTexto(arc, carga);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
            writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
            writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
            writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
            writeln('Opcion 5: Salir del menu y terminar la ejecucion del programa');
            readln(opcion);
        end;
end;
var
    nombre: string[15];
    arc: archivo;
    carga: text;
begin
    assign(carga, 'celulares.txt');
    menuDeOpciones(arc, carga);
end.