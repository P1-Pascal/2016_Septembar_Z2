program z2(input, output);

type
  interval = record
    low: real;
    high: real;
  end;

  pok = ^elem;
  elem = record
    int: interval;
    next: pok;
  end;

var
  lista: pok;
  n, i: integer;

procedure ispisiListu(lista: pok);
begin
  writeln('--------------');
  while lista<>nil do
  begin
    writeln('[', lista^.int.low:1:2, ', ', lista^.int.high:1:2, ']');
    lista:=lista^.next;
  end;
  writeln('--------------');
end;

function min(a, b: real): real;
begin
  if (a<b) then
    min:=a
  else
    min:=b
end;

function max(a, b: real): real;
begin
  if (a>b) then
    max:=a
  else
    max:=b
end;

function poklapanjeIntervala(i1, i2: interval): boolean;
begin
  poklapanjeIntervala:=((i1.high<=i2.high) and (i1.high>=i2.low)) or
              ((i2.high<=i1.high) and (i2.high>=i1.low));
end;

function spojiIntervale(i1, i2: interval): interval;
var
  i: interval;
begin
  i.low:=min(i1.low, i2.low);
  i.high:=max(i1.high, i2.high);
  spojiIntervale:=i;
end;

procedure dodajInterval(var lista: pok; i: interval);
var
  novi, tek, posl, preth: pok;
  p: boolean;
  noviInt: interval;
begin
  p:=false;  //ako se ne preklopi ni sa jednim bice false, i onda se interval dodaje na kraj liste
  tek:=lista;
  posl:=nil;
  noviInt:=i;
  while tek<> nil do
  begin
    posl:=tek;
    if poklapanjeIntervala(tek^.int, i) then
      begin
        noviInt:=spojiIntervale(tek^.int, noviInt);
        p:=true;
      end;
    tek:=tek^.next;
  end;

  if not p then
    begin
      new(novi);
      novi^.int:=i;
      novi^.next:=nil;

      if lista=nil then
        lista:=novi
      else
        posl^.next:=novi;
    end
  else
    begin
      tek:=lista;
      preth:=nil;
      while tek<>nil do
      begin
        if poklapanjeIntervala(tek^.int, i) then
          begin
            if preth=nil then
              begin
                preth:=tek;
                tek:=tek^.next;
                dispose(preth);
                lista:=tek;
                preth:=nil;
              end
            else
              begin
                preth^.next:=tek^.next;
                dispose(tek);
                tek:=preth^.next;
              end;
          end
        else
          begin
            preth:=tek;
            tek:=tek^.next;
          end;
      end;

      new(novi);
      novi^.int:=noviInt;
      novi^.next:=nil;

      if lista=nil then
        lista:=novi
      else
        preth^.next:=novi;
    end;
end;

procedure ucitajIntervale(var lista: pok; n: integer);
var
  i: integer;
  noviInterval: interval;
begin
  for i:=1 to n do
  begin
    read(noviInterval.low, noviInterval.high);
    dodajInterval(lista, noviInterval);
  end;

end;

procedure brisiListu(var lista: pok);
var
  stari: pok;
begin
  stari:=lista;
  while lista<>nil do
  begin
    lista:=lista^.next;
    dispose(stari);
    stari:=lista;
  end;
end;

procedure sort(lista: pok);
var
  tek, sled: pok;
  tmp: interval;
begin
  tek:=lista;
  if tek<>nil then
    sled:=tek^.next
  else
    sled:=nil;

  while sled<> nil do
  begin
    while sled<>nil do
    begin
      if (sled^.int.low<tek^.int.low) then
        begin
          tmp:=sled^.int;
          sled^.int:=tek^.int;
          tek^.int:=tmp;
        end;
      sled:=sled^.next;
    end;
    tek:=tek^.next;
    sled:=tek^.next;
  end;
end;

function total(lista: pok): real;
var
  s: real;
begin
  s:=0;
  while lista<>nil do
  begin
    s:=s+lista^.int.high-lista^.int.low;
    lista:=lista^.next;
  end;
  total:=s;
end;

begin

  readln(n);

  ucitajIntervale(lista, n);

  ispisiListu(lista);

  sort(lista);

  ispisiListu(lista);

  writeln('Total: ', total(lista):1:2);

  brisiListu(lista);

  readln(n);

end.

