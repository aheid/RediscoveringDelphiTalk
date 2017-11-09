unit Events.Detail;

interface

uses
  SysUtils;

type
  IEvent = interface
    procedure Signal;
    procedure WaitFor(const Timeout: cardinal);
  end;

type
  EventImpl = class(TInterfacedObject, IEvent)
  strict private
    FSignalled: boolean;
  public
    procedure Signal;
    procedure WaitFor(const Timeout: cardinal);

    property Signalled: boolean read FSignalled;
  end;

implementation

{ EventImpl }

procedure EventImpl.Signal;
begin
  MonitorEnter(Self);

  FSignalled := True;

  MonitorPulseAll(Self);

  MonitorExit(Self);
end;

procedure EventImpl.WaitFor(const Timeout: cardinal);
begin
  MonitorEnter(Self);

  while (not Signalled) do
  begin
    MonitorWait(Self, Timeout);
  end;

  MonitorExit(Self);
end;

end.
