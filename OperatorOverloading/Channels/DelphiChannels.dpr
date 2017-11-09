program DelphiChannels;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Channels in 'Channels.pas',
  Channels.Test in 'Channels.Test.pas',
  Channels.Detail in 'Channels.Detail.pas',
  Events in 'Events.pas',
  Events.Detail in 'Events.Detail.pas';

begin
  RunTests;

  WriteLn('done...');

  ReadLn;
end.
