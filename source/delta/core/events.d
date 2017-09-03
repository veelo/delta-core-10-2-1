module delta.core.events;

import std.traits;

import delta.core;

template GenEvent(string eventName, T)
{
	const char[] GenEvent =
	`private `~T.stringof~` _`~eventName~`;

	@property void `~eventName~`(`~T.stringof~` value) {
		import std.utf: toUTFz;
		import core.sys.windows.windows;
		
		_`~eventName~`= value;

		auto dlg = __traits(getOverloads, this, "`~eventName~`")[1];
		
		alias extern(Windows) void function(int, int, int) NotifyEventCallback;
		alias extern(Windows) void function(int, char*, int, int, NotifyEventCallback) Fn;
		
		void delegate(int, int, int) dg = (int delphiRef, int dRef, int funcRef) {
			TNotifyEvent ne;
			ne.funcptr = cast(void function(TObject)) funcRef;
			ne.ptr = cast(void*) dRef;
			try
			{
				ne(cast(TObject) cast(void*) dRef);
			}
			catch(Exception e)
			{
				import std.stdio;
				writeln(e.msg);
			}
		};
		
		auto pChar = toUTFz!(char*)("`~eventName~`");
		FARPROC fp = GetProcAddress(deltaLibrary.handle, "registerNotifyEvent");
		Fn fn = cast(Fn) fp;
		fn(this.reference, pChar, cast(int) dlg.ptr, cast(int) dlg.funcptr, bindDelegate(dg));	
	}
	
	@property `~T.stringof~` `~eventName~`() {
		return _`~eventName~`;
	}`;	
}

template GenEvent2(string eventName, T)
{
	const char[] GenEvent2 =
	`private `~T.stringof~` _`~eventName~`;

	@property void `~eventName~`(`~T.stringof~` value) {
		import std.utf: toUTFz;
		import core.sys.windows.windows;
		
		_`~eventName~`= value;

		auto dlg = __traits(getOverloads, this, "`~eventName~`")[1];
		
		alias extern(Windows) void function(int, int, int, ref bool) EventCallback;
		alias extern(Windows) void function(int, char*, int, int, EventCallback) Fn;
		
		void delegate(int, int, int, ref bool) dg = (int delphiRef, int dRef, int funcRef, ref bool done) {
			TIdleEvent event;
			event.funcptr = cast(void function(TObject, ref bool)) funcRef;
			event.ptr = cast(void*) dRef;
			event(cast(TObject) cast(void*) dRef, done);
		};
		
		auto pChar = toUTFz!(char*)("`~eventName~`");
		FARPROC fp = GetProcAddress(deltaLibrary.handle, "registerIdleEvent");
		Fn fn = cast(Fn) fp;
		
		if (value is null)
			fn(this.reference, pChar, cast(int) dlg.ptr, cast(int) dlg.funcptr, null);
		else
			fn(this.reference, pChar, cast(int) dlg.ptr, cast(int) dlg.funcptr, bindDelegate(dg));	
	}
	
	@property `~T.stringof~` `~eventName~`() {
		return _`~eventName~`;
	}`;	
}

auto bindDelegate(T, string file = __FILE__, size_t line = __LINE__)(T t) if(isDelegate!T) {
    static T dg;

    dg = t;

    extern(Windows)
    static ReturnType!T func(ParameterTypeTuple!T args) {
            return dg(args);
    }

    return &func;
}