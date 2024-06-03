program parcial4;
const
    valoralto = 9999;
type
    infoArc = record
        codigo: integer;
        idAutor: integer;
        isbn: integer;
        id: integer;
    end;
    archivo = file of infoArc;
procedure crearArchivo(var mae: archivo);
var
    txt: text;
    info: infoArc;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with info do
                begin
                    readln(txt, codigo, idAutor, isbn, id);
                    write(mae, info);
                end;
        end;
    writeln('Archivo binario creado');
    close(txt);
    close(mae);
end;
procedure leer(var a: archivo; var info: infoArc);
begin
    if(not eof(a)) then
        read(a, info)
    else
        info.codigo:= valoralto;
end;
procedure corteDeControl(var a: archivo; nom: string; var txt: text);
var
    cantTotal, sucActual, cantSuc, autorActual, cantAutor, isbnActual, cantISBN: integer;
    info: infoArc;
begin
    assign(txt, nom);
    rewrite(txt);
    reset(a);
    leer(a, info);
    cantTotal:= 0;
    while(info.codigo <> valoralto) do
        begin
            writeln(txt, 'Codigo de Sucursal: ', info.codigo);
            sucActual:= info.codigo;
            cantSuc:= 0;
            while(info.codigo = sucActual) do
                begin
                    writeln(txt, 'Identificacion del autor: ', info.idAutor);
                    autorActual:= info.idAutor;
                    cantAutor:= 0;
                    while((info.codigo = sucActual) and (info.idAutor = autorActual)) do
                        begin
                            isbnActual:= info.isbn;
                            cantISBN:= 0;
                            while((info.codigo = sucActual) and (info.idAutor = autorActual) and (info.isbn = isbnActual)) do
                                begin
                                    cantISBN:= cantISBN + 1;
                                    leer(a, info);
                                end;
                            writeln(txt, ' ISBN: ', isbnActual, ' Total de ejemplares vendidos del libro: ', cantISBN);
                            cantAutor:= cantAutor + cantISBN;
                        end;
                    writeln(txt, ' Total de ejemplares vendidos del autor: ', cantAutor);
                    cantSuc:= cantSuc + cantAutor;
                end;
            writeln(txt, 'Total de ejemplares vendidos en la sucursal: ', cantSuc);
            cantTotal:= cantTotal + cantSuc;
        end;
    writeln(txt, 'TOTAL GENERAL DE EJEMPLARES VENDIDOS EN LA CADENA: ', cantTotal);
    close(a);
    close(txt);
end;
var
    a: archivo;
    txt: text;
    nom: string;
begin
    crearArchivo(a);
    writeln('Ingrese un nombre de texto');
    readln(nom);
    corteDeControl(a, nom, txt);
end.