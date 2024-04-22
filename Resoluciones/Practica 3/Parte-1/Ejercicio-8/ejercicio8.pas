{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

program ejercicio8;
type
    distribucion = record
        nombre: string;
        anio: integer;
        version: real;
        cant: integer;
        descripcion: string;
    end;
    archivo = file of distribucion;
procedure leerDistribucion(var d: distribucion);
begin
    writeln('Ingrese el nombre de la distribucion');
    readln(d.nombre);
    if(d.nombre <> 'fin') then
        begin
            writeln('Ingrese el anio de lanzamiento');
            readln(d.anio);
            writeln('Ingrese el numero de version de kernel');
            readln(d.version);
            writeln('Ingrese la cantidad de desarrolladores');
            readln(d.cant);
            writeln('Ingrese la descripcion');
            readln(d.descripcion);
        end;
end;
function ExisteDistribucion(var arc: archivo; nombre: string): boolean;
var
    ok: boolean;
    d: distribucion;
begin
    ok:= false;
    reset(arc);
    while(not eof(arc)) and (not ok) do
        begin
            read(arc, d);
            if(d.nombre = nombre) then
                ok:= true;
        end;
    close(arc);
    ExisteDistribucion:= ok;
end;
procedure crearArchivo(var arc: archivo);
var
    d: distribucion;
begin
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    d.nombre:= '';
    d.cant:= 0;
    d.anio:= 0;
    d.version:= 0;
    d.descripcion:= '';
    write(arc, d);
    leerDistribucion(d);
    while(d.nombre <> 'fin') do
        begin
            write(arc, d);
            leerDistribucion(d);
        end;
    close(arc);
end;
procedure imprimirArchivo(var arc: archivo);
var
    d: distribucion;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, d);
            writeln('Nombre=', d.nombre, ' Cant=', d.cant);
        end;
    close(arc);
end;
procedure AltaDistribucion(var arc: archivo);
var
    cabecera, d: distribucion;
begin
    leerDistribucion(d);
    if(not ExisteDistribucion(arc, d.nombre)) then
        begin
            reset(arc);
            read(arc, cabecera);
            if(cabecera.cant = 0) then
                begin
                    seek(arc, filesize(arc));
                    write(arc, d);
                end
            else
                begin
                    seek(arc, cabecera.cant * -1);
                    read(arc, cabecera);
                    seek(arc, filepos(arc)-1);
                    write(arc, d);
                    seek(arc, 0);
                    write(arc, cabecera);
                    close(arc);
                end;
            writeln('Se realizo correctamente el alta de la distribucion con nombre ', d.nombre);
        end
    else
        writeln('Ya existe la distribucion');
end;
procedure BajaDistribucion(var arc: archivo);
var
    cabecera, d: distribucion;
    nombre: string;
begin
    writeln('Ingrese el nombre de la distribucion a dar de baja');
    readln(nombre);
    if(ExisteDistribucion(arc, nombre)) then
        begin
            reset(arc);
            read(arc, cabecera);
            read(arc, d);
            while(d.nombre <> nombre) do
                read(arc, d);
            seek(arc, filepos(arc)-1);
            write(arc, cabecera);
            cabecera.cant:= (filepos(arc)-1) * -1;
            seek(arc, 0);
            write(arc, cabecera);
            close(arc);
            writeln('Se elimino correctamente la distribucion con nombre ', nombre);
        end
    else
        writeln('Distribucion no existente');
end;
var
    arc: archivo;
begin
    crearArchivo(arc);
    writeln('Archivo original:');
    imprimirArchivo(arc);
    AltaDistribucion(arc);
    writeln('Archivo con un alta');
    imprimirArchivo(arc);
    BajaDistribucion(arc);
    writeln('Archivo con una baja');
    imprimirArchivo(arc);
end.
