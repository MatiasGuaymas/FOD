{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos 
y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}

program ejercicio6;
type    
    prenda = record
        cod: integer;
        descripcion: string;
        colores: string;
        tipo: string;
        stock: integer;
        precio: real;
    end;
    maestro = file of prenda;
    detalle = file of integer;
procedure crearMaestro(var arc: maestro);
var
    p: prenda;
    txt: text;
begin
    assign(txt, 'maestro.txt');
    reset(txt);
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    while(not eof(txt)) do
        begin
            with p do
                begin
                    readln(txt, cod, stock, precio, descripcion);
                    readln(txt, tipo);
                    readln(txt, colores);
                    write(arc, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(arc);
    close(txt);
end;
procedure crearDetalle(var det: detalle);
var
    carga: text;
    codigo: integer;
begin
    assign(carga, 'detalle.txt');
    reset(carga);
    assign(det, 'ArchivoDetalle');
    rewrite(det);
    while(not eof(carga)) do
        begin
            readln(carga, codigo);
            write(det, codigo);
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure bajaLogica(var mae: maestro; var det: detalle);
var
    infoDet: integer;
    infoMae: prenda;
begin
    reset(mae);
    reset(det);
    while(not eof(det)) do
        begin
            read(det, infoDet);
            seek(mae, 0);
            read(mae, infoMae);
            while(infoDet <> infoMae.cod) do
                read(mae, infoMae);
            seek(mae, filepos(mae)-1);
            infoMae.stock:= -1;
            write(mae, infoMae);
        end;
    close(mae);
    close(det);
end;
procedure exportarArchivo(var mae, aux: maestro);
var
    infoMae: prenda;
begin
    assign(aux, 'ArchivoAuxiliar');
    reset(mae);
    rewrite(aux);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            if(infoMae.stock >= 0) then
                write(aux, infoMae);
        end;
    close(mae);
    close(aux);
    erase(mae);
    rename(aux, 'ArchivoMaestro');
end;
procedure imprimirMaestro(var mae: maestro);
var
    infoMae: prenda;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln('Codigo=', infoMae.cod, ' Desc=', infoMae.descripcion, ' Stock=', infoMae.stock, ' Precio=', infoMae.precio:0:2);
        end;
    close(mae);
end;
procedure imprimirDetalle(var det: detalle);
var
    cod: integer;
begin
    reset(det);
    while(not eof(det)) do
        begin
            read(det, cod);
            write('CodBorrar=', cod , ' | ');
        end;
    close(det);
end;
var
    maeSinBorrados, maeConBorrados: maestro;
    det: detalle;
begin
    crearMaestro(maeSinBorrados);
    writeln('Archivo sin borrados:');
    imprimirMaestro(maeSinBorrados);
    crearDetalle(det);
    imprimirDetalle(det);
    writeln();
    writeln('Se realizan las bajas');
    writeln('Archivo con borrados logicos:');
    bajaLogica(maeSinBorrados, det);
    imprimirMaestro(maeSinBorrados);
    writeln('Archivo con borrados fisicos:');
    exportarArchivo(maeSinBorrados, maeConBorrados);
    imprimirMaestro(maeConBorrados);
end.