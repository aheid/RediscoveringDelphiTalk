unit Channels.Detail;

interface

uses
  System.SysUtils;

type
  IChannel<T> = interface
    procedure Close;

    function Send(const Value: T): boolean;
    function Recv(var Value: T): boolean;
    function TrySend(const Value: T): boolean;
    function TryRecv(var Value: T): boolean;
  end;

type
  ChannelImpl<T> = class(TInterfacedObject, IChannel<T>)
  strict private
    FSendCV: TObject;
    FRecvCV: TObject;
    FClosed: boolean;
    FNeedsValue: boolean;
    FSendWaiting: boolean;
    FRecvWaiting: boolean;
    FValue: T;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Close;

    function Send(const Value: T): boolean;
    function Recv(var Value: T): boolean;
    function TrySend(const Value: T): boolean;
    function TryRecv(var Value: T): boolean;

    property NeedsValue: boolean read FNeedsValue;
    property Closed: boolean read FClosed;
  end;

  ChannelEnumerator<T> = class
  strict private
    FChannel: IChannel<T>;
    FValue: T;
  public
    constructor Create(const Channel: IChannel<T>);

    function MoveNext(): boolean;

    property Current: T read FValue;
  end;

implementation

{ ChannelImpl<T> }

procedure ChannelImpl<T>.Close;
begin
  MonitorEnter(Self);

  MonitorPulse(FSendCV);
  MonitorPulse(FRecvCV);

  FClosed := True;

  MonitorExit(Self);
end;

constructor ChannelImpl<T>.Create;
begin
  inherited Create;

  FSendCV := TObject.Create;
  FRecvCV := TObject.Create;
end;

destructor ChannelImpl<T>.Destroy;
begin
  Close;

  FSendCV.Free;
  FRecvCV.Free;

  inherited;
end;

function ChannelImpl<T>.Recv(var Value: T): boolean;
begin
  result := False;

  if (Closed) then
    exit;

  MonitorEnter(Self);

  try
    FNeedsValue := True;
    FRecvWaiting := True;

    MonitorPulse(FSendCV);

    // block until send is ready
    while ((not Closed) and (NeedsValue)) do
    begin
      MonitorWait(FRecvCV, Self, INFINITE);
    end;

    FRecvWaiting := False;

    // sender may have closed channel
    // after value was left for us
    if (Closed and NeedsValue) then
      exit;

    Value := FValue;
    result := True;
  finally
    MonitorExit(Self);
  end;
end;

function ChannelImpl<T>.Send(const Value: T): boolean;
begin
  result := False;

  if (Closed) then
    exit;

  MonitorEnter(Self);

  try
    FSendWaiting := True;

    // block until recv is waiting
    while ((not Closed) and (not NeedsValue)) do
    begin
      MonitorWait(FSendCV, Self, INFINITE);
    end;

    FSendWaiting := False;

    if (Closed) then
      exit;

    FValue := Value;
    result := True;

    FNeedsValue := False;
    MonitorPulse(FRecvCV);
  finally
    MonitorExit(Self);
  end;
end;

function ChannelImpl<T>.TryRecv(var Value: T): boolean;
begin

end;

function ChannelImpl<T>.TrySend(const Value: T): boolean;
begin

end;

{ ChannelEnumerator<T> }

constructor ChannelEnumerator<T>.Create(const Channel: IChannel<T>);
begin
  inherited Create;

  FChannel := Channel;
end;

function ChannelEnumerator<T>.MoveNext: boolean;
begin
  result := FChannel.Recv(FValue);
end;

end.
