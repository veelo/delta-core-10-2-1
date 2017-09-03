module delta.core.methods;

import core.sys.windows.windows;
import core.sys.windows.wtypes: BSTR;
import std.utf: toUTFz, encode;
import std.algorithm: each;
import std.conv: to;

import delta.core.dll;

void executeInstanceMethodReturnNoneArgsNone(int reference, string name)
{
	alias extern(Windows) void function(int, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnNoneArgsNone");
	auto fn = cast(FN) fp;
	fn(reference, pChar);
}

string executeInstanceMethodReturnEnumArgsNone(int reference, string name)
{
	alias extern(Windows) void function(int, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnEnumArgsNone");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

int executeInstanceMethodReturnIntArgsString(int reference, string name, string value)
{
	alias extern(Windows) int function(int, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnIntArgsString");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue);
}

int executeInstanceMethodReturnReferenceArgsNone(int reference, string name)
{
	alias extern(Windows) int function(int, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnReferenceArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

int executeInstanceMethodReturnReferenceArgsInt(int reference, string name, int i)
{
	alias extern(Windows) int function(int, char*, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnReferenceArgsInt");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, i);
}

void executeInstanceMethodReturnNoneArgsReference(int reference, string name, int reference2)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnNoneArgsReference");
	alias extern(Windows) void function(int, char*, int) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2);
}

int executeInstanceMethodReturnReferenceArgsString(int reference, string name, string value)
{
	alias extern(Windows) int function(int, char*, char*) FN;
	
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnReferenceArgsString");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue);
}

int executeInstanceMethodReturnIntArgsStringReference(int reference, string name, string value, int r)
{
	alias extern(Windows) int function(int, char*, char*, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeInstanceMethodReturnIntArgsStringReference");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue, r);
}

int executeClassMethodReturnReferenceArgsNone(string qualifiedName, string name)
{
	alias extern(Windows) int function(char*, char*) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeClassMethodReturnReferenceArgsNone");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName);
}

int executeClassMethodReturnReferenceArgsReference(string qualifiedName, string name, int reference)
{
	alias extern(Windows) int function(char*, char*, int) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeClassMethodReturnReferenceArgsReference");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, reference);
}

private BSTR allocateBSTR(string s)
{
	wstring ws = s.to!wstring;
	return allocateBSTR(ws);
}

private BSTR allocateBSTR(wstring ws)
{
	return SysAllocStringLen(ws.ptr, cast(UINT) ws.length);
}

void executeClassMethodReturnNoneArgsString(string qualifiedName, string name, string value)
{
	alias extern(Windows) void function(char*, char*, BSTR) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeClassMethodReturnNoneArgsString");
	auto fn = cast(FN) fp;
	
	BSTR bStr = allocateBSTR(value);
	fn(pCharQualifiedName, pCharName, bStr);
	SysFreeString(bStr);
}

string executeClassMethodReturnStringArgsStringStringString(string qualifiedName, string name, string v1, string v2, string v3)
{
	alias extern(Windows) void function(char*, char*, BSTR, BSTR, BSTR, out BSTR) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeClassMethodReturnNoneArgsStringStringString_Out_String");
	auto fn = cast(FN) fp;

	BSTR bStr1 = allocateBSTR(v1);
	BSTR bStr2 = allocateBSTR(v2);
	BSTR bStr3 = allocateBSTR(v3);
	
	BSTR bStr;
	fn(pCharQualifiedName, pCharName, bStr1, bStr2, bStr3, bStr);
	SysFreeString(bStr1);
	SysFreeString(bStr2);
	SysFreeString(bStr3);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

int executeClassMethodReturnReferenceArgsReferenceInt(string qualifiedName, string name, int reference, int i)
{
	alias extern(Windows) int function(char*, char*, int, int) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "executeClassMethodReturnReferenceArgsReferenceInt");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, reference, i);
}