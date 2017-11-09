program AnonymousMethods4;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

// adapted from Stefan Glienke's blog post
// http://delphisorcery.blogspot.com/2015/06/anonymous-method-overloading.html

type
  TIntegerFunc = reference to function(): integer;

  IIntegerObj = interface(TIntegerFunc)
    procedure Invoke(const Value: integer); overload;
  end;

  TIntegerObjImpl = class(TInterfacedObject, IIntegerObj)
    function Invoke(): integer; overload; // from TIntegerFunc
    procedure Invoke(const Value: integer); overload; // from IIntegerObj
  end;


{ TIntegerObjImpl }

function TIntegerObjImpl.Invoke: integer;
begin
  result := 42;
end;

procedure TIntegerObjImpl.Invoke(const Value: integer);
begin
  WriteLn(Value);
end;

var
  io: IIntegerObj;
begin
  io := TIntegerObjImpl.Create();

  io(123);

  WriteLn( io );

  ReadLn;
end.
