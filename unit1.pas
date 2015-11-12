unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Messages, Variants, math,
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, Interfaces,
  IntervalArithmetic32and64;
   type


  { TNewtRaph }

  TNewtRaph = class(TForm)
    eSt: TEdit;
    eit: TEdit;
    eNewt2: TEdit;
    Epsoutput: TEdit;
    eFatx2: TEdit;
    eNewt: TEdit;
    eFatx: TEdit;
    eX2: TEdit;
    eEps: TEdit;
    eMit1: TEdit;
    eMit: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RodzajArytmetyki: TLabel;
    OutputBox: TListBox;
    rPrzedzialowa: TRadioButton;
    rArytmetyczna: TRadioButton;
    eX: TEdit;
    Oblicz: TButton;


     procedure eX2Enter(Sender: TObject);
     procedure eMitEnter(Sender: TObject);
     procedure ObliczClick(Sender: TObject);
     procedure eXEnter(Sender: TObject);
     procedure eEpsEnter(Sender: TObject);
     procedure rArytmetycznaChange(Sender: TObject);
     procedure rPrzedzialowaChange(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }


  end;

var
  NewtRaph: TNewtRaph;
  outNeph, outNeph2, outFatx, outFatx2, outIT, outST : String;
implementation

{$R *.lfm}

{ TNewtRaph }

function foo(x : extended)  : extended; stdcall external 'foos.dll' name 'foo';
function dfoo(x : extended)  : extended; stdcall external 'foos.dll' name 'dfoo';
function d2foo(x : extended)  : extended; stdcall external 'foos.dll' name 'd2foo';
function ifoo(x : interval) : interval; stdcall external 'foos.dll' name 'ifoo';
function idfoo(x : interval) : interval; stdcall external 'foos.dll' name 'idfoo';
function id2foo(x : interval) : interval; stdcall external 'foos.dll' name 'id2foo';



function max(a, b:extended): extended;
begin
  if (a>b) then result:=a
  else result:=b;
end;

function ieq (const x, y: interval) : Boolean;
 begin
   if ((x.a = y.a) and (y.a = y.b))  then
     ieq:=true
   else
     ieq:=false;
 end;

function ilt(const x, y : interval): Boolean;
 var
   xs,ys: extended;
 begin
   xs:=(x.a+x.b)*0.5;
   ys:=(y.a+y.b)*0.5;
   if (xs<ys) then
     Result:=true
   else
     Result:=false;
 end;


function igt(const x,y: interval): Boolean;
 var
   xs,ys: extended;
 begin
   xs:=(x.a+x.b)*0.5;
   ys:=(y.a+y.b)*0.5;
   if (xs>ys) then
     Result:=true
   else
     Result:=false;
 end;


function iabs(const x: interval) : interval;
  begin
    if (((x.a>=0) and (x.b<=0)) or ((x.a<=0) and (x.b>=0))) then
    begin
      Result.a:=0;
      Result.b:=0;
    end
    else if ((x.a>0) and (x.b>0)) then
     begin
       Result.a:=x.a;
       Result.b:=x.b;
      end
    else if ((x.a<0) and (x.b<0)) then
      begin
       Result.a:=-x.b;
       Result.b:=-x.a;
      end;
  end;

function isqr (x : interval) : interval;
begin
     SetRoundMode (rmDown);
     result.a := sqrt(x.a);
     SetRoundMode (rmUp);
     result.b := sqrt(x.b);
end;

function ipower (const x:interval; n: extended) :interval;
  begin
    SetRoundMode (rmDown);
    Result.a:=power(x.a,n);
    SetRoundMode (rmUp);
    Result.b:=power(x.b,n);
  end;

function IsValidEntry(s : String) : Boolean;
var
  n:Integer;
begin
  result := true;
  for n := 1 to Length(s) do
    begin
    if (s[n] < '0') or (s[n] > '9' )then
      begin
           if (s[n] <> '-') and (s[n] <>',') and (s[n] <> '.') then
           begin
             result := false;
             exit;
            end;
      end;
    end;
end;

function iNewtonRaphson (var x     : Interval;
                        mit       : Integer;
                        eps       : Interval) : String;
      var p,v,w,xh,x1,x2 : Interval;
      var izero : Interval;
       it, st : integer;
       fatx, dfatx, d2fatx : interval;
       out1, out2, out3 : string;

      begin
        result := '';
        izero.a := 0;
        izero.b := 0;

        if mit<1
          then st:=1
          else begin
                 st:=3;
                 it:=0;
                 repeat
                   it:=it+1;
                   fatx:= ifoo(x);
                   dfatx:=idfoo(x);
                   d2fatx:=id2foo(x);
                   p:=isub(imul(dfatx, dfatx), imul(imul(int_read('2.0'), fatx), d2fatx));
                   if ilt(p, izero)
                     then st:=4
                     else if ieq(d2fatx, izero)
                            then st:=2
                            else begin
                                   xh:=x;
                                   w:=iabs(xh);
                                   //p:=ipower(p, 0.5);
                                   p:= isqr(p);
                                   x1:=isub(x, idiv(isub(dfatx, p), d2fatx));
                                   x2:=isub(x, idiv(iadd(dfatx, p), d2fatx));
                                   if igt(iabs(isub(x2, xh)), iabs(isub(x1, xh)))
                                     then x:=x1
                                     else x:=x2;
                                   v:=iabs(x);
                                   if ilt(v, w)
                                     then v:=w;
                                   if ieq(v, izero)
                                     then st:=0
                                     else if (ilt(idiv(iabs(isub(x, xh)), v), eps) or ieq(idiv(iabs(isub(x, xh)), v), eps))
                                            then st:=0
                                 end
                 until (it=mit) or (st<>3)
               end;


        if (st = 1) then
        result := ' st = 1  '//:= 'Mit < 1'
         else if (st = 2) then
              result := ' st = 2  '//:= 'pochodna drugiego rzedu = 0 (d2f(x) = 0)'
         else if (st = 3) then
              result := ' st = 3  '//' Nie osiagnieto podanej dokladnosci: (abs(x - xh)/ max(x, xh)) < eps'

         else if (st = 4 ) then
              result := ' st = 4  '//'p < 0'
         else
        result := 'st = 0';

        outST := inttostr(st);
        if (st=0) or (st=3)
          then begin
                 fatx := ifoo(x);

           //str(int_width(x), out1);
           //str(fatx.a:26, out2);
           //str(fatx.b:26, out3);
           iends_to_strings(fatx, out2, out3);
           iends_to_strings(x, outNeph, outNeph2);
           iends_to_strings(fatx, outFatx, outFatx2);
           outIT := inttostr(it);

           //str(fatx.a:26, outFatx);
           //str(fatx.b:26, outFatx2);

           result := 'NewtRaph = ' + outNeph + ' , it = ' + IntToStr(it) + ' ' + result;// + ', fat x.a = ' + out2 + ', fat x.b = ' + out3 + ' , ' + result;

               end;
      end;

function NewtonRaphson (var x     : Extended;//początkowe przybliżenie pierwiastka
                        mit       : Integer;//max liczba iteracji w procesie
                        eps       : Extended//blad wzgledny wyznaczania pierwiastka
                        ) : String;
var dfatx,d2fatx,p,v,w,xh,x1,x2 : Extended;
    out1, out2: String;
    fatx  : Extended;
    it, st : Integer;
begin
  out1 := '';
  if mit<1                                          // st - parametr (floppy)
    then st:=1                                      // it - liczba wykonanych iteracji
    else begin
           st:=3;
           it:=0;
           repeat
             it:=it+1;
             fatx:=foo(x);
             dfatx:=dfoo(x);
             d2fatx:=d2foo(x);
             p:=dfatx*dfatx-2*fatx*d2fatx;
             if p<0
               then st:=4
             else if d2fatx=0 then
				st:=2
             else
	        begin
		   xh:=x;
		   w:=abs(xh);
		   p:=sqrt(p);
		   x1:=x-(dfatx-p)/d2fatx;
		   x2:=x-(dfatx+p)/d2fatx;
		   if abs(x2-xh)>abs(x1-xh)
		     then x:=x1
		     else x:=x2;
		   v:=abs(x);
		   if v<w
		     then v:=w;
		   if v=0 then
			  st := 0
		   else if abs(x-xh)/v <= eps then
			  st := 0
                end
           until (it = mit) or (st <> 3)
         end;

   if (st = 1) then
        result := ' st = 1  '//:= 'Mit < 1'
   else if (st = 2) then
        result := ' st = 2  '//:= 'pochodna drugiego rzedu = 0 (d2f(x) = 0)'
   else if (st = 3) then
        result := ' st = 3  '//' Nie osiagnieto podanej dokladnosci: (abs(x - xh)/ max(x, xh)) < eps'

   else if (st = 4 ) then
        result := ' st = 4  '//'p < 0'
   else
        result := 'st = 0';
   outST := inttostr(st);
  if (st=0) or (st=3)
    then begin
         str(x:26, out1);
         fatx := foo(x);
         str(fatx:26, out2);
         outIT := inttostr(it);

         str(x:26,outNeph);
         str(fatx:26, outFatx);
         result := out1 + ' w ' + IntToStr(it) + 'iteracjach' + ', fatx = ' + out2 + ' ' + result;
         end

end;

procedure TNewtRaph.ObliczClick(Sender: TObject);
var x, eps : Extended;
    mit, error : Integer;
    ix, ieps: interval;
    tmp, leftx, rightx : string;
begin
     OutputBox.Clear;
     EpsOutput.Clear;
     eNewt.Clear;
     eNewt2.clear;
     efatx.Clear;
     efatx2.clear;
     eit.clear;
     est.clear;
     if(rArytmetyczna.Checked) then
     begin
       eFatx2.Visible := false;
       if(isValidEntry(eX.text) and isValidEntry(eMit.text) and isValidEntry(eEps.text) ) then
         begin
              Val(eX.text, x, error);
              Val(eMit.text, mit, error);
              Val(eEps.text, eps, error);
              eps := power(10, -eps);
              OutputBox.AddItem(NewtonRaphson(x, mit, eps), OutputBox);
              OutputBox.AddItem('mit = ' + inttostr(mit), OutputBox);
              str(x:26, tmp);
              OutputBox.AddItem('x = ' + tmp, OutputBox);
              str(eps:26, tmp);
              OutputBox.AddItem('eps = ' + tmp, OutputBox);
              str(eps:26, tmp);//floattostr(eps);
              epsOutput.text := tmp;
              tmp := '';
              est.text := outST;

              if (strtoint(outST) = 0) or  (strtoint(outST) = 3) then
                begin
                  eNewt.Text := outNeph;
                  eNewt2.Text := outNeph2;
                  eFatx.Text := outFatx;
                  eFatx2.Text := outFatx2;
                  eit.text := outIT;
                end;


         end;
     end
     else if(rPrzedzialowa.Checked) then
       if(isValidEntry(eX.text) and isValidEntry(eMit.text) and isValidEntry(eEps.text)
                                and isValidEntry(eX2.text) ) then { and (eX.text = eX2.text) ) then         }
         begin
              eFatx2.Visible := true;
              label3.Visible := true;
              ix.a := left_read(eX.text);
              ix.b := right_read(eX.Text);
              Val(eMit.text, mit, error);
              ieps.a :=  power(10, -strtoint(eEps.text));
              //ieps.a := left_read(eEps.text);
              //ieps.a := power(10, -ieps.a);
              //ieps.b := right_read(eEps.text);
              //ieps.b := power(10, -ieps.a);
              ieps.b :=  power(10, -strtoint(eEps.text));

              OutputBox.AddItem(iNewtonRaphson(ix, mit, ieps), OutputBox);
              OutputBox.AddItem('mit = ' + inttostr(mit), OutputBox);
              iends_to_strings(ix, leftx, rightx);
              OutputBox.AddItem('x.a = ' + leftx, OutputBox);
              OutputBox.AddItem('x.b = ' + rightx, OutputBox);
              str(ieps.a:26, tmp);
              OutputBox.AddItem('eps = ' + tmp , OutputBox);
              if (strtoint(outST) = 0) or  (strtoint(outST) = 3) then
                begin
                  eNewt.Text := outNeph;
                  eNewt2.Text := outNeph2;
                  eFatx.Text := outFatx;
                  eFatx2.Text := outFatx2;
                  eit.text := outIT;
                end;

              str(ieps.a:26, tmp);
              epsOutput.text := tmp;
              tmp := '';
              est.text := outST;
         end;
end;

procedure TNewtRaph.rPrzedzialowaChange(Sender: TObject);
begin
     eX2.Visible := true;
end;

procedure TNewtRaph.eXEnter(Sender: TObject);
begin
     eX.Clear;
end;

procedure TNewtRaph.eX2Enter(Sender: TObject);
begin
     eX2.Clear;
end;

procedure TNewtRaph.eEpsEnter(Sender: TObject);
begin
  eEps.Clear;
end;

procedure TNewtRaph.rArytmetycznaChange(Sender: TObject);
begin
  eX2.visible := false;
end;

procedure TNewtRaph.eMitEnter(Sender: TObject);
begin
  eMit.Clear;
end;



end.

