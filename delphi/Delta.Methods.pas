unit Delta.Methods;

interface

uses System.SysUtils, System.Classes, System.rtti, System.TypInfo;

function executeClassMethod(const AQualifiedName, AName: string;
  const Args: array of TValue): TValue;

function executeClassMethodReturnIntArgsNone(const AQualifiedName,
  AName: PAnsiChar): Integer; stdcall;

function executeClassMethodReturnReferenceArgsNone(const AQualifiedName,
  AName: PAnsiChar): Integer; stdcall;

procedure executeClassMethodReturnNoneArgsString(const AQualifiedName,
  AName: PAnsiChar; const value: WideString); stdcall;

procedure executeClassMethodReturnNoneArgsStringStringString_Out_String
  (const AQualifiedName, AName: PAnsiChar; const v1, v2, v3: WideString;
  out value: WideString); stdcall;

procedure executeInstanceMethodReturnEnumArgsNone(const Reference: Integer;
  const AName: PAnsiChar; out value: WideString); stdcall;

function executeClassMethodReturnReferenceArgsReference(const AQualifiedName,
  AName: PAnsiChar; const Reference: Integer): Integer; stdcall;

function executeClassMethodReturnReferenceArgsReferenceInt(const AQualifiedName,
  AName: PAnsiChar; const Reference, I: Integer): Integer; stdcall;

function executeInstanceMethod(const Reference: Integer; const AName: string;
  const Args: array of TValue): TValue;

procedure executeInstanceMethodReturnNoneArgsNone(const Reference: Integer;
  const AName: PAnsiChar); stdcall;

procedure executeInstanceMethodReturnNoneArgsReference(const Reference: Integer;
  const AName: PAnsiChar; Reference2: Integer); stdcall;

function executeInstanceMethodReturnReferenceArgsNone(const Reference: Integer;
  const AName: PAnsiChar): Integer; stdcall;

function executeInstanceMethodReturnReferenceArgsString(const Reference
  : Integer; const AName, AValue: PAnsiChar): Integer; stdcall;

function executeInstanceMethodReturnReferenceArgsInt(const Reference: Integer;
  const AName: PAnsiChar; const R: Integer): Integer; stdcall;

function executeInstanceMethodReturnIntArgsString(const Reference: Integer;
  const AName, AValue: PAnsiChar): Integer; stdcall;

function executeInstanceMethodReturnIntArgsStringReference(const Reference
  : Integer; const AName, AValue: PAnsiChar; const R: Integer)
  : Integer; stdcall;

exports executeInstanceMethodReturnNoneArgsNone,
  executeInstanceMethodReturnReferenceArgsNone,
  executeInstanceMethodReturnIntArgsString,
  executeInstanceMethodReturnIntArgsStringReference,
  executeClassMethodReturnReferenceArgsNone,
  executeClassMethodReturnNoneArgsStringStringString_Out_String,
  executeInstanceMethodReturnReferenceArgsString,
  executeClassMethodReturnReferenceArgsReference,
  executeClassMethodReturnReferenceArgsReferenceInt,
  executeInstanceMethodReturnNoneArgsReference,
  executeClassMethodReturnNoneArgsString,
  executeInstanceMethodReturnEnumArgsNone,
  executeInstanceMethodReturnReferenceArgsInt;

implementation

function executeClassMethod(const AQualifiedName, AName: string;
  const Args: array of TValue): TValue;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
begin
  context := TRttiContext.Create;
  try
    try
      instType := (context.FindType(AQualifiedName) as TRttiInstanceType);
      result := instType.GetMethod(AName).Invoke(instType.MetaclassType, Args);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;

  finally
    context.Free;
  end;
end;

function executeClassMethodReturnIntArgsNone(const AQualifiedName,
  AName: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), []);
  result := value.AsInteger;
end;

procedure executeClassMethodReturnNoneArgsString(const AQualifiedName,
  AName: PAnsiChar; const value: WideString); stdcall;
begin
  executeClassMethod(string(AQualifiedName), string(AName), [string(value)]);
end;

function executeClassMethodReturnReferenceArgsNone(const AQualifiedName,
  AName: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), []);
  result := Integer(value.AsObject);
end;

function executeClassMethodReturnReferenceArgsReference(const AQualifiedName,
  AName: PAnsiChar; const Reference: Integer): Integer; stdcall;
var
  value: TValue;
  obj: TObject;
begin
  if Reference = -1 then
    obj := nil
  else
    obj := TObject(Reference);

  value := executeClassMethod(string(AQualifiedName), string(AName), [obj]);
  result := Integer(value.AsObject);
end;

function executeClassMethodReturnReferenceArgsReferenceInt(const AQualifiedName,
  AName: PAnsiChar; const Reference, I: Integer): Integer; stdcall;
var
  value: TValue;
  obj: TObject;
begin
  if Reference = -1 then
    obj := nil
  else
    obj := TObject(Reference);

  value := executeClassMethod(string(AQualifiedName), string(AName), [obj, I]);
  result := Integer(value.AsObject);
end;

function executeInstanceMethod(const Reference: Integer; const AName: string;
  const Args: array of TValue): TValue;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
  obj: TObject;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      instType := (context.GetType(obj.ClassType) as TRttiInstanceType);
      result := instType.GetMethod(AName).Invoke(obj, Args);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

procedure executeInstanceMethodReturnNoneArgsNone(const Reference: Integer;
  const AName: PAnsiChar); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), []);
end;

function executeInstanceMethodReturnReferenceArgsNone(const Reference: Integer;
  const AName: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := Integer(value.AsObject);
end;

procedure executeInstanceMethodReturnNoneArgsReference(const Reference: Integer;
  const AName: PAnsiChar; Reference2: Integer); stdcall;
var
  obj: TObject;
begin
  if Reference2 = -1 then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj]);
end;

function executeInstanceMethodReturnReferenceArgsInt(const Reference: Integer;
  const AName: PAnsiChar; const R: Integer): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [R]);
  result := Integer(value.AsObject);
end;

function executeInstanceMethodReturnReferenceArgsString(const Reference
  : Integer; const AName, AValue: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(AValue)]);
  result := Integer(value.AsObject);
end;

function executeInstanceMethodReturnIntArgsString(const Reference: Integer;
  const AName, AValue: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(AValue)]);
  result := value.AsInteger;
end;

function executeInstanceMethodReturnIntArgsStringReference(const Reference
  : Integer; const AName, AValue: PAnsiChar; const R: Integer)
  : Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName),
    [string(AValue), TObject(R)]);
  result := value.AsInteger;
end;

procedure executeInstanceMethodReturnEnumArgsNone(const Reference: Integer;
  const AName: PAnsiChar; out value: WideString); stdcall;
var
  s: String;
  methodResultValue: TValue;
begin
  methodResultValue := executeInstanceMethod(Reference, string(AName), []);
  s := methodResultValue.AsString;
  value := s;
end;

procedure executeClassMethodReturnNoneArgsStringStringString_Out_String
  (const AQualifiedName, AName: PAnsiChar; const v1, v2, v3: WideString;
  out value: WideString); stdcall;
var
  methodResultValue: TValue;
begin
  methodResultValue := executeClassMethod(string(AQualifiedName), string(AName),
    [string(v1), string(v2), string(v3)]);
  value := methodResultValue.AsString;
end;

end.
