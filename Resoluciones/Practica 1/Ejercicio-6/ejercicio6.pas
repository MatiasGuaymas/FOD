{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular}

program ejercicio6;
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
//-----------------------CREAR ARCHIVO-----------------------
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
//-----------------------INFORMAR CELULARES CON STOCK MENOR AL MIN-----------------------
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
//-----------------------IMPRIMIR MISMA DESCRIPCION INGRESADA-----------------------
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
//-----------------------EXPORTAR A TEXTO-----------------------
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
                    writeln(carga, codigo, ' ', precio:0:2, ' ', marca);
                    writeln(carga, stock, ' ', stockMin, ' ', descripcion);
                    writeln(carga, nombre);
                end;
        end;
    close(carga);
    close(arc);
end;
//-----------------------LEER CELULAR-----------------------
procedure leerCelular(var c: celular);
begin
    writeln('Ingrese el codigo del celular');
    readln(c.codigo);
    if(c.codigo <> 0) then
        begin
            writeln('Ingrese el nombre del celular');
            readln(c.nombre);
            writeln('Ingrese la descripcion del celular'); //Dejar un espacio para que se guarde bien el celular agregado
            readln(c.descripcion);
            writeln('Ingrese la marca del celular');
            readln(c.marca);
            writeln('Ingrese el precio del celular');
            readln(c.precio);
            writeln('Ingrese el stock minimo del celular');
            readln(c.stockMin);
            writeln('Ingrese el stock del celular');
            readln(c.stock);
        end;
end;
//-----------------------A-----------------------
procedure agregarCelulares(var arc: archivo);
var
    c: celular;
begin
    reset(arc);
    leerCelular(c);
    seek(arc, filesize(arc));
    while(c.codigo <> 0) do
        begin
            write(arc, c);
            leerCelular(c);
        end;
    close(arc);
end;
//-----------------------B-----------------------
procedure modificarStock(var arc: archivo);
var
    c: celular;
    nombre: string;
    ok: boolean;
    stock: integer;
begin
    reset(arc);
    writeln('Ingrese el nombre del celular que va a modificar su stock');
    readln(nombre);
    ok:= false;
    while(not EOF (arc)) and (not ok) do
        begin
            read(arc, c);
            if(c.nombre = nombre) then
                begin
                    ok:= true;
                    writeln('Ingrese el nuevo stock del celular');
                    readln(stock);
                    seek(arc, filepos(arc)-1);
                    c.stock:= stock;
                    write(arc, c);
                    writeln('Se modifico el stock del celular con nombre ', nombre);
                end;
        end;
    close(arc);
    if(not ok) then
        writeln('No se encontro el celular con el nombre ', nombre);
end;
//-----------------------C-----------------------
procedure exportarSinStock(var arc: archivo);
var
    noStock: text;
    c: celular;
begin
    assign(noStock, 'SinStock.txt');
    reset(arc);
    rewrite(noStock);
    while(not EOF(arc)) do
        begin
            read(arc, c);
            if(c.stock = 0) then
                with c do
                    begin
                        writeln(noStock, codigo, ' ', precio:0:2, ' ', marca);
                        writeln(noStock, stock, ' ', stockMin, ' ', descripcion);
                        writeln(noStock, nombre);
                    end;
        end;
    close(arc);
    close(noStock);
end;
//-----------------------MENU DE OPCIONES-----------------------
procedure menuDeOpciones(var arc: archivo);
var
    carga: text;
    opcion: integer;
begin
    assign(carga, 'celulares.txt');
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
    writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
    writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
    writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
    writeln('Opcion 5: Agregar uno o mas celulares al final del archivo');
    writeln('Opcion 6: Modificar el stock de un celular dado');
    writeln('Opcion 7: Exportar el contenido del archivo binario a un archivo de texto denominado: SinStock.txt, con aquellos celulares que tengan stock 0');
    writeln('Opcion 8: Salir del menu y terminar la ejecucion del programa');
    readln(opcion);
    while(opcion <> 8) do
        begin
            case opcion of
                1: crearArchivo(arc, carga);
                2: listarCelularesMenosStock(arc);
                3: listarCelularesMismaDesc(arc);
                4: exportarTexto(arc, carga);
                5: agregarCelulares(arc);
                6: modificarStock(arc);
                7: exportarSinStock(arc);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Crear un archivo de registros no ordenados de celulares');
            writeln('Opcion 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
            writeln('Opcion 3: Listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres proporcionada');
            writeln('Opcion 4: Exportar el archivo creado a un texto celulares.txt');
            writeln('Opcion 5: Agregar uno o mas celulares al final del archivo');
            writeln('Opcion 6: Modificar el stock de un celular dado');
            writeln('Opcion 7: Exportar el contenido del archivo binario a un archivo de texto denominado: SinStock.txt, con aquellos celulares que tengan stock 0');
            writeln('Opcion 8: Salir del menu y terminar la ejecucion del programa');
            readln(opcion);
        end;
end;
var
    arc: archivo;
begin
    menuDeOpciones(arc);
end.
