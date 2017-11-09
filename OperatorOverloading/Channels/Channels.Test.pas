unit Channels.Test;

interface

uses
  System.SysUtils;

procedure RunTests;

implementation

uses
  System.Classes, Channels, Events;

procedure Test1;
var
  chan: Channel<integer>;
  producer: TThread;
  consumer: TThread;
  doneEvent: Event;
begin
  chan := Channel<integer>.Create();

  doneEvent := Event.Create();


  producer := TThread.CreateAnonymousThread(
    procedure
    var
      data: TArray<integer>;
    begin
      data := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

      chan <= data; // blocking send data over channel

      chan.Close;
    end
  );


  consumer := TThread.CreateAnonymousThread(
    procedure
    var
      v: integer;
    begin
      while (v <= chan) do // blocking read from channel
      //for v in chan do
      begin
        WriteLn(v);
      end;

      doneEvent.Signal;
    end
  );

  producer.Start;
  consumer.Start;


  doneEvent.WaitFor(INFINITE);
end;

procedure RunTests;
begin
  Test1;
end;

end.
